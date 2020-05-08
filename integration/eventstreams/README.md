# Install Eventstreams

The following artifacts are available for Eventstreams installation:

- [setup.sh](./setup.sh) - Utility for setting up the project for the install
- [install.sh](./install.sh) - Utility for installing Eventstreams
- [uninstall.sh](./uninstall.sh) - Utility for uninstalling Eventstreams
- [pv.yam](./pv.yaml) - Manifest for creating Persistent Volume
- [pvc.yam](./pvc.yaml) - Manifest for creating Persistent Volume Claim

The following environment variables can be set to change the default used for the setup:

* **CLOUD_TYPE** - Can be set to **ibmcloud** to choose the defaults for IBM Cloud.
* **PRODUCTION** - Can be set **true** or **false** to enable or disable High Availability.
* **OFFLINE_INSTALL** - Can be set to **true** or **false**. If set to true **image-registry.openshift-image-registry.svc:5000** is used as the registry base. If set to false **cp.icr.io** is used as the registry base.
* **STORAGE_FILE** - Can be set to storage class for file storage (RWX).
* **ENV** - Can be set to name of the environment to be used in the Helm Release name.

The following values are changed as part of the install:

| Value                                                | Default                | Revised Default                               |
|------------------------------------------------------|------------------------|-----------------------------------------------|
| `global.production`                                  | false                  | true                                          |
| `global.image.repository`                            | cp.icr.io/cp/icp4i/es  | offLine : image-registry.openshift-image-registry.svc:5000/eventstreams  |
|                                                      |                        | onLine  : cp.icr.io/cp/icp4i/es               |
| `global.image.pullSecret`                            |                        | offLine : deployer-dockercfg-xxx              |
|                                                      |                        | onLine  : ibm-entitlement-key                 |
| `icp4i.icp4iPlatformNamespace`                       |                        | integration                                   |
| `persistence.enabled`                                | false                  | true                                          |
| `persistence.useDynamicProvisioning`                 | false                  | true                                          |
| `persistence.dataPVC.storageClassName`               |                        | "rook-ceph-block" / "ibmc-block-gold" (IBMC)  |
| `zookeeper.persistence.useDynamicProvisioning`       | false                  | true                                          |
| `zookeeper.persistence.storageClassName`             |                        | "rook-ceph-block" / "ibmc-block-gold" (IBMC)  |
| `zookeeper.dataPVC.storageClassName`                 |                        | "nfs" / "ibmc-file-gold" (IBMC)               |
| `proxy.externalEndpoint`                             |                        | icp-proxy.apps.DOMAIN                         |
| `schema-registry.persistence.enabled`                | false                  | true                                          |
| `schema-registry.persistence.useDynamicProvisioning` | false                  | true                                          |
| `schema-registry.dataPVC.storageClassName`           |                        | "nfs" / "ibmc-file-gold" (IBMC)               |
| `license`                                            | "not accepted"         | "accept"                                      |
