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
* **STORAGE_BLOCK** - Can be set to storage class for block storage (RWO).
* **ENV** - Can be set to name of the environment to be used in the Helm Release name.


The following values are changed as part of the install:

| Value                                         | Default                        | Revised Default                          |
|-----------------------------------------------|--------------------------------|------------------------------------------|
| `productionDeployment`                        | true                           | false                                    |
| `image.repository`                            | "cp.icr.io/cp/icp4i/aspera"    | offLine :image-registry.openshift-image-registry.svc:5000/aspera |
|                                               |                                | onLine  : cp.icr.io/cp/icp4i/aspera      |
| `image.pullSecret`                            | "ibm-entitlement-key"          | offLine : deployer-dockercfg-xxx         |
|                                               |                                | onLine  : ibm-entitlement-key            |
| `redis.persistence.useDynamicProvisioning`    | false                          | true                                     |
| `redis.persistence.storageClassName`          |                                | "nfs" / "ibmc-file-gold" (IBMC)          |
| `redis.image.repository`                      |                                | offLine :image-registry.openshift-image-registry.svc:5000/aspera |
|                                               |                                | onLine  : cp.icr.io/cp/icp4i/aspera      |
| `redis.image.pullSecret`                      |                                | "ibm-entitlement-key"                    |
| `ingress.hostname`                            | null                           | aspera.apps.DOMAIN                       |
| `persistence.useDynamicProvisioning`          | true                           | false                                    |
| `persistence.storageClassName`                |                                | "nfs" / "ibmc-file-gold" (IBMC)          |
| `asperanode.nodeCount`                        | 3                              | 1                                        |
| `asperanode.serverSecret`                     | null                           | aspera-server                            |
| `asperanode.nodeAdminSecret`                  | null                           | asperanode-nodeadmin                     |
| `asperanode.accessKeySecret`                  | null                           | asperanode-accesskey                     |
| `asperanode.image.repository`                 |                                | offLine :image-registry.openshift-image-registry.svc:5000/aspera |
|                                               |                                | onLine  : cp.icr.io/cp/icp4i/aspera      |
| `asperanode.autoscale.api.minReplicas`        | 3                              | 1                                        |
| `asperanode.autoscale.api.maxReplicas`        | 5                              | 1                                        |
| `aei.kafkaHost`                               |                                | icp-proxy.apps.DOMAIN                    |
| `aei.kafkaPort`                               | 9092                           | 3xxxxx                                   |
| `aei.replicas`                                | 3                              | 1                                        |
| `aei.image.repository`                        |                                | offLine :image-registry.openshift-image-registry.svc:5000/aspera |
|                                               |                                | onLine  : cp.icr.io/cp/icp4i/aspera      |
| `prometheusEndpoint.replicas`                 | 3                              | 1                                        |
| `prometheusEndpoint.image.repository`         |                                | offLine :image-registry.openshift-image-registry.svc:5000/aspera |
|                                               |                                | onLine  : cp.icr.io/cp/icp4i/aspera      |
| `stats.replicas`                              | 3                              | 1                                        |
| `stats.image.repository`                      |                                | offLine :image-registry.openshift-image-registry.svc:5000/aspera |
|                                               |                                | onLine  : cp.icr.io/cp/icp4i/aspera      |
| `ascpLoadbalancer.replicas`                   | 3                              | 1                                        |
| `utils.image.repository`                      |                                | offLine :image-registry.openshift-image-registry.svc:5000/aspera |
|                                               |                                | onLine  : cp.icr.io/cp/icp4i/aspera      |
| `ascpSwarm.replicas`                          | 3                              | 1                                        |
| `ascpSwarm.config.maxRunning`                 | 2                              | 1                                        |
| `ascpSwarm.config.nodeLabels`                 | {}                             | {-node-role.kubernetes.io/ascp: "true"}  |
| `loadbalancer.image.repository`               |                                | offLine :image-registry.openshift-image-registry.svc:5000/aspera |
|                                               |                                | onLine  : cp.icr.io/cp/icp4i/aspera      |
| `nodedLoadbalancer.replicas`                  | 3                              | 1                                        |
| `swarm.image.repository`                      |                                | offLine :image-registry.openshift-image-registry.svc:5000/aspera |
|                                               |                                | onLine  : cp.icr.io/cp/icp4i/aspera      |
| `nodedSwarm.replicas`                         | 3                              | 1                                        |
| `nodedSwarm.config.maxRunning`                | 2                              | 1                                        |
| `nodedSwarm.config.nodeLabels`                | {}                             | {-node-role.kubernetes.io/noded: "true"} |
| `firstboot.image.repository`                  |                                | offLine :image-registry.openshift-image-registry.svc:5000/aspera |
|                                               |                                | onLine  : cp.icr.io/cp/icp4i/aspera      |
| `nodedSwarmMember.image.repository`           |                                | offLine :image-registry.openshift-image-registry.svc:5000/aspera |
|                                               |                                | onLine  : cp.icr.io/cp/icp4i/aspera      |
| `receiver.swarm.image.repository`             |                                | offLine :image-registry.openshift-image-registry.svc:5000/aspera |
|                                               |                                | onLine  : cp.icr.io/cp/icp4i/aspera      |
| `httpProxy.replicas`                          | 3                              | 1                                        |
| `httpProxy.image.repository`                  |                                | offLine :image-registry.openshift-image-registry.svc:5000/aspera |
|                                               |                                | onLine  : cp.icr.io/cp/icp4i/aspera      |
| `tcpProxy.replicas`                           | 3                              | 1                                        |
| `tcpProxy.image.repository`                   |                                | offLine :image-registry.openshift-image-registry.svc:5000/aspera |
|                                               |                                | onLine  : cp.icr.io/cp/icp4i/aspera      |
| `probe.image.repository`                      |                                | offLine :image-registry.openshift-image-registry.svc:5000/aspera |
|                                               |                                | onLine  : cp.icr.io/cp/icp4i/aspera      |
| `election.image.repository`                   |                                | offLine :image-registry.openshift-image-registry.svc:5000/aspera |
|                                               |                                | onLine  : cp.icr.io/cp/icp4i/aspera      |
| `rproxy.address`                              |                                | 1.1.1.1                                  |
| `sch.global.image.repository`                 |                                | offLine :image-registry.openshift-image-registry.svc:5000/aspera |
|                                               |                                | onLine  : cp.icr.io/cp/icp4i/aspera      |
| `sch.image.pullSecret`                        |                                | offLine : deployer-dockercfg-xxx         |
|                                               |                                | onLine  : ibm-entitlement-key            |
