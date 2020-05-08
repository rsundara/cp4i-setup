#!/bin/bash

PROJECT=ace
RELEASE=$PROJECT-dashboard-dev
if [ ! -z "$ENV" ]; then 
  RELEASE=$PROJECT-dashboard-$ENV 
fi;

REPLICA_COUNT=1 
PRODUCTION_DEPLOY=false
if [ "$PRODUCTION" = "true" ]; then 
  PRODUCTION_DEPLOY="true"; 
  REPLICA_COUNT=3; 
fi;

TLS_CERT=ibm-ace-dashboard-icp4i-prod-helm-certs

# In case of IBM Cloud use ibmc-file-gold for the file storage
FILE_STORAGE=nfs
if [ "$CLOUD_TYPE" = "ibmcloud" ]; then 
  FILE_STORAGE="ibmc-file-gold"; 
fi;
if [ ! -z "$STORAGE_FILE" ]; then 
  FILE_STORAGE=$STORAGE_FILE
fi;

IMAGE_REGISTRY="cp.icr.io"
PULL_SECRET=ibm-entitlement-key
if $OFFLINE_INSTALL; then 
  IMAGE_REGISTRY="image-registry.openshift-image-registry.svc:5000/ace"; 
  PULL_SECRET=$(oc get secrets -n ace | grep deployer-dockercfg |  awk -F' ' '{print $1 }'); 
fi;

sed "s/PULL_SECRET/$PULL_SECRET/g"             ./ibm-ace-dashboard-icp4i-prod/values_template.yaml  > ./ibm-ace-dashboard-icp4i-prod/values_revised_1.yaml
sed "s/PRODUCTION_DEPLOY/$PRODUCTION_DEPLOY/g" ./ibm-ace-dashboard-icp4i-prod/values_revised_1.yaml > ./ibm-ace-dashboard-icp4i-prod/values_revised_2.yaml
sed "s/TLS_CERT/$TLS_CERT/g"                   ./ibm-ace-dashboard-icp4i-prod/values_revised_2.yaml > ./ibm-ace-dashboard-icp4i-prod/values_revised_3.yaml
sed "s/FILE_STORAGE/$FILE_STORAGE/g"           ./ibm-ace-dashboard-icp4i-prod/values_revised_3.yaml > ./ibm-ace-dashboard-icp4i-prod/values_revised_4.yaml
sed "s+IMAGE_REGISTRY+$IMAGE_REGISTRY+g"       ./ibm-ace-dashboard-icp4i-prod/values_revised_4.yaml > ./ibm-ace-dashboard-icp4i-prod/values_revised_5.yaml
sed "s/REPLICA_COUNT/$REPLICA_COUNT/g"         ./ibm-ace-dashboard-icp4i-prod/values_revised_5.yaml > ./ibm-ace-dashboard-icp4i-prod/values.yaml 
rm ./ibm-ace-dashboard-icp4i-prod/values_revised_1.yaml
rm ./ibm-ace-dashboard-icp4i-prod/values_revised_2.yaml
rm ./ibm-ace-dashboard-icp4i-prod/values_revised_3.yaml
rm ./ibm-ace-dashboard-icp4i-prod/values_revised_4.yaml
rm ./ibm-ace-dashboard-icp4i-prod/values_revised_5.yaml

if [ "FILE_STORAGE" = "nfs" ]; then 
  oc create -f pv.yaml; 
fi;

echo 
echo "Final values.yaml"
echo 

cat ./ibm-ace-dashboard-icp4i-prod/values.yaml 

echo 
echo "Running Helm Install"
echo 
  
helm install --name $RELEASE --namespace $PROJECT ibm-ace-dashboard-icp4i-prod  --tls --debug
