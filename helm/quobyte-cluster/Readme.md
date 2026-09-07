# Quobyte Cluster Helm Chart, privileged mode


## General set up

This Helm Chart will install a Quobyte storage cluster.
Containers will run in privileged mode, thus being able
to use storage devices located on the worker nodes.

These storage devices can be used as data- and metadata
devices for Quobyte.

The registry state can be stored either locally (by providing pre-provisioned
volumes that match the pvc) or use a standard/ default storage class provided
by the k8s cluster.

This parameter can be adjusted by using "storageclassRegistry" parameter in values.yaml

## S3 speicific set up

### DNS 
S3 requires a valid DNS set up with wild card records pointing to the S3 service.
https://docs.quobyte.com/docs/16/latest/s3_gateway.html#hostname-setup

The S3 domain needs to be configured in the webconsole (or using ```qmgmt systemconfig edit ```):

"Configuration" --> "S3 Gateway Services" --> "Domains"

In Kubernetes only environments this value can be set to ``` quobyte-s3.<deploymentNS>.svc.cluster.local> ``` to address teh right Kubernetes service. If the S3 service should be reachable under other domains these domains can be configured as a comma separated list in the Webconsole or using ``` qmgmt systemconfig edit ```.

### TLS
If Quobyte S3 should serve encrypted traffic (and this encryption is not handled by a load balancer in front of the S3 proxy pods) it can be configured directly in the Quobyte S3 proxy configuration. 
Required parameters will be:
1) A root CA certificate
2) A wildcard service certificate matching the S3 DNS domain name 
3) A certificate key file for the service certificate.

These values can be configured in values.yaml within the quobyte.s3 section.

Certificates can be provided as Kubernetes secrets like this: 

```
apiVersion: v1
data:
  ca.crt: LS0tLS ... VBmNDc5VGVBZW9qT2o0d2EvSnlWL1pOZy9UTERRNwotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
  tls.crt: LS0tL ... mFjay9XS1ZYL3Y2RVQ4L2duWktSb2VKUDhYd3JxUT09Ci0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K 
  tls.key: LS0tL ... GlRdVRhMGcKODJPd1hna09HMlRuRXRDSTcxVWtkWDNKCi0tLS0tRU5EIFBSSVZBVEUgS0VZLS0tLS0K 
kind: Secret
type: kubernetes.io/tls
metadata:
  name: s3-cert
```


