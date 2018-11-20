# Run brXM on CockroachDB

Start minikube with some additional resources

```bash
minikube --memory 8192 --cpus 2 start
```

Start helm (install helm if missing https://helm.sh/)

```bash
helm init
```

Setup tiller for helm

```bash
kubernetes/tiller_setup.sh
```

Start cockroachdb cluster

```bash
kubernetes/install_cockroach.sh
```

## Start a client pod to create a db named repositoryds (only once)
```bash
    kubectl run -it --rm cockroach-client \
        --image=cockroachdb/cockroach \
        --restart=Never \
        --command -- ./cockroach sql --insecure --host mycockroach-cockroachdb-public.default
```

create the db:

```sql
create database repositoryds;
```

# Deployment/Working options

See "Local dev" OR "Local cluster" below.

## Local dev

Port-forward from localhost to cockroachdb service within cluster:

```bash
kubectl port-forward svc/mycockroach-cockroachdb-public 26257:26257
```

Change the conf/context.xml connection string to localhost one:
```xml
<!--snip-->
...
url="jdbc:postgresql://localhost:26257/repositoryds">
<!--snip-->
```
Run 
```bash
mvn clean verify && mvn -Pcargo.run
```
## Local cluster

To be able to work with the docker daemon on your mac/linux host use the docker-env command in your shell
```bash
eval $(minikube docker-env)
```

Build hippo project, and build docker image

```bash
./build.sh
```

Change the conf/context.xml connection string :

```xml
<!--snip-->
url="jdbc:postgresql://mycockroach-cockroachdb-public.default.svc.cluster.local:26257/repositoryds"/>
<!--snip-->

```
Deploy:

```bash
kubectl apply -f kubernetes/hippo-deployment.yaml
```

Add an entry in your /etc/hosts file. Replace <minikube_ip> with the output of the command:

```bash
minikube ip
```
Add the following line in your /etc/hosts file:
```text
<minikube_ip> hippo.site hippo.cms
```
 
Enable ingress addon in minikube
```bash
minikube addons enable ingress
```

Apply ingress rules to access the cluster

```bash
kubectl apply -f kubernetes/ingress.yaml
```

Then visit http://hippo.cms/cms

