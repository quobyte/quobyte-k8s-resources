# Using Persistent Volumes

This example contains 

* a storage class to enable access to a Quobyte cluster,
* a Persistent Volume Claim that provisions a volume and 
* an example pod deployment of a container that uses that volume.

The Storage Class will need a secret with valid Quobyte credentials; these 
credentials are kept in a separate name space.



