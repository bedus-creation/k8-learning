# Restart all the deployment
kubectl delete deployments --all

# Create kubernetes secret from env
kubectl create secret generic env-secret --from-env-file=./application/.env --dry-run=client -o yaml > k8s/env-secret.yaml
kubectl apply -f k8s/env-secret.yaml

# Mysql
kubectl apply -f k8s/mysql-pvc.yaml
kubectl apply -f k8s/mysql-deployment.yaml
kubectl apply -f k8s/mysql-service.yaml

# PHP
kubectl apply -f k8s/php-deployment.yaml
kubectl apply -f k8s/php-service.yaml
