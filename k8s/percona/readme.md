# Percona

## Setup
First of all, clone the percona-server-mysql-operator repository:
```shell
git clone -b v0.8.0 https://github.com/percona/percona-server-mysql-operator
cd percona-server-mysql-operator
```
Note

It is crucial to specify the right branch with -b option while cloning the code on this step. Please be careful.

Now Custom Resource Definition for Percona Server for MySQL should be created from the deploy/crd.yaml file. Custom Resource Definition extends the standard set of resources which Kubernetes “knows” about with the new items (in our case ones which are the core of the operator). Apply it  as follows:


```shell
kubectl apply --server-side -f deploy/crd.yaml
```
This step should be done only once; it does not need to be repeated with the next Operator deployments, etc.

The next thing to do is to add the mysql namespace to Kubernetes, not forgetting to set the correspondent context for further steps:


```shell
kubectl create namespace mysql
$ kubectl config set-context $(kubectl config current-context) --namespace=mysql
```
Note

You can use different namespace name or even stay with the Default one.

Now RBAC (role-based access control) for Percona Server for MySQL should be set up from the deploy/rbac.yaml file. Briefly speaking, role-based access is based on specifically defined roles and actions corresponding to them, allowed to be done on specific Kubernetes resources (details about users and roles can be found in Kubernetes documentation ).


$ kubectl apply -f deploy/rbac.yaml
Note

Setting RBAC requires your user to have cluster-admin role privileges. For example, those using Google Kubernetes Engine can grant user needed privileges with the following command: $ kubectl create clusterrolebinding cluster-admin-binding --clusterrole=cluster-admin --user=$(gcloud config get-value core/account)

Finally it’s time to start the operator within Kubernetes:


$ kubectl apply -f deploy/operator.yaml
Now that’s time to add the Percona Server for MySQL Users secrets to Kubernetes. They should be placed in the data section of the deploy/secrets.yaml file as logins and plaintext passwords for the user accounts (see Kubernetes documentation  for details).

After editing is finished, users secrets should be created using the following command:


```shell
kubectl create -f deploy/secrets.yaml
````


```shell
kubectl apply -f deploy/cr.yaml
```
Creation process will take some time. The process is over when both operator and replica set pod have reached their Running status. kubectl get pods output should look like this:

NAME                                                 READY   STATUS    RESTARTS        AGE
cluster1-mysql-0                                     1/1     Running   0               7m6s
cluster1-mysql-1                                     1/1     Running   1 (5m39s ago)   6m4s
cluster1-mysql-2                                     1/1     Running   1 (4m40s ago)   5m7s
cluster1-orc-0                                       2/2     Running   0               7m6s
percona-server-for-mysql-operator-54c5c87988-xfmlf   1/1     Running   0               7m42s
Verify the cluster operation¶
To connect to Percona Server for MySQL you will need the password for the root user. Passwords are stored in the Secrets  object, which was generated during the previous steps.

Here’s how to get it:

List the Secrets objects.


$ kubectl get secrets
It will show you the list of Secrets objects (by default the Secrets object you are interested in has cluster1-secrets name).
Use the following command to get the password of the root user. Substitute cluster1 with your value, if needed:


```shell
kubectl get secret cluster1-secrets -o yaml
```
The command returns the YAML file with generated Secrets, including the root password, which should look as follows:

...
data:
...
root: <base64-encoded-password>
The actual password is base64-encoded. Use the following command to bring it back to a human-readable form:


```shell
echo '<base64-encoded-password>' | base64 --decode
```
Run a container with mysql tool and connect its console output to your terminal. The following command will do this, naming the new Pod percona-client:


```shell
kubectl run -i --rm --tty percona-client --image=percona:8.0 --restart=Never -- bash -il
```

### Login to the percona

```shell
mysql -h cluster1-haproxy -uroot -p
```

### Connect From Laravel
```dotenv
DB_CONNECTION=mysql
DB_HOST=cluster1-mysql.mysql.svc.cluster.local
DB_PORT=3306
DB_DATABASE=k8s
DB_USERNAME=root
DB_PASSWORD=root_password
```
### Horizontal Scaling
```shell
kubectl patch ps cluster1 --type='json' -p='[{"op": "replace", "path": "/spec/mysql/size", "value": 5 }]'
```
