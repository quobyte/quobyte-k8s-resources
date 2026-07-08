## Quobyte-client Helm Chart

This Helm chart installs the Quobyte client 
as a `daemonset` to your worker nodes. 
This will allow to mount Quobyte volumes 
and consume persistent storage from containers.

This Helm Chart can be installed as usual:

``` 
helm repo add quobyte https://quobyte.github.io/quobyte-k8s-resources/helm-charts
helm repo update
helm install my-storage-client quobyte/quobyte-client
``` 

## Restrict client pods to a single NUMA node

1. Enable following feature gates in the kubelet configuration on all the k8s hosts

    ```bash
    - "topology-manager-policy=single-numa-node" # single-numa-node/best-effort
    - "cpu-manager-policy=static" # Requires static allocation
    - "kube-reserved=cpu=500m,memory=512Mi" # Adjust as required
    - "system-reserved=cpu=500m,memory=512Mi" # Adjust as required
    ```

    Remove /var/lib/kubelet/cpu_manager_state and restart kubelet service.

    Verify that the configuration is effective using `cat  /var/lib/kubelet/cpu_manager_state`. The
    output should look like the follwoing with `"policyName":"static"`

    ```bash
    {"policyName":"static","defaultCpuSet":"1-16","checksum":...}
    ```

2. Install scheduler plugin with the name `topology-aware-scheduler`

    ```bash
    helm install scheduler-plugins scheduler-plugins \
        --repo https://scheduler-plugins.sigs.k8s.io \
        --create-namespace \ 
        --namespace scheduler-plugins \ 
        --set scheduler.name="topology-aware-scheduler" \ 
        --set controller.enabled=true
    ```

3. Install `quobyte/quobyte-client` chart with `schedulerName: topology-aware-scheduler` and with
   matching resource requests and limits.

4. Verify the NUMA node assignment to the quobyte-client pods using the command 
  `cat /var/lib/kubelet/cpu_manager_state | grep quobyte-client` on k8s nodes. CPUs from a single
  node must be allocated to the quobyte-client pod.
