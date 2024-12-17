# Kubernetes Learning
* [x] Hello world application in Kubernetes
* [x] Build a custom docker image for PHP, nginx application & publish to the docker Hub
* [x] Write a deployment script for PHP,Nginx & Mysql using the custom docker image build previously
* [x] Install laravel application and configured to run inside kubernetes clusters
* [ ] Scale the Laravel application horizontally
* [ ] Write more advance scaling logic to scale application based on cpu use etc.
* [ ] Load Test
* [ ] Scale MySQL database using [Vitess](https://planetscale.com/blog/what-is-vitess)
* [ ] use redis as session storage and scale it

## Pod, Service & Deployment
A Pod is the smallest deployable unit in Kubernetes. It represents a single instance of a running process in your cluster.

### Service
A Service is an abstraction that defines a logical set of Pods and provides a stable endpoint to access them. It enables communication between Pods or external clients and Pods.

Key Characteristics:
* Stable Networking: Provides a consistent IP address and DNS name, even as Pods are replaced or scaled.
* Load Balancing: Distributes traffic across multiple Pods matching its selector. 
  * Service Types:
    * ClusterIP (default): Internal communication within the cluster. 
    * NodePort: Exposes the service on a port of each node for external access. 
    * LoadBalancer: Exposes the service externally using a cloud provider's load balancer. 
    * ExternalName: Maps the service to an external DNS name

### Deployment
A Deployment is a controller that manages Pods and ensures they are running in the desired state. It allows you to define and manage the number of replicas (instances), updates, and rollbacks for your application.

### Install kubectl
The Kubernetes command-line tool, kubectl, allows you to run commands against Kubernetes clusters. You can use kubectl to deploy applications, inspect and manage cluster resources, and view logs.
[Link](https://kubernetes.io/docs/tasks/tools/)

## Hello World in Kubernetes
We can start create a very first deployment using a public docker image.
```shell
kubectl create deployment nginx-deployment --image=nginx
```

The above deployment can be exposed outside the container & kubernetes using expose command.
```shell
kubectl expose deployment nginx-deploment --type=LoadBalancer --port=8080 --target-port=80
```
The above command creates a service for the 'nginx-deployment' deployment with a LoadBalancer type, enabling access to our Kubernetes cluster from outside the container.

You can use following commands to get details about pods:

| Commands                                      | Descriptions                   |
|-----------------------------------------------|--------------------------------|
| `kubectl get pods`                            | Get all the pods               |
| `kubectl get pods -o wide`                    | get all pods with IP addresses |
| `kubectl describe pod nignx-65cfcbff97-b8ccx` | Get the details of a pod       |

You can use following commands to get details about deployments:

| Commands                           | Descriptions               | 
|------------------------------------|----------------------------|
| `kubectl get deployments`          | Get all the deployments    |
| `kubectl delete deployments --all` | delete all the deployments | 

## Services

| Commands                                   | Descriptions         |
|--------------------------------------------|----------------------|
| `kubectl get services`                     | Get all the services |
| `kubectl describe service nginx-deployment` | Detail of a service  |

The `kubectl get services` returns the following:
```shell
kubectl get services
NAME                TYPE           CLUSTER-IP        EXTERNAL-IP    PORT(S)          AGE
php                 ClusterIP      192.168.194.147   <none>         9000/TCP         35h
kubernetes          ClusterIP      192.168.194.129   <none>         443/TCP          35h
nginx               NodePort       192.168.194.181   <none>         8080:32539/TCP   35h
nginx-deploment-1   LoadBalancer   192.168.194.248   198.19.249.2   8081:32479/TCP   34h
mysql               NodePort       192.168.194.218   <none>         4406:32740/TCP   105m
```
* nginx-deployment-1 Service:
External IP: 198.19.249.2 (assigned via LoadBalancer) and Exposed Port (NodePort): 32479, so it can be accessed from `http://198.19.249.2:32539`

* NodePort Service (nginx):
For NodePort services, the application is accessible via: `http://<node-ip>:32539` Here, <node-ip> refers to the IP of the node running the cluster. If it's running on orbstack: `kubectl get nodes 
-o wide` to get `<node-ip>`.

### Load-balancer

### Minikube Dashboard

| Commands            | Descriptions                 |
|---------------------|------------------------------|
| `minikube start`    |                              |
| `minikube dashboard | Start the minikube dashboard | 

### Exposing Application
If your service type is ClusterIP (default), it’s only accessible within the cluster. Access via kubectl port-forward: Forward the service port to your local machine:
```bash
kubectl port-forward svc/nginx 8080:80
```

To check if nginx is working
```shell
kubectl logs <nginx-pod-name>
```

### Scaling 
Scaling a deployment by running the following commands:
```shell
kubectl scale deployment <nginx-deployment> --replicas=1
```

### Applying changes
```shell
kubectl apply -f k8s/nginx-service.yaml
```

## Managing .ENV
Kubernetes allows to create a secret based on .env file, and these secret can be referenced to create a deployment scripts.
```shell
kubectl create secret generic env-secret --from-env-file=./application/.env --dry-run=client -o yaml > k8s/env-secret.yaml
```


## Debugging
You can use the following command to view the details of all Pods, or specify a Pod name to inspect a particular Pod.

| Commands                                        | Descriptions                 |
|-------------------------------------------------|------------------------------|
| `kubectl describe pod`                          |                              |
| `kubectl describe pod <podname> -n <namespace>` | Start the minikube dashboard | 

## SSH Connection
A pod can be accessed with SSH Connection as:

| Commands                                        | Descriptions                 |
|-------------------------------------------------|------------------------------|
| `kubectl exec -it <POD> -- <COMMAND>`           |                              |

Example of database connection from PHP cluster:
```php
<?php
$servername = "mysql";
$username   = "root";
$password   = "12345678";
$database   = "jh";
$port       = 4406;

$conn = new mysqli($servername, $username, $password, $database, $port);

if ($conn->connect_error) {
    die("Connection failed: ".$conn->connect_error);
}
echo "Connected successfully!";
```

## Deploying custom docker Image with k8:
Since k8 can't use local docker image, so we need to push it to the container registry. To build php image

```bash
docker build -t 9813276057/application-php:v0.0.1 ./php/
```

To build the nginx Image

```bash
docker build -t 9813276057/application-nginx ./nginx/
```

After building the images, push it to the container hub:

```bash
docker push 9813276057/application-php:v0.0.1
```

```bash
docker push 9813276057/application-nginx
```
