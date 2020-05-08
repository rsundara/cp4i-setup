#!/bin/bash

PROJECT=aspera
RELEASE=$PROJECT-dev
if [ ! -z "$ENV" ]; then 
  RELEASE=$PROJECT-$ENV 
fi;

PRODUCTION_DEPLOY=false
if [ "$PRODUCTION" = "true" ]; then PRODUCTION_DEPLOY="true"; fi;

USE_DYNAMIC_PROVISIONING=true
# In case of IBM Cloud use ibmc-file-gold for the file storage
FILE_STORAGE=nfs
if [ "$CLOUD_TYPE" = "ibmcloud" ]; then 
  FILE_STORAGE="ibmc-file-gold"; 
fi;
if [ ! -z "$STORAGE_FILE" ]; then 
  FILE_STORAGE=$STORAGE_FILE
fi;

PROXY_ENDPOINT=$(oc get routes -n kube-system | grep proxy | awk -F' ' '{print $2 }')

# In case of production, it can be set to "3"
REPLICAS=1
if [ "$PRODUCTION" = "true" ]; then 
  REPLICAS=3; 
fi;

SERVER_SECRET=aspera-server
NODE_ADMIN_SECRET=asperanode-nodeadmin
ACCESSKEY_SECRET=asperanode-accesskey
KAFKAPORT=$(oc get service eventstreams-dev-ibm-es-proxy-svc -n eventstreams  | grep eventstreams |  awk -F' ' '{print $5 }' |  awk -F':' '{print $2 }' | awk -F'/' '{print $1 }')
ASCP_NODE_LABEL=ascp
NODED_NODE_LABEL=noded
INGRESS_HOSTNAME=aspera.$(echo $PROXY_ENDPOINT | cut -d'.' -f2)
RPROXY_ADDRESS=1.1.1.1

PULL_SECRET=ibm-entitlement-key
IMAGE_REGISTRY="cp.icr.io\/cp\/icp4i\/aspera"
if $OFFLINE_INSTALL; then 
  IMAGE_REGISTRY="image-registry.openshift-image-registry.svc:5000/aspera"; 
  PULL_SECRET=$(oc get secrets -n eventstreams | grep deployer-dockercfg |  awk -F' ' '{print $1 }'); 
fi;

sed "s/PRODUCTION_DEPLOY/$PRODUCTION_DEPLOY/g"               ./ibm-aspera-hsts-icp4i/values_template.yaml  > ./ibm-aspera-hsts-icp4i/values_revised_1.yaml
sed "s/USE_DYNAMIC_PROVISIONING/$USE_DYNAMIC_PROVISIONING/g" ./ibm-aspera-hsts-icp4i/values_revised_1.yaml > ./ibm-aspera-hsts-icp4i/values_revised_2.yaml
sed "s/FILE_STORAGE/$FILE_STORAGE/g"                         ./ibm-aspera-hsts-icp4i/values_revised_2.yaml > ./ibm-aspera-hsts-icp4i/values_revised_3.yaml
sed "s/REPOSITORY/$REPOSITORY/g"                             ./ibm-aspera-hsts-icp4i/values_revised_3.yaml > ./ibm-aspera-hsts-icp4i/values_revised_4.yaml
sed "s/PULL_SECRET/$PULL_SECRET/g"                           ./ibm-aspera-hsts-icp4i/values_revised_4.yaml > ./ibm-aspera-hsts-icp4i/values_revised_5.yaml
sed "s/PROXY_ENDPOINT/$PROXY_ENDPOINT/g"                     ./ibm-aspera-hsts-icp4i/values_revised_5.yaml > ./ibm-aspera-hsts-icp4i/values_revised_6.yaml
sed "s/REPLICAS/$REPLICAS/g"                                 ./ibm-aspera-hsts-icp4i/values_revised_6.yaml > ./ibm-aspera-hsts-icp4i/values_revised_7.yaml
sed "s/SERVER_SECRET/$SERVER_SECRET/g"                       ./ibm-aspera-hsts-icp4i/values_revised_7.yaml > ./ibm-aspera-hsts-icp4i/values_revised_8.yaml
sed "s/NODE_ADMIN_SECRET/$NODE_ADMIN_SECRET/g"               ./ibm-aspera-hsts-icp4i/values_revised_8.yaml > ./ibm-aspera-hsts-icp4i/values_revised_9.yaml
sed "s/ACCESSKEY_SECRET/$ACCESSKEY_SECRET/g"                 ./ibm-aspera-hsts-icp4i/values_revised_9.yaml > ./ibm-aspera-hsts-icp4i/values_revised_10.yaml
sed "s/KAFKAPORT/$KAFKAPORT/g"                               ./ibm-aspera-hsts-icp4i/values_revised_10.yaml > ./ibm-aspera-hsts-icp4i/values_revised_11.yaml
sed "s/ASCP_NODE_LABEL/$ASCP_NODE_LABEL/g"                   ./ibm-aspera-hsts-icp4i/values_revised_11.yaml > ./ibm-aspera-hsts-icp4i/values_revised_12.yaml
sed "s/NODED_NODE_LABEL/$NODED_NODE_LABEL/g"                 ./ibm-aspera-hsts-icp4i/values_revised_12.yaml > ./ibm-aspera-hsts-icp4i/values_revised_13.yaml 
sed "s/INGRESS_HOSTNAME/$INGRESS_HOSTNAME/g"                 ./ibm-aspera-hsts-icp4i/values_revised_13.yaml > ./ibm-aspera-hsts-icp4i/values_revised_14.yaml
sed "s+IMAGE_REGISTRY+$IMAGE_REGISTRY+g"                     ./ibm-aspera-hsts-icp4i/values_revised_14.yaml > ./ibm-aspera-hsts-icp4i/values_revised_15.yaml
sed "s/RPROXY_ADDRESS/$RPROXY_ADDRESS/g"                     ./ibm-aspera-hsts-icp4i/values_revised_15.yaml > ./ibm-aspera-hsts-icp4i/values.yaml

rm ./ibm-aspera-hsts-icp4i/values_revised_1.yaml
rm ./ibm-aspera-hsts-icp4i/values_revised_2.yaml
rm ./ibm-aspera-hsts-icp4i/values_revised_3.yaml
rm ./ibm-aspera-hsts-icp4i/values_revised_4.yaml
rm ./ibm-aspera-hsts-icp4i/values_revised_5.yaml
rm ./ibm-aspera-hsts-icp4i/values_revised_6.yaml
rm ./ibm-aspera-hsts-icp4i/values_revised_7.yaml
rm ./ibm-aspera-hsts-icp4i/values_revised_8.yaml
rm ./ibm-aspera-hsts-icp4i/values_revised_9.yaml
rm ./ibm-aspera-hsts-icp4i/values_revised_10.yaml
rm ./ibm-aspera-hsts-icp4i/values_revised_11.yaml
rm ./ibm-aspera-hsts-icp4i/values_revised_12.yaml
rm ./ibm-aspera-hsts-icp4i/values_revised_13.yaml
rm ./ibm-aspera-hsts-icp4i/values_revised_14.yaml
rm ./ibm-aspera-hsts-icp4i/values_revised_15.yaml

if [ "FILE_STORAGE" = "nfs" ]; then 
  oc create -f pv.yaml; 
fi;

echo 
echo "Final values.yaml"
echo 

cat ./ibm-aspera-hsts-icp4i/values.yaml 

echo 
echo "Running Helm Install"
echo 

helm install --name $RELEASE --namespace $PROJECT  ibm-aspera-hsts-icp4i --timeout 1200 --tls --debug
