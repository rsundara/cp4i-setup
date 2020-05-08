while true; 
  do
    kubectl -n openshift-image-registry port-forward svc/image-registry 5000:5000;
  done
