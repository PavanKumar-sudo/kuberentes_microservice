# Kubernetes Helm Manual Setup Guide

This guide explains how to manually install Helm, configure kubectl, install NGINX Ingress Controller, and deploy microservices Helm charts on **EKS**, **AKS**, and **GKE** clusters.

---

## 📌 1. Install Helm (Common for All)

```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
helm version
```

---

## 📌 2. AWS EKS (Elastic Kubernetes Service)

### ✅ 2.1 Configure kubectl

```bash
aws eks update-kubeconfig --name eks-prod-cluster --region us-east-1
kubectl get nodes
```

### ✅ 2.2 Install NGINX Ingress Controller

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/aws-load-balancer-type"="nlb" \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/aws-load-balancer-scheme"="internet-facing" \
  --set controller.service.annotations."service\.beta\.kubernetes\.io/aws-load-balancer-nlb-target-type"="ip"
```

### ✅ 2.3 Verify

```bash
kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx ingress-nginx-controller
```

---

## 📌 3. Azure AKS (Azure Kubernetes Service)

### ✅ 3.1 Configure kubectl

```bash
az aks get-credentials --resource-group myResourceGroup --name myAKSCluster --overwrite-existing
kubectl get nodes
```

### ✅ 3.2 Install NGINX Ingress Controller

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  --set controller.service.externalTrafficPolicy=Local
```

### ✅ 3.3 Verify

```bash
kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx ingress-nginx-controller
```

---

## 📌 4. Google GKE (Google Kubernetes Engine)

### ✅ 4.1 Configure kubectl

```bash
gcloud container clusters get-credentials private-gke-cluster --region us-central1 --project pavan-tf-project
kubectl get nodes
```

### ✅ 4.2 Install NGINX Ingress Controller

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace
```

### ✅ 4.3 Verify

```bash
kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx ingress-nginx-controller
```

---

## 📌 5. Deploy Metrics Server (Optional for HPA)

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# For EKS – patch deployment to allow insecure TLS
kubectl patch deployment metrics-server -n kube-system \
  --type=json \
  -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--kubelet-insecure-tls"}]'
```

---

## 📌 6. Deploy Your Microservices Helm Chart

### ✅ 6.1 Package & Install Your Chart

```bash
cd microservice_helmchart
helm lint .

helm upgrade --install my-microservices ./microservice_helmchart \
  --namespace default --create-namespace
```

### ✅ 6.2 Verify Deployment

```bash
kubectl get pods
kubectl get svc
kubectl get ingress
```

---

## 📌 7. Access Your Services

1. Get the **EXTERNAL-IP** of the ingress controller:

   ```bash
   kubectl get svc -n ingress-nginx ingress-nginx-controller
   ```
2. Open in browser:

   ```
   http://<EXTERNAL-IP>/
   ```

---

✅ **Follow these steps for EKS, AKS, and GKE as per the cluster you are working on.**
