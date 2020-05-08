#!/bin/bash

PROJECT=eventstreams
RELEASE=$PROJECT-dev
if [ ! -z "$ENV" ]; then 
  RELEASE=$PROJECT-$ENV 
fi;

helm delete $RELEASE --purge --tls

oc project $PROJECT
oc delete job.batch/eventstreams-dev-ibm-es-role-mappings 
oc delete job.batch/eventstreams-dev-ibm-es-release-cm-addport-job
oc delete Role        ibm-restricted-scc-eventstreams
oc delete RoleBinding ibm-restricted-scc-eventstreams
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

oc delete secret eventstreamcertificate

echo "Uninstall of Eventstreams is now complete"
echo
