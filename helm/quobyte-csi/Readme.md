# Quobyte CSI Helm Chart

## Requirements

* Kubernetes >= v1.22.x
* helm

## Install Quobyte CSI Driver

This Helm Chart can be installed as usual:

``` 
helm install my-storage-csi oci://quay.io/quobyte/charts/quobyte-csi --version <version> [overrides]
``` 

To see all available chart values for the Quobyte csi Helm chart:
``` 
helm show values oci://quay.io/quobyte/charts/quobyte-csi
``` 

## Quobyte CSI logs collector

Log collector gathers logs from all the Quobyte CSI containers in single place for analysis.
 It also generates tar that can be uploaded with support ticket.  

1. Get the log_collector utility script on any node with working kubectl

    ```bash
    wget https://raw.githubusercontent.com/quobyte/quobyte-k8s-resources/master/helm/\
    log_collector.sh && chmod +x log_collector.sh
     
    ```

2. Run the log_collector

    ```bash
    DRIVER_NAMESPACE="<quobyte-csi-driver-namespace>" ./log_collector.sh
    ```

    For example, if the Quobyte CSI driver is deployed in `quobyte-ns` then you need to run

    ```bash
    DRIVER_NAMESPACE="quobyte-ns" ./log_collector.sh
    ```

3. Logs can be found under the directory `./csi_logs` for analysis.

4. Script also generates the tar of `./csi_logs` as `quobyte_csi_logs.tar.gz`.
 Please upload the tar with Quobyte support ticket.
