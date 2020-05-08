# Install IBM ACE Designer

The following artifacts are available for ACE Designer installation:

- [setup.sh](./setup.sh) - Utility for setting up the project for the install
- [install.sh](./install.sh) - Utility for installing ACE Designer
- [uninstall.sh](./uninstall.sh) - Utility for uninstalling ACE Designer

The following environment variables can be set to change the default used for the setup:

* **CLOUD_TYPE** - Can be set to **ibmcloud** to choose the defaults for IBM Cloud.
* **PRODUCTION** - Can be set **true** or **false** to enable or disable High Availability.
* **OFFLINE_INSTALL** - Can be set to **true** or **false**. If set to true **image-registry.openshift-image-registry.svc:5000** is used as the registry base. If set to false **cp.icr.io** is used as the registry base.
* **STORAGE_BLOCK** - Can be set to storage class for block storage (RWO).
* **ENV** - Can be set to name of the environment to be used in the Helm Release name.

The following values are changed as part of the install:

| Value                                    | Default                                                              | Revised Default                                                                                                   |
|------------------------------------------|----------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------|
| `license`                                | "not accepted"                                                       | "accepted" |
| `image.fireflyFlowdocAuthoring`          | cp.icr.io/ibm-app-connect-flowdoc-authoring-prod:11.0.0.8-r1         | offLine : image-registry.openshift-image-registry.svc:5000/ace/ibm-app-connect-flowdoc-authoring-prod:11.0.0.8-r1 |
|                                          |                                                                      | onLine  : cp.icr.io/ibm-app-connect-flowdoc-authoring-prod:11.0.0.8-r1 |
| `image.fireflyFlowTestManager`           | cp.icr.io/ibm-app-connect-flow-test-manager-prod:11.0.0.8-r1         | offLine : image-registry.openshift-image-registry.svc:5000/ace/ibm-app-connect-flow-test-manager-prod:11.0.0.8-r1 |
|                                          |                                                                      | onLine  : cp.icr.io/ibm-app-connect-flow-test-manager-prod:11.0.0.8-r1 |
| `image.fireflyRuntime`                   | cp.icr.io/ibm-app-connect-runtime-prod:11.0.0.8-r1                   | offLine : image-registry.openshift-image-registry.svc:5000/ace/ibm-app-connect-runtime-prod:11.0.0.8-r1 |
|                                          |                                                                      | onLine  : cp.icr.io/ibm-app-connect-runtime-prod:11.0.0.8-r1 |
| `image.fireflyUi`                        | cp.icr.io/ibm-app-connect-ui-prod:11.0.0.8-r1                        | offLine : image-registry.openshift-image-registry.svc:5000/ace/ibm-app-connect-ui-prod:11.0.0.8-r1  |
|                                          |                                                                      | onLine  : cp.icr.io/ibm-app-connect-ui-prod:11.0.0.8-r1  |
| `image.connectorAuthService`             | cp.icr.io/ibm-app-connect-connector-auth-service-prod:11.0.0.8-r1    | offLine : image-registry.openshift-image-registry.svc:5000/ace/ibm-app-connect-connector-auth-service-prod:11.0.0.8-r1 |
|                                          |                                                                      | onLine  : cp.icr.io/ibm-app-connect-connector-auth-service-prod:11.0.0.8-r1 |
| `image.proxy`                            | cp.icr.io/ibm-app-connect-proxy-prod:11.0.0.8-r1                     | offLine : image-registry.openshift-image-registry.svc:5000/ace/ibm-app-connect-proxy-prod:11.0.0.8-r1 |
|                                          |                                                                      | onLine  : cp.icr.io/ibm-app-connect-proxy-prod:11.0.0.8-r1 |
| `image.configurator`                     | cp.icr.io/ibm-acecc-configurator-prod:11.0.0.8-r1                    | offLine : image-registry.openshift-image-registry.svc:5000/ace/ibm-acecc-configurator-prod:11.0.0.8-r1  |
|                                          |                                                                      | onLine  : cp.icr.io/ibm-acecc-configurator-prod:11.0.0.8-r1  |
| `image.pullSecret`                       |                                                                      | offLine : deployer-dockercfg-xxx       |
|                                          |                                                                      | onLine  : ibm-entitlement-key          |
| `ibm-ace-server-dev.image.aceonly`       | cp.icr.io/ibm-ace-server-dev:11.0.0.8-r1                             | offLine : image-registry.openshift-image-registry.svc:5000/ace/ibm-ace-server-dev:11.0.0.8-r1 |
|                                          |                                                                      | onLine  : cp.icr.io/ibm-ace-server-dev:11.0.0.8-r1 | 
| `ibm-ace-server-dev.image.configurator`  | cp.icr.io/ibm-acecc-configurator-dev:11.0.0.8-r1                     | offLine : image-registry.openshift-image-registry.svc:5000/ace/ibm-acecc-configurator-dev:11.0.0.8-r1 |
|                                          |                                                                      | onLine  : cp.icr.io/ibm-acecc-configurator-dev:11.0.0.8-r1 |
| `ibm-ace-server-dev.image.designerflows` | cp.icr.io/ibm-ace-designer-flows-dev:11.0.0.8-r1                     | offLine : image-registry.openshift-image-registry.svc:5000/ace/ibm-ace-designer-flows-dev:11.0.0.8-r1 |
|                                          |                                                                      | onLine  : cp.icr.io/ibm-ace-designer-flows-dev:11.0.0.8-r1 |
| `ibm-ace-server-dev.image.proxy`         | cp.icr.io/ibm-app-connect-proxy-dev:11.0.0.8-r1                      | offLine : image-registry.openshift-image-registry.svc:5000/ace/ibm-app-connect-proxy-dev:11.0.0.8-r1 |
|                                          |                                                                      | onLine  : cp.icr.io/ibm-app-connect-proxy-dev:11.0.0.8-r1|
| `ibm-ace-server-dev.image.connectors`    | cp.icr.io/ibm-ace-lcp-dev:11.0.0.8-r1                                | offLine : image-registry.openshift-image-registry.svc:5000/ace/ibm-ace-lcp-dev:11.0.0.8-r1 |
|                                          |                                                                      | onLine  : cp.icr.io/ibm-ace-lcp-dev:11.0.0.8-r1 |
| `ibm-ace-server-dev.image.pullSecret`    |                                                                      | offLine : deployer-dockercfg-xxx        |
|                                          |                                                                      | onLine  : ibm-entitlement-key          |
| `couchdb.image.repository`               | cp.icr.io/ibm-couchdb2                                               | offLine : image-registry.openshift-image-registry.svc:5000/ace/ibm-couchdb2 |
|                                          |                                                                      | onLine  : cp.icr.io/ibm-couchdb2 |
| `couchdb.image.pullSecret`               |                                                                      | offLine : deployer-dockercfg-xxx       |
|                                          |                                                                      | onLine  : ibm-entitlement-key          |
| `couchdb.persistentVolume.storageClass`  |                                                                      | "rook-ceph-block" / "ibmc-block-gold" (IBMC) | 


