#!/bin/bash

set -e

echo "Deploying User Service to Local Kubernetes..."

echo -e "\nChecking prerequisites..."

if ! command -v minikube &> /dev/null; then
    echo "Minikube is not installed, please install Minikube"
    exit 1
fi
echo "Minikube found"

if ! command -v kubectl &> /dev/null; then
    echo "kubectl is not installed, please install kubectl"
    exit 1
fi
echo "kubectl found"

if ! minikube status &> /dev/null; then
    echo -e "\n Starting Minikube..."
    minikube start --driver-docker --cpus=4 --memory=8192
fi

echo -e "\nEnabling Ingress addon..."
minikube addons enable ingress

echo -e "\nBuilding Docker image..."
mvn clean package -DskipTests
docker build -t user-servie:lates .

echo -e "\nLoading image into Minikube..."
minikube image load user-service:latest

echo -e "\nCreating namespace..."
kubectl apply -f k8s/staging/namespace.yaml

echo -e "\nDeploying PostgreSQL..."
kubectl apply -f k8s/database/postgres-deployment.yaml

echo "Waiting for PostgreSQL to be ready..."
kubectl wait --for=condition=ready pod -l app=postgres -n staging --timeout=120s

echo -e "\nDeploying application..."
sed 's|user-service:latest|g' k8s/staging/deployment.yaml | kubectl apply -f -
kubectl apply -f k8s/staging/configmap.yaml
kubectl apply -f k8s/staging/secret.yaml
kubectl apply -f k8s/staging/service.yaml
kubectl apply -f k8s/staging/serviceaccount.yaml

echo "Waiting for deployment to be ready..."
kubectl rollout status deployment/user-service -n staging --timeout=5m

echo -e "\n======================================="
echo -e "Deployment complete!"
echo -e "======================================="
echo ""
echo "Access the application:"
echo "  minikube service user-service -n staging"
echo ""
echo "Or use port-forward:"
echo "  kubectl port-forward svc/user-service 8080:80 -n staging"
echo "  Then visit: http://localhost:8080/api/users"
echo ""
echo "View pods:"
echo "  kubectl get pods -n staging"
echo ""
echo "View logs:"
echo "  kubectl logs -f deployment/user-service -n staging"
echo ""