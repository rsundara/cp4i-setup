#!/bin/bash

PROJECT=mq

oc create -f mq.yaml

oc adm policy add-scc-to-group ibm-anyuid-scc system:serviceaccounts:$PROJECT
oc adm policy add-scc-to-group anyuid system:serviceaccounts:$PROJECT

echo "Setup of MQ is now complete"
echo
