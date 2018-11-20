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

Port-forward from localhost to cockroachdb service within cluster:

```bash
kubectl port-forward svc/mycockroach-cockroachdb-public 26257:26257
```


To be able to work with the docker daemon on your mac/linux host use the docker-env command in your shell
```bash
eval $(minikube docker-env)
```

Build hippo project, and build docker image

```bash
./build.sh
```

Deploy hippo in the cluster

```bash
kubectl apply -f kubernetes/hippo-deployment.yaml
```
