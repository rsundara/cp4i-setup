#!/bin/bash

PROJECT=tracing
RELEASE=$PROJECT-dev
if [ ! -z "$ENV" ]; then 
  RELEASE=$PROJECT-$ENV
fi;

helm delete $RELEASE --purge --tls

oc project $PROJECT
oc delete pvc --all

echo "Uninstall of Tracing is now complete"
echo
