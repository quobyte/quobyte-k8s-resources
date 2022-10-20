# Provisioning and Mounting Persistent Volumes

This example will allow you to dynamically provision a persistent volume 
and mount it later on to a container deployed as a single pod. 

This example contains 

* A storage class to enable access to a Quobyte cluster,
* A Persistent Volume Claim that provisions a volume and 
* An example pod deployment of a container that uses that volume.

The Storage Class will need a secret with valid Quobyte credentials. 

## Prerequisites:
To apply the examples a Quobyte user/password needs to be configured in 

02_secret_quobyte.yaml

This user/password needs to be base64 encoded.

## Apply Example Declarations:

``` 
kubectl apply -f 01_namespace-quobyte.yaml -f 02_secret_quobyte.yaml -f 03_storageClass.yaml -f 04-testpvc.yaml -f 05_testpod.yaml
``` 

## Checking Success

* Is pvc created successfully?

```
$ kubectl get pvc quobyte-default-pvc
NAME                  STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS      AGE
quobyte-default-pvc   Bound    pvc-d2d1e9d7-c36f-4e47-88d1-4e800882f282   10Gi       RWO            quobyte-default   17s
[jan@jan 01_getting_started]$ kubectl describe pvc quobyte-default-pvc
Name:          quobyte-default-pvc
Namespace:     default
StorageClass:  quobyte-default
Status:        Bound
Volume:        pvc-d2d1e9d7-c36f-4e47-88d1-4e800882f282
Labels:        <none>
Annotations:   pv.kubernetes.io/bind-completed: yes
               pv.kubernetes.io/bound-by-controller: yes
               volume.beta.kubernetes.io/storage-provisioner: csi.quobyte.com
Finalizers:    [kubernetes.io/pvc-protection]
Capacity:      10Gi
Access Modes:  RWO
VolumeMode:    Filesystem
Used By:       consumer-pod
Events:
  Type    Reason                 Age   From                                                                                           Message
  ----    ------                 ----  ----                                                                                           -------
  Normal  Provisioning           32s   csi.quobyte.com_quobyte-csi-controller-csi-quobyte-com-0_d5de9dae-b7e9-49f2-9fc4-509a7b0c223a  External provisioner is provisioning volume for claim "default/quobyte-default-pvc"
  Normal  ExternalProvisioning   32s   persistentvolume-controller                                                                    waiting for a volume to be created, either by external provisioner "csi.quobyte.com" or manually created by system administrator
  Normal  ProvisioningSucceeded  29s   csi.quobyte.com_quobyte-csi-controller-csi-quobyte-com-0_d5de9dae-b7e9-49f2-9fc4-509a7b0c223a  Successfully provisioned volume pvc-d2d1e9d7-c36f-4e47-88d1-4e800882f282
```

* Is pv mounted inside to a container successfully?

```
kubectl exec -it consumer-pod -- mount | grep quobyte
quobyte@_quobyte._tcp.quobyte.default.svc.cluster.local/ on /usr/share/nginx/html type fuse.quobyte (rw,nosuid,nodev,noatime,user_id=0,group_id=0,default_permissions,allow_other)
```

* Is Quobyte mount readable/ writeable from within the container?

```
$ kubectl exec -it consumer-pod -- /bin/bash
root@consumer-pod:/# cd /usr/share/nginx/html/
root@consumer-pod:/usr/share/nginx/html# echo "Hello World!" > index.html
root@consumer-pod:/usr/share/nginx/html# cat index.html 
Hello World!
```

