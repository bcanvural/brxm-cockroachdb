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

To be able to work with the docker daemon on your mac/linux host use the docker-env command in your shell
```bash
eval $(minikube docker-env)
```

# Local dev

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
# Deploying

Build hippo project, and build docker image

```bash
./build.sh
```

Deploy hippo in the cluster

Change the conf/context.xml connection string :

```xml
<!--snip-->
url="jdbc:postgresql://mycockroach-cockroachdb-public.default.svc.cluster.local:26257/repositoryds"/>
<!--snip-->

```

```bash
kubectl apply -f kubernetes/hippo-deployment.yaml
```
