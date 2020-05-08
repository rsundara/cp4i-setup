#!/bin/bash

PROJECT=ace
RELEASE=$PROJECT-dashboard-dev
if [ ! -z "$ENV" ]; then 
  RELEASE=$PROJECT-dashboard-$ENV 
fi;

helm delete $RELEASE --purge --tls

oc project $PROJECT

oc delete secret ibm-ace-dashboard-icp4i-prod-helm-certs 

PVC_NAME=$(oc get pvc | grep $RELEASE | awk -F' ' '{print $1 }')
oc delete pvc $PVC_NAME

# In case of IBM Cloud use ibmc-file-gold for the file storage
FILE_STORAGE=nfs
if [ "$CLOUD_TYPE" = "ibmcloud" ]; then 
  FILE_STORAGE="ibmc-file-gold"; 
fi;
if [ ! -z "$STORAGE_FILE" ]; then 
  FILE_STORAGE=$STORAGE_FILE
fi;
if [ "FILE_STORAGE" = "nfs" ]; then 
  oc delete -f pv.yaml; 
fi;

echo "Uninstall of Ace Dashboard is now complete"
echo 
