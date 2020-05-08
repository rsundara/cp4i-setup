#!/bin/bash

PROJECT=datapower
RELEASE=$PROJECT-dev
if [ ! -z "$ENV" ]; then 
  RELEASE=$PROJECT-$ENV 
fi;

helm delete $RELEASE --purge --tls

oc project $PROJECT
oc delete Role        ibm-anyuid-scc-datapower
oc delete RoleBinding ibm-anyuid-scc-datapower

echo "Uninstall of DataPower is now complete"
echo
