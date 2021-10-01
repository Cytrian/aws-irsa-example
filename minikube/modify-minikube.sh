
#!/bin/bash

minikube cp keys/oidc-issuer.key /tmp/oidc-issuer.key
minikube cp keys/oidc-issuer.pub /tmp/oidc-issuer.pub
minikube ssh "sudo cp /tmp/oidc-issuer.pub /etc/ssl/certs"
minikube ssh "sudo cp /tmp/oidc-issuer.key /etc/ssl/certs"

if [[ "$1" == "" ]]
then
  echo "call this script with ISSUER_HOSTPATH, e.g. s3-eu-central-1.amazonaws.com/aws-irsa-oidc-1632906965"
  exit 1
fi

ISSUER_HOSTPATH=$1

minikube ssh "sudo sed -i '/- kube-apiserver$/a\    - --service-account-key-file=/etc/ssl/certs/oidc-issuer.pub\n    - --service-account-signing-key-file=/etc/ssl/certs/oidc-issuer.key\n    - --api-audiences=sts.amazonaws.com\n    - --service-account-issuer=https://$ISSUER_HOSTPATH' /etc/kubernetes/manifests/kube-apiserver.yaml"

#    - --service-account-key-file=/etc/ssl/certs/oidc-issuer.pub
#    - --service-account-signing-key-file=/etc/ssl/certs/oidc-issuer.key
#    - --api-audiences=sts.amazonaws.com 
#    - --service-account-issuer=https://s3-eu-central-1.amazonaws.com/aws-irsa-oidc-1632906965/
