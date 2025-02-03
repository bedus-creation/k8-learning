# Restart all the deployment
kubectl delete deployments --all

# Create kubernetes secret from env
kubectl create secret generic env-secret --from-env-file=./application/.env --dry-run=client -o yaml > k8s/env-secret.yaml
kubectl apply -f k8s/env-secret.yaml

# Mysql
# kubectl apply -f k8s/mysql-pvc.yaml
# kubectl apply -f k8s/mysql-deployment.yaml
# kubectl apply -f k8s/mysql-service.yaml

# MySQL Vitess
# kubectl apply -f k8s/vitess/operator.yaml
# kubectl apply -f k8s/vitess/bundle.yaml

# MySQL Percona
kubectl apply --server-side -f k8s/percona/crd.yaml
kubectl create namespace mysql
kubectl config set-context $(kubectl config current-context) --namespace=mysql
kubectl apply --server-side -f k8s/percona/rbac.yaml
kubectl apply -f k8s/percona/operator.yaml
kubectl create -f k8s/percona/secrets.yaml
kubectl create -f k8s/percona/cr.yaml

# PHP
kubectl apply -f k8s/php-deployment.yaml
kubectl apply -f k8s/php-service.yaml
