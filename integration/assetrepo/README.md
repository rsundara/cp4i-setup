# Install AssetRepo

The following artifacts are available for AssetRepo installation:

- [setup.sh](./setup.sh) - Utility for setting up the project for the install
- [install.sh](./install.sh) - Utility for installing AssetRepo
- [uninstall.sh](./uninstall.sh) - Utility for uninstalling AssetRepo
- [pv.yam](./pv.yaml) - Manifest for creating Persistent Volume
- [pvc.yam](./pvc.yaml) - Manifest for creating Persistent Volume Claim

The following environment variables can be set to change the default used for the setup:

* **CLOUD_TYPE** - Can be set to **ibmcloud** to choose the defaults for IBM Cloud.
* **PRODUCTION** - Can be set **true** or **false** to enable or disable High Availability.
* **OFFLINE_INSTALL** - Can be set to **true** or **false**. If set to true **image-registry.openshift-image-registry.svc:5000** is used as the registry base. If set to false **cp.icr.io** is used as the registry base.
* **STORAGE_FILE** - Can be set to storage class for file storage (RWX).
* **STORAGE_BLOCK** - Can be set to storage class for block storage (RWO).
* **ENV** - Can be set to name of the environment to be used in the Helm Release name.

The following values are changed as part of the install:

| Value                                                 | Default              | Revised Default                              |
|-------------------------------------------------------|----------------------|----------------------------------------------|
| `global.images.pullSecret`                            |                      | offLine : deployer-dockercfg-xxx             |
|                                                       |                      | onLine  : ibm-entitlement-key                |
| `global.images.registry  `                            | cp.icr.io/cp/icp4i/  | offLine : image-registry.openshift-image-registry.svc:5000/integration  |
|                                                       |                      | onLine  : cp.icr.io/cp/icp4i/                |
| `prereqs.redis-ha.replicas.servers`                   | 3                    | 1                                            |
| `prereqs.redis-ha.replicas.sentinels`                 | 3                    | 1                                            |
| `assetSync.storageClassName`                          |                      | "nfs" / "ibmc-file-gold" (IBMC)              |
| `assetSync.replicas`                                  | 3                    | 1                                            |
| `assetUI.replicas`                                    | 3                    | 1                                            |
| `couchdb.replicas`                                    | 3                    | 1                                            |
| `couchdb.storageClass`                                |                      | "rook-ceph-block" / "ibmc-block-gold" (IBMC) |
