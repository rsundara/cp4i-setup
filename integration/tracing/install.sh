#!/bin/bash

PROJECT=tracing
RELEASE=$PROJECT-dev
if [ ! -z "$ENV" ]; then 
  RELEASE=$PROJECT-$ENV 
fi;

INGRESS_ENDPOINT=$(oc get routes -n kube-system | grep proxy | awk -F' ' '{print $2 }')
NAVIGATOR_ENDPOINT=$(oc get routes -n integration | grep ibm-icp4i-prod | awk -F' ' '{print $2 }')

# In case of IBM Cloud use ibmc-block-gold for the block storage
BLOCK_STORAGE=rook-ceph-block
if [ ! -z "$STORAGE" ]; then 
  BLOCK_STORAGE=$STORAGE
fi;
if [ "$CLOUD_TYPE" = "ibmcloud" ]; then 
  BLOCK_STORAGE="ibmc-block-gold"; 
fi;

if [ "$PRODUCTION" = "true" ]; then 
  PRODUCTION_DEPLOY="true"; 
fi;

PULL_SECRET=ibm-entitlement-key 
IMAGE_REGISTRY="cp.icr.io/cp/icp4i/od"
if $OFFLINE_INSTALL; then 
  IMAGE_REGISTRY="image-registry.openshift-image-registry.svc:5000/tracing"; 
  PULL_SECRET=$(oc get secrets -n tracing | grep deployer-dockercfg |  awk -F' ' '{print $1 }'); 
fi;

sed "s/PULL_SECRET/$PULL_SECRET/g"               ./ibm-icp4i-tracing-prod/values_template.yaml  > ./ibm-icp4i-tracing-prod/values_revised_1.yaml
sed "s/INGRESS_ENDPOINT/$INGRESS_ENDPOINT/g"     ./ibm-icp4i-tracing-prod/values_revised_1.yaml > ./ibm-icp4i-tracing-prod/values_revised_2.yaml
sed "s/NAVIGATOR_ENDPOINT/$NAVIGATOR_ENDPOINT/g" ./ibm-icp4i-tracing-prod/values_revised_2.yaml > ./ibm-icp4i-tracing-prod/values_revised_3.yaml
sed "s+IMAGE_REGISTRY+$IMAGE_REGISTRY+g"         ./ibm-icp4i-tracing-prod/values_revised_3.yaml > ./ibm-icp4i-tracing-prod/values_revised_4.yaml
sed "s/BLOCK_STORAGE/$BLOCK_STORAGE/g"           ./ibm-icp4i-tracing-prod/values_revised_4.yaml > ./ibm-icp4i-tracing-prod/values.yaml 
rm ./ibm-icp4i-tracing-prod/values_revised_1.yaml
rm ./ibm-icp4i-tracing-prod/values_revised_2.yaml
rm ./ibm-icp4i-tracing-prod/values_revised_3.yaml
rm ./ibm-icp4i-tracing-prod/values_revised_4.yaml
 
echo 
echo "Final values.yaml"
echo 

cat ./ibm-icp4i-tracing-prod/values.yaml 

echo 
echo "Running Helm Install"
echo 
   
helm install --name $RELEASE --namespace $PROJECT ibm-icp4i-tracing-prod --tls --debug
