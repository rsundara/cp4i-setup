# cp4i-setup

This repository includes utilities for setting up Cloud Pak for Integration. 


<p>&nbsp;</p>

### Pre-requisites

It is required to have the following CLIs already installed in your environment. 

* [OpenShift CLI](https://cloud.ibm.com/docs/openshift?topic=openshift-openshift-cli)
* [CloudCtl CLI](https://www.ibm.com/support/knowledgecenter/en/SSBS6K_3.2.1/manage_cluster/install_cli.html)
* [Helm CLI](https://www.ibm.com/support/knowledgecenter/en/SSBS6K_3.2.1/app_center/create_helm_cli.html)

After CloudCtl CLI is installed, login to the IBM Cloud Pak Common Services console using the following command:
```
cloudctl login -a https://icp-console.MYDOMAIN/
```

After Helm CLI is installed, the following command should be run: 

```
helm init --client-only
```

**Note:** It is required to login to OpenShift cluster after the helm init command is run. 

<p>&nbsp;</p>

### Create Integration instances from command-line

Scripts are available to complete the initial setup (**setup.sh**), create the integration instance (**install.sh**) and remove the integration instance (**uninstall.sh**) for the following components: 

* [App Connect Enterprise Dashboard](./integration/ace-dashboard/README.md)
* [API Connect](./integration/apic/README.md)
* [Aspera](./integration/aspera/README.md)
* [Asset Repo](./integration/assetrepo/README.md)
* [DataPower](./integration/datapower/README.md)
* [Eventstreams](./integration/eventstreams/README.md)
* [MQ](./integration/mq/README.md)
* [Tracing](./integration/tracing/README.md)

**Note #1:** The scripts are designed to create integration instances on OpenShift cluster running on either on-prem and/or on IBM Cloud. The storage classes are set automatically for IBM Cloud when the environment variable **CLOUD_TYPE** has the value **ibmcloud**. 
In case of on-prem, file storage needs to be created to suit the environment. Sample manifests for creating persistent volumes and persistent volume claims are included for reference.

**Note #2:** The scripts can be adjusted to created instances in HA or non-HA mode by setting the configuration parameter **PRODUCTION** to **true** (HA) or **false** (non HA)

**Note #3:** The scripts can be adjusted to select the correct registry using the environment variable **OFFLINE_INSTALL**. If it is set to true, the registry **image-registry.openshift-image-registry.svc:5000** is used as the base. If it is set to false, the registry **cp.icr.io** is used.

**Note #4:** The environment variables **STORAGE_BLOCK** and **STORAGE_FILE** can be used to specify the block and file storage to used for installing the integration instances. The storage class **nfs** and **rook-ceph-block** are used as the default for file and block storage respectively. In case of IBM Cloud, the storage class **ibmc-file-gold** and **ibmc-block-gold** are used as the default for file and block storage respectively.

**Note #5:** The environment variable **ENV** can be used to specify the name of the environment used for the setup. This value is used in computing the Helm release name. By default it is set to **dev**.

<p>&nbsp;</p>

### Create Integration instances using Tekton Pipeline

Tekton pipelines are available to install and uninstall all the integration instances. 

The pipelines are designed to invoke the scripts **setup.sh** and **install.sh** during the install and invoke the script **uninstall.sh** for uninstalling the component. 

* [Tekton pipelines for CP4I setup](./tekton/README.md)

