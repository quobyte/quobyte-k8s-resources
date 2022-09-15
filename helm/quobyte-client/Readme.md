# Quobyte-client Helm Chart

This Helm chart installs the Quobyte client 
as a daemonset to your worker nodes. 
This will allow to mount Quobyte volumes 
and consume persistent storage from containers.

This Helm Chart can be installed as usual:

``` 
helm repo add quobyte https://quobyte.github.io/quobyte-k8s-resources/helm-charts
helm repo update
helm install my-storage-client quobyte/quobyte-client
``` 


