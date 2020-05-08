# Install IBM DataPower 

The following artifacts are available for DataPower installation:

- [setup.sh](./setup.sh) - Utility for setting up the project for the install
- [install.sh](./install.sh) - Utility for installing DataPower
- [uninstall.sh](./uninstall.sh) - Utility for uninstalling DataPower

The following environment variables can be set to change the default used for the setup:

* **PRODUCTION** - Can be set **true** or **false** to enable or disable High Availability.
* **OFFLINE_INSTALL** - Can be set to **true** or **false**. If set to true **image-registry.openshift-image-registry.svc:5000** is used as the registry base. If set to false **cp.icr.io** is used as the registry base.
* **ENV** - Can be set to name of the environment to be used in the Helm Release name.

The following values are changed as part of the install:

| Value                                 | Default             | Revised Default                        |
|---------------------------------------|---------------------|----------------------------------------|
| `datapower.image.pullSecret`          |                     | offLine : deployer-dockercfg-xxx       |
|                                       |                     | onLine  : ibm-entitlement-key          |
| `datapower.image.repository`          | cp.icr.io/datapower | offLine : image-registry.openshift-image-registry.svc:5000/datapower  |
|                                       |                     | onLine  : cp.icr.io/datapower          |
| `datapower.resources.limits.cpu`      | 8                   | 4                                      |
| `datapower.resources.limits.memory`   | 64Gi                | 8Gi                                    |
| `patternName`                         | None                | restProxy                              |
