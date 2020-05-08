#!/bin/bash
PROJECT=mq
RELEASE=$PROJECT-dev
if [ ! -z "$ENV" ]; then 
  RELEASE=$PROJECT-$ENV 
fi;

ACCEPT_LICENSE="accept"
PRODUCTION_DEPLOY=false
if [ "$PRODUCTION" = "true" ];     then PRODUCTION_DEPLOY="true"; fi;

TLS_GENERATE=true
TLS_HOSTNAME=$(oc get routes -n kube-system | grep proxy | awk -F' ' '{print $2 }')

# In case of IBM Cloud use ibmc-file-gold for the file storage
FILE_STORAGE=nfs
if [ "$CLOUD_TYPE" = "ibmcloud" ]; then 
  FILE_STORAGE="ibmc-file-gold"; 
fi;
if [ ! -z "$STORAGE_FILE" ]; then 
  FILE_STORAGE=$STORAGE_FILE
fi;

QMGR_NAME="MYQMGR"
if [ ! -z "$QMNGR_NAME" ]; then 
  RELEASE="$QMNGR_NAME"
fi;

TRACING_ENABLED=true
TRACING_NAMESPACE=tracing

PULL_SECRET=ibm-entitlement-key
IMAGE_REGISTRY="cp.icr.io"
if $OFFLINE_INSTALL; then 
  IMAGE_REGISTRY="image-registry.openshift-image-registry.svc:5000/mq"; 
  PULL_SECRET=$(oc get secrets -n mq | grep deployer-dockercfg |  awk -F' ' '{print $1 }'); 
fi;

sed "s/ACCEPT_LICENSE/$ACCEPT_LICENSE/g"       ./ibm-mqadvanced-server-integration-prod/values_template.yaml  > ./ibm-mqadvanced-server-integration-prod/values_revised_1.yaml
sed "s/PRODUCTION_DEPLOY/$PRODUCTION_DEPLOY/g" ./ibm-mqadvanced-server-integration-prod/values_revised_1.yaml > ./ibm-mqadvanced-server-integration-prod/values_revised_2.yaml
sed "s/PULL_SECRET/$PULL_SECRET/g"             ./ibm-mqadvanced-server-integration-prod/values_revised_2.yaml > ./ibm-mqadvanced-server-integration-prod/values_revised_3.yaml
sed "s/TLS_GENERATE/$TLS_GENERATE/g"           ./ibm-mqadvanced-server-integration-prod/values_revised_3.yaml > ./ibm-mqadvanced-server-integration-prod/values_revised_4.yaml
sed "s/TLS_HOSTNAME/$TLS_HOSTNAME/g"           ./ibm-mqadvanced-server-integration-prod/values_revised_4.yaml > ./ibm-mqadvanced-server-integration-prod/values_revised_5.yaml
sed "s/FILE_STORAGE/$FILE_STORAGE/g"           ./ibm-mqadvanced-server-integration-prod/values_revised_5.yaml > ./ibm-mqadvanced-server-integration-prod/values_revised_6.yaml
sed "s/QMGR_NAME/$QMGR_NAME/g"                 ./ibm-mqadvanced-server-integration-prod/values_revised_6.yaml > ./ibm-mqadvanced-server-integration-prod/values_revised_7.yaml
sed "s/TRACING_ENABLED/$TRACING_ENABLED/g"     ./ibm-mqadvanced-server-integration-prod/values_revised_7.yaml > ./ibm-mqadvanced-server-integration-prod/values_revised_8.yaml
sed "s+IMAGE_REGISTRY+$IMAGE_REGISTRY+g"       ./ibm-mqadvanced-server-integration-prod/values_revised_8.yaml > ./ibm-mqadvanced-server-integration-prod/values_revised_9.yaml
sed "s/TRACING_NAMESPACE/$TRACING_NAMESPACE/g" ./ibm-mqadvanced-server-integration-prod/values_revised_9.yaml > ./ibm-mqadvanced-server-integration-prod/values.yaml 
rm ./ibm-mqadvanced-server-integration-prod/values_revised_1.yaml
rm ./ibm-mqadvanced-server-integration-prod/values_revised_2.yaml
rm ./ibm-mqadvanced-server-integration-prod/values_revised_3.yaml
rm ./ibm-mqadvanced-server-integration-prod/values_revised_4.yaml
rm ./ibm-mqadvanced-server-integration-prod/values_revised_5.yaml
rm ./ibm-mqadvanced-server-integration-prod/values_revised_6.yaml
rm ./ibm-mqadvanced-server-integration-prod/values_revised_7.yaml
rm ./ibm-mqadvanced-server-integration-prod/values_revised_8.yaml
rm ./ibm-mqadvanced-server-integration-prod/values_revised_9.yaml

if [ "FILE_STORAGE" = "nfs" ]; then 
  oc create -f pv.yaml;
  sed "s/FILE_STORAGE/$FILE_STORAGE/g"           ./pvc_template.yaml > ./pvc.yaml
  oc create -f pvc.yaml;
fi;

echo 
echo "Final values.yaml"
echo 

cat ./ibm-mqadvanced-server-integration-prod/values.yaml 

echo 
echo "Running Helm Install"
echo 
  
helm install --name $RELEASE --namespace $PROJECT  ibm-mqadvanced-server-integration-prod  --tls --debug
