# Restart all the deployment
kubectl delete deployments --all

kubectl create secret generic env-secret --from-env-file=./application/.env --dry-run=client -o yaml > k8s/env-secret.yaml
kubectl apply -f k8s/env-secret.yaml

# Mysql
kubectl apply -f k8s/mysql-pvc.yaml
kubectl apply -f k8s/mysql-deployment.yaml
kubectl apply -f k8s/mysql-service.yaml

# PHP
kubectl apply -f k8s/php-deployment.yaml
kubectl apply -f k8s/php-service.yaml

# Nginx
kubectl apply -f k8s/nginx-deployment.yaml
kubectl apply -f k8s/nginx-service.yaml

