# Install MQ

The following artifacts are available for MQ installation:

- [setup.sh](./setup.sh) - Utility for setting up the project for the install
- [install.sh](./install.sh) - Utility for installing MQ
- [uninstall.sh](./uninstall.sh) - Utility for uninstalling MQ
- [pv.yam](./pv.yaml) - Manifest for creating Persistent Volume
- [pvc.yam](./pvc.yaml) - Manifest for creating Persistent Volume Claim

The following environment variables can be set to change the default used for the setup:

* **CLOUD_TYPE** - Can be set to **ibmcloud** to choose the defaults for IBM Cloud.
* **PRODUCTION** - Can be set **true** or **false** to enable or disable High Availability.
* **OFFLINE_INSTALL** - Can be set to **true** or **false**. If set to true **image-registry.openshift-image-registry.svc:5000** is used as the registry base. If set to false **cp.icr.io** is used as the registry base.
* **STORAGE_FILE** - Can be set to storage class for file storage (RWX).
* **ENV** - Can be set to name of the environment to be used in the Helm Release name.

The following values are changed as part of the install:

| Value                                                | Default                                          | Revised Default                     |
|------------------------------------------------------|--------------------------------------------------|-------------------------------------|
| `license`                                            | "not accepted"                                   | "accept"                            |  
| `productionDeployment`                               | true                                             | false                               | 
| `image.repository`                                   | cp.icr.io/ibm-mqadvanced-server-integration      | offLine : image-registry.openshift-image-registry.svc:5000/mq/ibm-mqadvanced-server-integration |
|                                                      |                                                  | onLine  : cp.icr.io/ibm-mqadvanced-server-integration |
| `image.pullSecret`                                   |                                                  | offLine : deployer-dockercfg-xxx    |
|                                                      |                                                  | onLine  : ibm-entitlement-key       |
| `sso.registrationImage.repository`                   | cp.icr.io/ibm-mq-oidc-registration               | offLine : image-registry.openshift-image-registry.svc:5000/mq/ibm-mq-oidc-registration |
|                                                      |                                                  | onLine  : cp.icr.io/ibm-mq-oidc-registration |
| `tls.generate`                                       | false                                            | true                                |
| `tls.hostname`                                       |                                                  | icp-proxy.apps.DOMAIN               | 
| `storageClassName`                                   |                                                  | "nfs" / "ibmc-file-gold"(IBMC)      | 
| `dataPVC.storageClassName'                           |                                                  | "nfs" / "ibmc-file-gold"(IBMC)      | 
| `logPVC.storageClassName`                            |                                                  | "nfs" / "ibmc-file-gold"(IBMC)      | 
| `queueManager.name`                                  |                                                  | "MYQMGR"                            |
| `odTracingConfig.enabled`                            | false                                            | true                                |
| `odTracingConfig.odAgentImageRepository`             | cp.icr.io/icp4i-od-agent                         | offLine : image-registry.openshift-image-registry.svc:5000/mq/icp4i-od-agent |
|                                                      |                                                  | onLine  : cp.icr.io/mq/icp4i-od-agent |
| `odTracingConfig.odCollectorImageRepository`         | cp.icr.io/icp4i-od-collector                     | offLine : image-registry.openshift-image-registry.svc:5000/mq/icp4i-od-collector |
|                                                      |                                                  | onLine  : cp.icr.io/icp4i-od-collector |
| `odTracingConfig.odTracingNamespace`                 | ""                                               | "tracing"                           |
