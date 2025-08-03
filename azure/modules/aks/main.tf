resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  address_space       = [var.vnet_cidr]
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags
}

resource "azurerm_subnet" "aks" {
  name                 = var.aks_subnet_name != "" ? var.aks_subnet_name : "aks-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.aks_subnet_cidr]

  delegation {
    name = "aks-delegation"

    service_delegation {
      name    = "Microsoft.ContainerService/managedClusters"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

# --- CORRECTED: Single Network Security Group for AKS Node Subnet with all rules ---
# This resource now contains both HTTP and HTTPS inbound rules.
# The duplicate 'aks_node_nsg2' resource has been removed.
resource "azurerm_network_security_group" "aks_node_nsg" {
  name                = "${var.cluster_name}-node-nsg" # Use the desired name for your NSG
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name # Place NSG in your main RG for management
  tags                = var.tags

  # Inbound Rule to allow HTTP (Port 80) from Internet
  security_rule {
    name                        = "AllowHTTPInbound"
    priority                    = 100 # Ensure this is a low number (high priority)
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "80"
    source_address_prefix       = "Internet"
    destination_address_prefix  = "*"
  }

  # Inbound Rule to allow HTTPS (Port 443) from Internet
  security_rule {
    name                        = "AllowHTTPSInbound"
    priority                    = 101 # Ensure this is a low number (high priority)
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "443"
    source_address_prefix       = "Internet"
    destination_address_prefix  = "*"
  }

  # You might want to add other essential AKS inbound rules here if needed,
  # such as for Kubernetes API server access from specific IPs, etc.
}

# --- NEW: Associate the Custom NSG with the AKS Subnet ---
# This now correctly points to the single NSG with the rules
resource "azurerm_subnet_network_security_group_association" "aks_nsg_association" {
  subnet_id                     = azurerm_subnet.aks.id
  network_security_group_id     = azurerm_network_security_group.aks_node_nsg.id # Pointing to the correct NSG
  depends_on = [
    azurerm_subnet.aks,
    azurerm_network_security_group.aks_node_nsg
  ]
}

resource "azurerm_log_analytics_workspace" "main" {
  count               = var.cluster_log_analytics_workspace_name != "" ? 1 : 0
  name                = var.cluster_log_analytics_workspace_name
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  dns_prefix          = var.prefix
  kubernetes_version  = var.k8s_version

  default_node_pool {
    name                 = "default"
    vm_size              = "Standard_B2s"
    node_count           = 1
    # enable_auto_scaling = false # Commented out as per your original code
    orchestrator_version = var.k8s_version
  }

  identity {
    type = "SystemAssigned"
  }

  workload_identity_enabled = true
  oidc_issuer_enabled       = true

  azure_active_directory_role_based_access_control {
    tenant_id              = var.tenant_id
    admin_group_object_ids = var.admin_group_object_ids
    azure_rbac_enabled     = true
  }

  network_profile {
    network_plugin    = var.network_plugin
    load_balancer_sku = var.load_balancer_sku
    service_cidr      = var.service_cidr
    dns_service_ip    = var.dns_service_ip
    outbound_type     = "loadBalancer"
  }

  role_based_access_control_enabled   = true
  private_cluster_enabled             = false
  private_cluster_public_fqdn_enabled = false

  dynamic "oms_agent" {
    for_each = var.cluster_log_analytics_workspace_name != "" ? [1] : []
    content {
      log_analytics_workspace_id = azurerm_log_analytics_workspace.main[0].id
    }
  }

  sku_tier = var.sku_tier
  tags     = var.tags

  depends_on = [
    azurerm_subnet.aks,
    azurerm_subnet_network_security_group_association.aks_nsg_association # Added dependency
  ]
}

resource "azurerm_kubernetes_cluster_node_pool" "systemnp" {
  name                  = var.system_node_pool_name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  mode                  = "System"
  vm_size               = var.system_vm_size
  os_disk_size_gb       = var.system_os_disk_size_gb
  os_sku                = var.system_os_sku
  node_count            = var.system_node_count
  max_pods              = var.system_max_pods
  #availability_zones    = var.system_az_zones # Commented out as per your original code
  #enable_node_public_ip = false # Commented out as per your original code
  node_labels           = var.system_node_labels
  node_taints           = var.system_node_taints
  # type                = "VirtualMachineScaleSets" # Commented out as per your original code
}

resource "azurerm_kubernetes_cluster_node_pool" "usernp" {
  name                  = var.user_node_pool_name
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  mode                  = "User"
  vm_size               = var.user_vm_size
  os_disk_size_gb       = var.user_os_disk_size_gb
  os_sku                = var.user_os_sku
  #enable_auto_scaling   = var.user_enable_auto_scaling # Commented out as per your original code
  #min_count             = var.user_min_count # Commented out as per your original code
  #max_count             = var.user_max_count # Commented out as per your original code
  #node_count            = null # ✅ This is needed to avoid conflict # Commented out as per your original code
  max_pods              = var.user_max_pods
  #availability_zones    = var.user_az_zones # Commented out as per your original code
  #enable_node_public_ip = false # Commented out as per your original code
  node_labels           = var.user_node_labels
  node_taints           = var.user_node_taints
  #type                  = "VirtualMachineScaleSets" # Commented out as per your original code
}
