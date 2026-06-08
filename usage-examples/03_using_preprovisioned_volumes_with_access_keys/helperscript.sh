#!/usr/bin/env bash

which qmgmt > /dev/null || echo "Script needs to be run from a host with qmgmt installed"

users=(member_a member_b)
for user in ${users[*]}; do
	id=$(qmgmt -u http://quobyte-api.quobyte.svc.cluster.local:7860  accesskey list | grep ^$user | awk -F" " '{print $2}' | tr -d :space: | tr -d '\n')
	secret=$(qmgmt -u http://quobyte-api.quobyte.svc.cluster.local:7860  accesskey list | grep ^$user | awk -F" " '{print $3}'| tr -d :space: | tr -d '\n')
	echo 
	echo "user $user id: ${id}"
	echo "user $user secret: ${secret}"
	base64_id=$(echo -n ${id} | base64)
	base64_secret=$(echo -n ${secret} | base64)
	echo "user $user base64_id: ${base64_id}"
	echo "user $user base64_secret: ${base64_secret}"
	echo 
	cat <<EOF> ${user}-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: ${user}-secret
type: "kubernetes.io/quobyte"
data:
    # "Tenant Member" access keys, base64 encoded
    accessKeyId: ${base64_id}
    accessKeySecret: ${base64_secret}
EOF
done
