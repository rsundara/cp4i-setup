#!/bin/bash

oc create -f apic.yaml 

PROJECT=apic 

oc project $PROJECT
oc adm policy add-scc-to-group ibm-anyuid-scc system:serviceaccounts:$PROJECT
oc adm policy add-scc-to-group anyuid system:serviceaccounts:$PROJECT

kubectl create secret generic apic-ent-helm-tls --from-file=cert.pem=$HOME/.helm/cert.pem --from-file=ca.pem=$HOME/.helm/ca.pem --from-file=key.pem=$HOME/.helm/key.pem -n apic

echo "Setup of API Connect is now complete"
echo 
