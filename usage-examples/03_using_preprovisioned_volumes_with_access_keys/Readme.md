# Using Access Keys to consume one pre-provisioned Quobyte volume from different pods with different access keys

This scenario builds on the previous scenario [Using Access Keys](../02_using_accesskeys/). 

The difference here is that it does not use dynamically created Volumes, but a pre-provisioned 
Quobyte volume. 

This Quobyte volume is referenced by two different Kubernetes persistent volumes, these volumes 
are again referenced from two different persistent volume claims.

The persistent volume claim contains the reference to the "personal" secret that contains the users access key data.

This allows users to store their own access keys in theit own secrets and access a shared data set/ Quobyte volume 
using these credentials.




