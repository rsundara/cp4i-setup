#!/bin/bash

PROJECT=aspera
RELEASE=$PROJECT-dev
if [ ! -z "$ENV" ]; then 
  RELEASE=$PROJECT-$ENV 
fi;

helm delete $RELEASE --purge --tls

oc project $PROJECT
oc delete -f aspera.yaml
oc delete pvc --all

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

oc delete secret aspera-server
oc delete secret asperanode-nodeadmin
oc delete secret asperanode-accesskey

echo "Uninstall of Aspera is now complete"
echo
