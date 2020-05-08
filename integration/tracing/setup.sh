#!/bin/bash

PROJECT=tracing

oc project $PROJECT
oc create -f tracing.yaml 

echo "Setup of Tracing is now complete"
echo
