#!/bin/bash

oc create -f eventstreams.yaml

PROJECT=eventstreams

oc project $PROJECT
oc adm policy add-scc-to-group anyuid system:serviceaccounts:$PROJECT
oc adm policy add-scc-to-group ibm-anyuid-scc system:serviceaccounts:$PROJECT

echo "Setup of Eventstreams is now complete"
echo
