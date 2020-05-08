#!/bin/bash
PROJECT=ace
RELEASE=$PROJECT-designer-dev
if [ ! -z "$ENV" ]; then 
  RELEASE=$PROJECT-designer-$ENV 
fi;

REPLICA_COUNT=1 
if [ "$PRODUCTION" = "true" ]; then REPLICA_COUNT="3"; fi;

# In case of IBM Cloud use ibmc-block-gold for the block storage
BLOCK_STORAGE=rook-ceph-block
if [ "$CLOUD_TYPE" = "ibmcloud" ]; then 
  BLOCK_STORAGE="ibmc-block-gold"; 
fi;
if [ ! -z "$STORAGE_BLOCK" ]; then 
  BLOCK_STORAGE=$STORAGE_BLOCK
fi;

PULL_SECRET=ibm-entitlement-key
IMAGE_REGISTRY="cp.icr.io"
if $OFFLINE_INSTALL; then 
  IMAGE_REGISTRY="image-registry.openshift-image-registry.svc:5000/ace"; 
  PULL_SECRET=$(oc get secrets -n ace | grep deployer-dockercfg |  awk -F' ' '{print $1 }'); 
fi;

sed "s/PULL_SECRET/$PULL_SECRET/g"             ./ibm-app-connect-designer-icp4i/values_template.yaml  > ./ibm-app-connect-designer-icp4i/values_revised_1.yaml
sed "s+IMAGE_REGISTRY+$IMAGE_REGISTRY+g"       ./ibm-app-connect-designer-icp4i/values_revised_1.yaml > ./ibm-app-connect-designer-icp4i/values_revised_2.yaml
sed "s/BLOCK_STORAGE/$BLOCK_STORAGE/g"         ./ibm-app-connect-designer-icp4i/values_revised_2.yaml > ./ibm-app-connect-designer-icp4i/values_revised_3.yaml
sed "s/REPLICA_COUNT/$REPLICA_COUNT/g"         ./ibm-app-connect-designer-icp4i/values_revised_3.yaml > ./ibm-app-connect-designer-icp4i/values.yaml 
rm ./ibm-app-connect-designer-icp4i/values_revised_1.yaml
rm ./ibm-app-connect-designer-icp4i/values_revised_2.yaml
rm ./ibm-app-connect-designer-icp4i/values_revised_3.yaml

echo 
echo "Final values.yaml"
echo 

cat ./ibm-app-connect-designer-icp4i/values.yaml 

echo 
echo "Running Helm Install"
echo 
  
helm install --name $RELEASE --namespace $PROJECT ibm-app-connect-designer-icp4i  --tls --debug
