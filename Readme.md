# Quobyte Kubernetes Resources

This repository collects all resources needed to 

* Set up a Quobyte cluster to provide persistent storage
* Set up Quobyte clients and CSI drivers to consume persistent storage

## Providing Storage

Installing a Quobyte cluster requires a single Helm chart:
```
helm repo add quobyte https://quobyte.github.io/quobyte-k8s-resources/helm-charts
helm install my-storage-cluster quobyte/quobyte-cluster
```

Please have a look at [requirements document](Requirements.md) if you consider to run Quobyte for production workloads.

## Consuming Storage

To access a Quobyte cluster from Kubernetes 
"quobyte-client" and "quobyte-csi" charts need to be deployed:

```
helm repo add quobyte https://quobyte.github.io/quobyte-k8s-resources/helm-charts
helm install my-storage-client quobyte/quobyte-client
helm install my-storage-csi quobyte/quobyte-csi
```


To see all available chart values for a specific chart:

```
helm show values quobyte/quobyte-<myChart>
```

To get the most recent helm charts:

```
helm repo update quobyte
```
