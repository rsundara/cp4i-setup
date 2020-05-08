#!/bin/bash
  
#!/bin/bash
PROJECT=assetrepo
RELEASE=$PROJECT-dev
if [ ! -z "$ENV" ]; then 
  RELEASE=$PROJECT-$ENV 
fi;

# In case of IBM Cloud use ibmc-block-gold for the file storage
BLOCK_STORAGE=rook-ceph-block
if [ "$CLOUD_TYPE" = "ibmcloud" ]; then 
  BLOCK_STORAGE="ibmc-block-gold"; 
fi;
if [ ! -z "$STORAGE_BLOCK" ]; then 
  BLOCK_STORAGE=$STORAGE_BLOCK
fi;

# In case of IBM Cloud use ibmc-file-gold for the file storage
FILE_STORAGE=nfs
if [ "$CLOUD_TYPE" = "ibmcloud" ]; then 
  FILE_STORAGE="ibmc-file-gold"; 
fi;
if [ ! -z "$STORAGE_FILE" ]; then 
  FILE_STORAGE=$STORAGE_FILE
fi;

# In case of HA env, it can be set to 3
REPLICAS=3

PULL_SECRET=ibm-entitlement-key
IMAGE_REGISTRY="cp.icr.io/cp/icp4i/"
if $OFFLINE_INSTALL; then 
  IMAGE_REGISTRY="image-registry.openshift-image-registry.svc:5000/integration"; 
  PULL_SECRET=$(oc get secrets -n assetrepo | grep default-dockercfg |  awk -F' ' '{print $1 }'); 
fi;

sed "s/PULL_SECRET/$PULL_SECRET/g"     ./ibm-icp4i-asset-repo-prod/values_template.yaml  > ./ibm-icp4i-asset-repo-prod/values_revised_1.yaml
sed "s/BLOCK_STORAGE/$BLOCK_STORAGE/g" ./ibm-icp4i-asset-repo-prod/values_revised_1.yaml > ./ibm-icp4i-asset-repo-prod/values_revised_2.yaml
sed "s/FILE_STORAGE/$FILE_STORAGE/g"   ./ibm-icp4i-asset-repo-prod/values_revised_2.yaml > ./ibm-icp4i-asset-repo-prod/values_revised_3.yaml
sed "s+IMAGE_REGISTRY+$IMAGE_REGISTRY+g"   ./ibm-icp4i-asset-repo-prod/values_revised_3.yaml > ./ibm-icp4i-asset-repo-prod/values_revised_4.yaml
sed "s/REPLICAS/$REPLICAS/g"           ./ibm-icp4i-asset-repo-prod/values_revised_4.yaml > ./ibm-icp4i-asset-repo-prod/values.yaml 
rm ./ibm-icp4i-asset-repo-prod/values_revised_1.yaml
rm ./ibm-icp4i-asset-repo-prod/values_revised_2.yaml
rm ./ibm-icp4i-asset-repo-prod/values_revised_3.yaml
rm ./ibm-icp4i-asset-repo-prod/values_revised_4.yaml

if [ "FILE_STORAGE" = "nfs" ]; then 
  oc create -f pv.yaml; 
fi;

echo 
echo "Final values.yaml"
echo 

cat ./ibm-icp4i-asset-repo-prod/values.yaml 

echo 
echo "Running Helm Install"
echo 


helm install --name $RELEASE --namespace $PROJECT  ibm-icp4i-asset-repo-prod --timeout 1200 --tls --debug
