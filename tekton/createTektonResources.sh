#!/bin/sh

oc new-project cp4i-setup

oc create -f ./manifests/cp4i-setup-secrets.yaml

oc create -f ./manifests/cp4i-setup-resource.yaml

oc create -f ./manifests/install-integration-instance-task.yaml
oc create -f ./manifests/uninstall-integration-instance-task.yaml

oc create -f ./manifests/cp4i-setup-pipeline.yaml
