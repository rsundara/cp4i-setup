#!/bin/bash

oc create -f assetrepo.yaml

PROJECT=assetrepo

oc project $PROJECT
oc adm policy add-scc-to-group ibm-privileged-scc system:serviceaccounts:$PROJECT
oc adm policy add-scc-to-group ibm-anyuid-scc system:serviceaccounts:$PROJECT

oc policy add-role-to-user \
    system:image-puller system:serviceaccount:assetrepo:default \
    -n integration

echo "Setup of Asset Repository is now complete"
echo

