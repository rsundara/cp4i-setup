#!/bin/bash

PROJECT=datapower
RELEASE=$PROJECT-dev
if [ ! -z "$ENV" ]; then 
  RELEASE=$PROJECT-$ENV; 
fi;

LIMITS_CPU=4
LIMITS_MEMORY=8Gi
PATTERN_NAME=restProxy

# In case of production, it can be set to "3"
REPLICA_COUNT=1
if [ "$PRODUCTION" = "true" ]; then 
  REPLICA_COUNT=3; 
fi;

IMAGE_REGISTRY="cp.icr.io"
PULL_SECRET=ibm-entitlement-key
if $OFFLINE_INSTALL; then 
  IMAGE_REGISTRY="image-registry.openshift-image-registry.svc:5000/datapower"; 
  PULL_SECRET=$(oc get secrets -n ace | grep deployer-dockercfg |  awk -F' ' '{print $1 }'); 
fi;

sed "s/PULL_SECRET/$PULL_SECRET/g"         ./ibm-datapower-icp4i/values_template.yaml  > ./ibm-datapower-icp4i/values_revised_1.yaml
sed "s/LIMITS_CPU/$LIMITS_CPU/g"           ./ibm-datapower-icp4i/values_revised_1.yaml > ./ibm-datapower-icp4i/values_revised_2.yaml
sed "s/LIMITS_MEMORY/$LIMITS_MEMORY/g"     ./ibm-datapower-icp4i/values_revised_2.yaml > ./ibm-datapower-icp4i/values_revised_3.yaml
sed "s/PATTERN_NAME/$PATTERN_NAME/g"       ./ibm-datapower-icp4i/values_revised_3.yaml > ./ibm-datapower-icp4i/values_revised_4.yaml
sed "s/IMAGE_REGISTRY/$IMAGE_REGISTRY/g"   ./ibm-datapower-icp4i/values_revised_4.yaml > ./ibm-datapower-icp4i/values_revised_5.yaml
sed "s/REPLICA_COUNT/$REPLICA_COUNT/g"     ./ibm-datapower-icp4i/values_revised_5.yaml > ./ibm-datapower-icp4i/values.yaml 
rm ./ibm-datapower-icp4i/values_revised_1.yaml
rm ./ibm-datapower-icp4i/values_revised_2.yaml
rm ./ibm-datapower-icp4i/values_revised_3.yaml
rm ./ibm-datapower-icp4i/values_revised_4.yaml
rm ./ibm-datapower-icp4i/values_revised_5.yaml
 
echo 
echo "Final values.yaml"
echo 

cat ./ibm-datapower-icp4i/values.yaml 

echo 
echo "Running Helm Install"
echo 
  
helm install --name $RELEASE --namespace $PROJECT ibm-datapower-icp4i --tls --debug
