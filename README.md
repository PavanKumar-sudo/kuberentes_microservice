# Kubernetes Microservices Deployment (Terraform + Helm)


This repository contains:

Terraform scripts to create Kubernetes clusters on AWS EKS, Azure AKS, and Google GKE.

A Helm chart (microservice_helmchart/) to deploy all 4 microservices (auth-service, order-service, product-service, user-service).

Dockerized microservices stored in respective folders inside microservice/.



---

## 📂 Repository Structure

```
.
├── aws/                      # Terraform code for AWS EKS cluster
├── azure/                    # Terraform code for Azure AKS cluster
├── GKE/                      # Terraform code for Google GKE cluster
├── microservice/             # Python microservices source code
│   ├── auth-service/
│   ├── order-service/
│   ├── product-service/
│   └── user-service/
├── microservice_helmchart/   # Helm chart to deploy all microservices
│   ├── templates/
│   │   ├── configmap.yaml
│   │   ├── deployment.yaml
│   │   ├── hpa.yaml
│   │   ├── ingress.yaml
│   │   ├── secret.yaml
│   │   └── service.yaml
│   └── values.yaml
└── README.md
```

---

# 1️⃣ Terraform – Create Kubernetes Cluster

### 📌 AWS EKS

```bash
cd aws
terraform init
terraform apply -auto-approve
aws eks update-kubeconfig --name eks-prod-cluster --region us-east-1
kubectl get nodes
```

### 📌 Azure AKS

```bash
cd azure
terraform init
terraform apply -auto-approve
az aks get-credentials --resource-group myResourceGroup --name myAKSCluster --overwrite-existing
kubectl get nodes
```

### 📌 Google GKE

```bash
cd GKE
terraform init
terraform apply -auto-approve
gcloud container clusters get-credentials private-gke-cluster --region us-central1 --project pavan-tf-project
kubectl get nodes
```

---

# 2️⃣ Install Helm

```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version
```

---

# 3️⃣ Install NGINX Ingress Controller

### ✅ For AWS EKS

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/aws-load-balancer-type"="nlb" \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/aws-load-balancer-scheme"="internet-facing" \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/aws-load-balancer-nlb-target-type"="ip"
```

### ✅ For Azure AKS

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  --set controller.service.externalTrafficPolicy=Local
```

### ✅ For Google GKE

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace
```

### 🔍 Verify Ingress

```bash
kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx ingress-nginx-controller
```

---

# 4️⃣ Deploy Metrics Server (Optional for HPA)

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# For EKS – patch deployment to allow insecure TLS
kubectl patch deployment metrics-server -n kube-system \
  --type=json \
  -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]'
```

---

# 5️⃣ Deploy Microservices Helm Chart

```bash
cd microservice_helmchart
helm lint .
helm upgrade --install my-microservices ./microservice_helmchart \
  --namespace default --create-namespace
```

### 🔍 Verify Deployment

```bash
kubectl get pods
kubectl get svc
kubectl get ingress
```

Get ingress external IP:

```bash
kubectl get svc -n ingress-nginx ingress-nginx-controller
```

Access services in browser:

```
http://<EXTERNAL-IP>/
```

---

# 🚀 What Can You Do Next?

✅ **Automate Everything:**

* Use Terraform Helm provider to deploy ingress and Helm charts automatically.
* Create a GitHub Actions pipeline (`.github/workflows/deploy.yml`) for CI/CD.

✅ **Add CI/CD for Microservices:**

* Build Docker images using GitHub Actions.
* Push images to Docker Hub or AWS ECR / Azure ACR / GCP Artifact Registry.
* Automatically deploy the latest version to the cluster.

✅ **Add Monitoring & Logging:**

* Install Prometheus, Grafana, and Loki using Helm.
* Collect metrics and logs for all services.

✅ **Add Security & Scalability:**

* Enable Horizontal Pod Autoscaler (HPA) and PodDisruptionBudgets.
* Integrate secrets with AWS Secrets Manager, Azure Key Vault, or Google Secret Manager.

✅ **Create Production-Ready Setup:**

* Add TLS/SSL certificates using cert-manager.
* Set up custom domains using Ingress.

✅ **Implement Blue-Green / Canary Deployments:**

* Use Helm hooks or Argo Rollouts for advanced deployment strategies.
