# Install IBM API Connect

The following artifacts are available for API Connect installation:

- [setup.sh](./setup.sh) - Utility for setting up the project for the install
- [install.sh](./install.sh) - Utility for installing API Connect
- [uninstall.sh](./uninstall.sh) - Utility for uninstalling API Connect

The following environment variables can be set to change the default used for the setup:

* **CLOUD_TYPE** - Can be set to **ibmcloud** to choose the defaults for IBM Cloud.
* **PRODUCTION** - Can be set **true** or **false** to enable or disable High Availability.
* **OFFLINE_INSTALL** - Can be set to **true** or **false**. If set to true **image-registry.openshift-image-registry.svc:5000** is used as the registry base. If set to false **cp.icr.io** is used as the registry base.
* **STORAGE_BLOCK** - Can be set to storage class for block storage (RWO).
* **ENV** - Can be set to name of the environment to be used in the Helm Release name.

The following values are changed as part of the install:

| Value                                                | Default                   | Revised Default                              |
|------------------------------------------------------|---------------------------|----------------------------------------------|
| `productionDeployment`                               | false                     | true                                         |
| `global.registry`                                    | "cp.icr.io/cp/icp4i/apic" | offLine : image-registry.openshift-image-registry.svc:5000/apic  |
|                                                      |                           | onLine  : cp.icr.io/cp/icp4i/apic            |
| `global.registrySecret`                              |                           | offLine : deployer-dockercfg-xxx             |
|                                                      |                           | onLine  : ibm-entitlement-key                |
| `global.storageClass`                                |                           | "rook-ceph-block" / "ibmc-block-gold" (IBMC) |
| `global.mode`                                        | "standard"                | "dev"                                        |
| `operator.helmTlsSecret`                             |                           | "apic-ent-helm-tls"                          |
| `management.platformApiEndpoint`                     |                           | mgmt.icp-proxy.DOMAIN                        |
| `management.consumerApiEndpoint`                     |                           | mgmt.icp-proxy.DOMAIN                        |
| `management.cloudAdminUiEndpoint`                    |                           | mgmt.icp-proxy.DOMAIN                        |
| `management.apiManagerUiEndpoint`                    |                           | mgmt.icp-proxy.DOMAIN                        |
| `cassandra.cassandraClusterSize`                     | 3                         | 1                                            |
| `portal.portalDirectorEndpoint`                      |                           | padmin.icp-proxy.DOMAIN                      |
| `portal.portalWebEndpoint`                           |                           | portal.icp-proxy.DOMAIN                      |
| `analytics.analyticsIngestionEndpoint`               |                           | ai.icp-proxy.DOMAIN                          |
| `analytics.analyticsClientEndpoint`                  |                           | ac.icp-proxy.DOMAIN                          |
| `gateway.apiGatewayEndpoint`                         |                           | apigw.icp-proxy.DOMAIN                       |
| `gateway.gatewayServiceEndpoint`                     |                           | apigwd.icp-proxy.DOMAIN                      |
| `gateway.replicaCount`                               | 3                         | 1                                            |
| `gateway.v5CompatibilityMode                         | true                      | true                                         |
| `gateway.highPerformancePeering`                     |                           | off                                          |
| `gateway.odTracing.enabled`                          | false                     | true                                         |