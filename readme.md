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

## Creating a Deployment
We can start create a very first deployment using a public docker image.
```shell
kubectl create deployment nginx-deployment --image=nginx
```

The above deployment can be exposed outside the container & kubernetes using expose command.
```shell
kubectl expose deployment nginx-deploment --type=LoadBalancer --port=8080 --target-port=80
```
The above command creates a service for the 'nginx-deployment' deployment with a LoadBalancer type, enabling access to our Kubernetes cluster from outside the container.

## Build Docker Image

Since k8 can't use local docker image, so we need to push it to the container registry. To build php image

```bash
docker build -t 9813276057/application-php ./php/
```

To build the nginx Image

```bash
docker build -t 9813276057/application-nginx ./nginx/
```

After building the images, push it to the container hub:

```bash
docker push 9813276057/application-php
```

```bash
docker push 9813276057/application-nginx
```

## Install kubectl

## Install minikube

## Create a deployment

```shell
kubectl create deployment nginx-deployment --image=nginx
```

| Commands                                      | Descriptions                   |
|-----------------------------------------------|--------------------------------|
| `kubectl get pods`                            | Get all the pods               |
| `kubectl get pods -o wide`                    | get all pods with IP addresses |
| `kubectl descrive pod nignx-65cfcbff97-b8ccx` | Get the details of a pod       |



| Commands                           | Descriptions               | 
|------------------------------------|----------------------------|
| `kubectl get deployments`          | Get all the deployments    |
| `kubectl delete deployments --all` | delete all the deployments | 

## Services

Consider we need to expose nginx port 80 to outside the container & kubernetes.

```shell
kubectl expose deployment nginx-deployment --port=8080 --target-port=80
```

| Commands                                   | Descriptions         |
|--------------------------------------------|----------------------|
| `kubectl get services`                     | Get all the services |
| `kubectl describe service nginx-deployment | Detail of a service  |

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
