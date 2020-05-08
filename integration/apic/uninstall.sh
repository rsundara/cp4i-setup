#!/bin/bash

PROJECT=apic
RELEASE=$PROJECT-dev
if [ ! -z "$ENV" ]; then 
  RELEASE=$PROJECT-$ENV 
fi;

helm delete $RELEASE --purge --tls

oc project $PROJECT
oc delete Role        ibm-anyuid-hostpath-scc-apic
oc delete RoleBinding ibm-anyuid-hostpath-scc-apic
oc delete secret apic-ent-helm-tls 

echo "Uninstall of API Connect is now complete"
echo 
