# Install IBM Tracing

The following artifacts are available for Tracing installation:

- [setup.sh](./setup.sh) - Utility for setting up the project for the install
- [install.sh](./install.sh) - Utility for installing Tracing
- [uninstall.sh](./uninstall.sh) - Utility for uninstalling Tracing

The following environment variables can be set to change the default used for the setup:

* **CLOUD_TYPE** - Can be set to **ibmcloud** to choose the defaults for IBM Cloud.
* **PRODUCTION** - Can be set **true** or **false** to enable or disable High Availability.
* **OFFLINE_INSTALL** - Can be set to **true** or **false**. If set to true **image-registry.openshift-image-registry.svc:5000** is used as the registry base. If set to false **cp.icr.io** is used as the registry base.
* **STORAGE_FILE** - Can be set to storage class for file storage (RWX).
* **ENV** - Can be set to name of the environment to be used in the Helm Release name.

The following values are changed as part of the install:

| Value                                                | Default                | Revised Default                             |
|------------------------------------------------------|------------------------|---------------------------------------------|
| `global.images.registry`                             | cp.icr.io/cp/icp4i/od  | offLine :image-registry.openshift-image-registry.svc:5000/tracing            |
|                                                      |                        | onLine  : cp.icr.io/cp/icp4i/od               |    
| `global.images.pullSecret`                           |                        | offLine : deployer-dockercfg-xxx            |
|                                                      |                        | onLine  : ibm-entitlement-key               |
| `ingress.odUiHost`                                   |                        | icp-proxy.apps.DOMAIN                       |
| `platformNavigatorHost`                              |                        | ibm-icp4i-prod-integration.apps.DOMAIN      |
| `elasticsearch.volumeClaimTemplate.storageClassName` |                        | "rook-ceph-block" / "ibmc-block-gold"(IBMC) |
| `configdb.storageClassName`                          |                        | "rook-ceph-block" / "ibmc-block-gold"(IBMC) |
