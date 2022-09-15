## Usage

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

    helm repo add quobyte https://quobyte.github.io/quobyte-k8s-resources/helm-charts

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
quobyte` to see the charts.

For example to install the quobyte client chart:

    helm install my-storage-client quobyte/quobyte-client

To uninstall the chart:

    helm delete my-storage-client
