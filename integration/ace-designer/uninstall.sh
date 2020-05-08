#!/bin/bash

PROJECT=ace
RELEASE=$PROJECT-designer-dev
if [ ! -z "$ENV" ]; then 
  RELEASE=$PROJECT-designer-$ENV 
fi;

helm delete $RELEASE --purge --tls

oc project $PROJECT

PVC_NAME=$(oc get pvc | grep $RELEASE | awk -F' ' '{print $1 }')
oc delete pvc $PVC_NAME

echo "Uninstall of Ace Designer is now complete"
echo
 
