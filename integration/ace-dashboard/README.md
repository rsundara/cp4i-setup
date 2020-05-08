# Install IBM ACE Dashboard

The following artifacts are available for ACE Dashboard installation:

- [setup.sh](./setup.sh) - Utility for setting up the project for the install
- [install.sh](./install.sh) - Utility for installing ACE Dashboard
- [uninstall.sh](./uninstall.sh) - Utility for uninstalling ACE Dashboard
- [pv.yam](./pv.yaml) - Manifest for creating Persistent Volume 

The following environment variables can be set to change the default used for the setup:

* **CLOUD_TYPE** - Can be set to **ibmcloud** to choose the defaults for IBM Cloud.
* **PRODUCTION** - Can be set **true** or **false** to enable or disable High Availability.
* **OFFLINE_INSTALL** - Can be set to **true** or **false**. If set to true **image-registry.openshift-image-registry.svc:5000** is used as the registry base. If set to false **cp.icr.io** is used as the registry base.
* **STORAGE_FILE** - Can be set to storage class for file storage (RWX).
* **ENV** - Can be set to name of the environment to be used in the Helm Release name.

The following values are changed as part of the install:

| Value                            | Default                                           | Revised Default                         |
|----------------------------------|---------------------------------------------------|-----------------------------------------|
| `license`                        | "not accepted"                                    | "accepted"                              |
| `image.contentServer`            | cp.icr.io/ibm-ace-content-server-prod:11.0.0.8-r1 | offLine : image-registry.openshift-image-registry.svc:5000/ace/ibm-ace-content-server-prod:11.0.0.8-r1 |
|                                  |                                                   | onLine  : cp.icr.io/ibm-ace-content-server-prod:11.0.0.8-r1          |
| `image.controlUI`                | cp.icr.io/ibm-ace-dashboard-prod:11.0.0.8-r1      | offLine : image-registry.openshift-image-registry.svc:5000/ace/ibm-ace-dashboard-prod:11.0.0.8-r1      |
|                                  |                                                   | onLine  : cp.icr.io/ibm-ace-dashboard-prod:11.0.0.8-r1               |
| `image.infra`                    | cp.icr.io/ibm-acecc-infra-prod:11.0.0.8-r1        | offLine : image-registry.openshift-image-registry.svc:5000/ace/ibm-acecc-infra-prod:11.0.0.8-r1        |
|                                  |                                                   | onLine  : cp.icr.io/ibm-acecc-infra-prod:11.0.0.8-r1                 |
| `image.configurator`             | cp.icr.io/ibm-acecc-configurator-prod:11.0.0.8-r1 | offLine : image-registry.openshift-image-registry.svc:5000/ace/ibm-acecc-configurator-prod:11.0.0.8-r1 |
|                                  |                                                   | onLine  : cp.icr.io/ibm-acecc-configurator-prod:11.0.0.8-r1          |
| `image.pullSecret`               |                                                   | offLine : deployer-dockercfg-xxx        |
|                                  |                                                   | onLine  : ibm-entitlement-key           |
| `helmTlsSecret`                  |                                                   | ibm-ace-dashboard-icp4i-prod-helm-certs |
| `productionDeployment`           | true                                              | false                                   |
| `persistence.storageClassName`   | ""                                                | "nfs" / "ibmc-file-gold" (IBMC)         |
| `replicaCount`                   | 3                                                 | 1                                       |

  