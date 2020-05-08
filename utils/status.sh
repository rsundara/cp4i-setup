#!/bin/bash

echo "Failing pods:"
oc get pods --all-namespaces -o wide | grep -v Running | grep -v Completed
