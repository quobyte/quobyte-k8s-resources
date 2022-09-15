# Quobyte CSI Helm Chart

This Helm Chart will install the Quobyte CSI
driver to your Kubernetes Cluster.

The CSI plugin will allow dynamic provisioning 
of persistent volumes in Kubernetes.

To successfully use these pesistent volumes 
you will also need the Quobyte client deployed
on your worker nodes.

This Helm Chart can be installed as usual:

``` 
helm repo add quobyte https://quobyte.github.io/quobyte-k8s-resources/helm-charts
helm repo update
helm install my-storage-csi quobyte/quobyte-csi
``` 


