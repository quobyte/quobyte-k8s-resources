# Quobyte Kubernetes Resources

This repository collects all resources needed to

* Set up Quobyte clients and CSI drivers to consume persistent storage
* Set up a Quobyte cluster to provide persistent storage

All charts are published as OCI artifacts to `quay.io/quobyte/charts/`.

## Consuming Storage

To access a Quobyte cluster from Kubernetes
the "quobyte-client" and "quobyte-csi" charts need to be deployed:

Available or new chart versions can be listed with (requires [oras](https://oras.land/docs/installation/))

```
./list_versions.sh <quobyte-csi|quobyte-client|quobyte-cluster>
```

To see all available chart values for a specific chart:

```
helm show values oci://quay.io/quobyte/charts/<myChart> --version <version>
```

Install a chart version with

```
helm install oci://quay.io/quobyte/charts/quobyte-csi --version <version> [overrides]
helm install oci://quay.io/quobyte/charts/quobyte-client --version <version> [overrides]
```

## Providing Storage

Installing a Quobyte cluster requires a single Helm chart:
```
helm install my-storage-cluster oci://quay.io/quobyte/charts/quobyte-cluster --version <version>
```

Please have a look at [requirements document](Requirements.md) if you consider to run Quobyte for production workloads.


To see all available chart values for a specific chart:
