# Quobyte Kubernetes Resources

This repository collects all resources needed to 

* Consume Quobyte volume storage as persistent volumes (PVs) from Kubernetes containers
* Set up a Quobyte cluster to provide persistent storage

## Consuming Storage

To access a Quobyte cluster from Kubernetes 
"quobyte-client" and "quobyte-csi" needs to be deployed:

```
helm repo add quobyte https://quobyte.github.io/quobyte-k8s-resources/helm-charts
helm install my-storage-client quobyte/quobyte-client
helm install my-storage-csi quobyte/quobyte-csi
```

## Providing Storage

Installing a Quobyte cluster requires a single Helm chart:
```
helm repo add quobyte https://quobyte.github.io/quobyte-k8s-resources/helm-charts
helm install my-storage-cluster quobyte/quobyte-cluster
```
