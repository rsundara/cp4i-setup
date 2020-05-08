#!/bin/bash
PROJECT=eventstreams
RELEASE=$PROJECT-dev
if [ ! -z "$ENV" ]; then 
  RELEASE=$PROJECT-$ENV 
fi;

PRODUCTION_DEPLOY=false
if [ "$PRODUCTION" = "true" ]; then PRODUCTION_DEPLOY="true"; fi;

PERSISTENCE_ENABLE=false
USE_DYNAMIC_PROVISIONING=false
# In case of IBM Cloud use ibmc-file-gold for the file storage
FILE_STORAGE=nfs
if [ "$CLOUD_TYPE" = "ibmcloud" ]; then 
  FILE_STORAGE="ibmc-file-gold"; 
fi;
if [ ! -z "$STORAGE_FILE" ]; then 
  FILE_STORAGE=$STORAGE_FILE
fi;

if [ "$PERSISTENCE_ENABLE" = "false" ]; then 
  FILE_STORAGE=;
fi;

NAVIGATOR_NAMESPACE=integration
EXTERNAL_ENDPOINT=$(oc get routes -n kube-system | grep proxy | awk -F' ' '{print $2 }')

if [ "$CLOUD_TYPE" = "ibmcloud" ]; then EXTERNAL_ENDPOINT=; fi;

ACCEPT_LICENSE=accept

PULL_SECRET=ibm-entitlement-key
IMAGE_REGISTRY="cp.icr.io/cp/icp4i/es"
if $OFFLINE_INSTALL; then 
  IMAGE_REGISTRY="image-registry.openshift-image-registry.svc:5000/eventstreams"; 
  PULL_SECRET=$(oc get secrets -n eventstreams | grep deployer-dockercfg |  awk -F' ' '{print $1 }'); 
fi;

sed "s+IMAGE_REGISTRY+$IMAGE_REGISTRY+g"                                  ./ibm-eventstreams-icp4i-prod/values_template.yaml  > ./ibm-eventstreams-icp4i-prod/values_revised_1.yaml
sed "s/PRODUCTION_DEPLOY/$PRODUCTION_DEPLOY/g"                            ./ibm-eventstreams-icp4i-prod/values_revised_1.yaml > ./ibm-eventstreams-icp4i-prod/values_revised_2.yaml
sed "s/PULL_SECRET/$PULL_SECRET/g"                                        ./ibm-eventstreams-icp4i-prod/values_revised_2.yaml > ./ibm-eventstreams-icp4i-prod/values_revised_3.yaml
sed "s/PERSISTENCE_ENABLE/$PERSISTENCE_ENABLE/g"                          ./ibm-eventstreams-icp4i-prod/values_revised_3.yaml > ./ibm-eventstreams-icp4i-prod/values_revised_4.yaml
sed "s/USE_DYNAMIC_PROVISIONING/$USE_DYNAMIC_PROVISIONING/g"              ./ibm-eventstreams-icp4i-prod/values_revised_4.yaml > ./ibm-eventstreams-icp4i-prod/values_revised_5.yaml
sed "s/FILE_STORAGE/$FILE_STORAGE/g"                                      ./ibm-eventstreams-icp4i-prod/values_revised_5.yaml > ./ibm-eventstreams-icp4i-prod/values_revised_6.yaml
sed "s/NAVIGATOR_NAMESPACE/$NAVIGATOR_NAMESPACE/g"                        ./ibm-eventstreams-icp4i-prod/values_revised_6.yaml > ./ibm-eventstreams-icp4i-prod/values_revised_7.yaml
sed "s/EXTERNAL_ENDPOINT/$EXTERNAL_ENDPOINT/g"                            ./ibm-eventstreams-icp4i-prod/values_revised_7.yaml > ./ibm-eventstreams-icp4i-prod/values_revised_8.yaml
sed "s/ACCEPT_LICENSE/$ACCEPT_LICENSE/g"                                  ./ibm-eventstreams-icp4i-prod/values_revised_8.yaml > ./ibm-eventstreams-icp4i-prod/values.yaml 
rm ./ibm-eventstreams-icp4i-prod/values_revised_1.yaml
rm ./ibm-eventstreams-icp4i-prod/values_revised_2.yaml
rm ./ibm-eventstreams-icp4i-prod/values_revised_3.yaml
rm ./ibm-eventstreams-icp4i-prod/values_revised_4.yaml
rm ./ibm-eventstreams-icp4i-prod/values_revised_5.yaml
rm ./ibm-eventstreams-icp4i-prod/values_revised_6.yaml
rm ./ibm-eventstreams-icp4i-prod/values_revised_7.yaml
rm ./ibm-eventstreams-icp4i-prod/values_revised_8.yaml

if [ "FILE_STORAGE" = "nfs" ]; then 
  oc create -f pv.yaml; 
fi;

echo 
echo "Final values.yaml"
echo 

cat ./ibm-eventstreams-icp4i-prod/values.yaml 

echo 
echo "Running Helm Install"
echo   

helm install --name $RELEASE --namespace $PROJECT  ibm-eventstreams-icp4i-prod --timeout 1200 --tls --debug

echo
echo "Eventstreams is now installed"

