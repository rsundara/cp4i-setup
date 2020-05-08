#!/bin/sh

oc delete -f ./manifests/cp4i-setup-secrets.yaml

oc delete -f ./manifests/cp4i-setup-resource.yaml

oc delete -f ./manifests/install-integration-instance-task.yaml
oc delete -f ./manifests/uninstall-integration-instance-task.yaml

oc delete -f ./manifests/cp4i-setup-pipeline.yaml
