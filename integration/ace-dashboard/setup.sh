#!/bin/bash

PROJECT=ace

oc create -f ace.yaml 

kubectl create secret generic ibm-ace-dashboard-icp4i-prod-helm-certs \
--from-file=cert.pem=$HOME/.helm/cert.pem \
--from-file=ca.pem=$HOME/.helm/ca.pem \
--from-file=key.pem=$HOME/.helm/key.pem \
--namespace=$PROJECT

echo "Setup of Ace Dashboard is now complete"
echo
