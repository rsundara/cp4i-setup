#!/bin/bash
PROJECT=apic
RELEASE=$PROJECT-dev
if [ ! -z "$ENV" ]; then 
  RELEASE=$PROJECT-$ENV 
fi;

PRODUCTION_DEPLOY=false
if [ "$PRODUCTION" = "true" ];     then PRODUCTION_DEPLOY="true"; fi;

# In case of IBM Cloud use ibmc-block-gold for the block storage
BLOCK_STORAGE=rook-ceph-block
if [ "$CLOUD_TYPE" = "ibmcloud" ]; then 
  BLOCK_STORAGE="ibmc-block-gold"; 
fi;
if [ ! -z "$STORAGE_BLOCK" ]; then 
  BLOCK_STORAGE=$STORAGE_BLOCK
fi;

# In case of production, it can be set to "standard"
DEPLOY_MODE=dev
if [ "$PRODUCTION" = "true" ]; then 
  DEPLOY_MODE="standard"; 
fi;

ROUTE_TYPE=route
HELM_TLS_SECRET=apic-ent-helm-tls
PROXY_ENDPOINT=$(oc get routes -n kube-system | grep proxy | awk -F' ' '{print $2 }')

# In case of production, it can be set to "3"
REPLICA_COUNT=1
if [ "$PRODUCTION" = "true" ]; then 
  REPLICA_COUNT="3"; 
fi;

V5_GATEWAY=false

# In case of production, it can be set to "true"
HIGH_PERFORMANCE_PEERING=off
if [ "$PRODUCTION" = "true" ];    then HIGH_PERFORMANCE_PEERING="true"; fi;
TRACING_ENABLED=false

PULL_SECRET=ibm-entitlement-key
IMAGE_REGISTRY="cp.icr.io/cp/icp4i/apic"
if $OFFLINE_INSTALL; then 
  IMAGE_REGISTRY="image-registry.openshift-image-registry.svc:5000/apic"; 
  PULL_SECRET=$(oc get secrets -n apic | grep deployer-dockercfg |  awk -F' ' '{print $1 }'); 
fi;

sed "s/PRODUCTION_DEPLOY/$PRODUCTION_DEPLOY/g"               ./ibm-apiconnect-icp4i-prod/values_template.yaml  > ./ibm-apiconnect-icp4i-prod/values_revised_1.yaml
sed "s/PULL_SECRET/$PULL_SECRET/g"                           ./ibm-apiconnect-icp4i-prod/values_revised_1.yaml > ./ibm-apiconnect-icp4i-prod/values_revised_2.yaml
sed "s/BLOCK_STORAGE/$BLOCK_STORAGE/g"                       ./ibm-apiconnect-icp4i-prod/values_revised_2.yaml > ./ibm-apiconnect-icp4i-prod/values_revised_3.yaml
sed "s/DEPLOY_MODE/$DEPLOY_MODE/g"                           ./ibm-apiconnect-icp4i-prod/values_revised_3.yaml > ./ibm-apiconnect-icp4i-prod/values_revised_4.yaml
sed "s/ROUTE_TYPE/$ROUTE_TYPE/g"                             ./ibm-apiconnect-icp4i-prod/values_revised_4.yaml > ./ibm-apiconnect-icp4i-prod/values_revised_5.yaml
sed "s/HELM_TLS_SECRET/$HELM_TLS_SECRET/g"                   ./ibm-apiconnect-icp4i-prod/values_revised_5.yaml > ./ibm-apiconnect-icp4i-prod/values_revised_6.yaml
sed "s/PROXY_ENDPOINT/$PROXY_ENDPOINT/g"                     ./ibm-apiconnect-icp4i-prod/values_revised_6.yaml > ./ibm-apiconnect-icp4i-prod/values_revised_7.yaml
sed "s/REPLICA_COUNT/$REPLICA_COUNT/g"                       ./ibm-apiconnect-icp4i-prod/values_revised_7.yaml > ./ibm-apiconnect-icp4i-prod/values_revised_8.yaml
sed "s/HIGH_PERFORMANCE_PEERING/$HIGH_PERFORMANCE_PEERING/g" ./ibm-apiconnect-icp4i-prod/values_revised_8.yaml > ./ibm-apiconnect-icp4i-prod/values_revised_9.yaml
sed "s/V5_GATEWAY/$V5_GATEWAY/g"                             ./ibm-apiconnect-icp4i-prod/values_revised_9.yaml > ./ibm-apiconnect-icp4i-prod/values_revised_10.yaml
sed "s+IMAGE_REGISTRY+$IMAGE_REGISTRY+g"                     ./ibm-apiconnect-icp4i-prod/values_revised_10.yaml > ./ibm-apiconnect-icp4i-prod/values_revised_11.yaml
sed "s/TRACING_ENABLED/$TRACING_ENABLED/g"                   ./ibm-apiconnect-icp4i-prod/values_revised_11.yaml > ./ibm-apiconnect-icp4i-prod/values.yaml 
rm ./ibm-apiconnect-icp4i-prod/values_revised_1.yaml
rm ./ibm-apiconnect-icp4i-prod/values_revised_2.yaml
rm ./ibm-apiconnect-icp4i-prod/values_revised_3.yaml
rm ./ibm-apiconnect-icp4i-prod/values_revised_4.yaml
rm ./ibm-apiconnect-icp4i-prod/values_revised_5.yaml
rm ./ibm-apiconnect-icp4i-prod/values_revised_6.yaml
rm ./ibm-apiconnect-icp4i-prod/values_revised_7.yaml
rm ./ibm-apiconnect-icp4i-prod/values_revised_8.yaml
rm ./ibm-apiconnect-icp4i-prod/values_revised_9.yaml
rm ./ibm-apiconnect-icp4i-prod/values_revised_10.yaml
rm ./ibm-apiconnect-icp4i-prod/values_revised_11.yaml

echo 
echo "Final values.yaml"
echo 

cat ./ibm-apiconnect-icp4i-prod/values.yaml 

echo 
echo "Running Helm Install"
echo 

helm install --name $RELEASE --namespace $PROJECT  ibm-apiconnect-icp4i-prod  --tls --debug
