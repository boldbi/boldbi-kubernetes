# Deploy Bold BI using Helm

This chart installs [Bold BI](https://www.boldbi.com/) on Kubernetes. You can create Kubernetes cluster on either cloud or on-premise infrastructure. Please follow the below documentation for Bold BI deployment in a specific cloud and on-premise environments.
    
## Deployment prerequisites

* [Create a cluster](docs/pre-requisites.md#create-a-cluster)
* [File Storage](docs/pre-requisites.md#file-storage)
* [Load Balancing](docs/pre-requisites.md#load-balancing)

## Running

1. Add the Bold BI helm repository

```console
helm repo add boldbi https://boldbi.github.io/boldbi-kubernetes
helm repo update
```

2. View charts in repo

```console
helm search repo boldbi

NAME            CHART VERSION   APP VERSION     DESCRIPTION
boldbi/boldbi   0.1.2           4.1.45          Embed powerful analytics inside your apps and t...
```

_See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation._

## Install Chart

### Install Bold BI in GKE cluster

```console
helm install [RELEASE_NAME] boldbi/boldbi --set clusterProvider=gke,appBaseUrl=<app_base_url>,persistentVolume.gke.fileShareName=<file_share_name>,persistentVolume.gke.fileShareIp=<file_share_ip_address> [flags]
```

> **INFO:**  
* clusterProvider: The type of kubernetes cluster provider you are using.
* appBaseUrl: Domain or IP address of the machine with http protocol.
* persistentVolume.gke.fileShareName: The `File share name` of your filestore instance.
* persistentVolume.gke.fileShareIp: The `IP address` of your filestore instance.

Refer [here](docs/configuration.md) for advanced configuration including SSL termination, optional client libraries, etc.

### Install Bold BI in EKS cluster

```console
helm install [RELEASE_NAME] boldbi/boldbi --set clusterProvider=eks,appBaseUrl=<app_base_url>,persistentVolume.eks.efsFileSystemId=<efs_file_system_id> [flags]
```

> **INFO:**  
* clusterProvider: The type of kubernetes cluster provider you are using.
* appBaseUrl: Domain or IP address of the machine with http protocol.
* persistentVolume.eks.efsFileSystemId: The `File system ID` of your EFS file system.

Refer [here](docs/configuration.md) for advanced configuration including SSL termination, optional client libraries, etc.

### Install Bold BI in AKS cluster

```console
helm install [RELEASE_NAME] boldbi/boldbi --set clusterProvider=aks,appBaseUrl=<app_base_url>,persistentVolume.aks.fileShareName=<file_share_name>,persistentVolume.aks.azureStorageAccountName=<base64_azurestorageaccountname>,persistentVolume.aks.azureStorageAccountKey=<base64_azurestorageaccountkey> [flags]
```

> **INFO:**  
* clusterProvider: The type of kubernetes cluster provider you are using.
* appBaseUrl: Domain or IP address of the machine with http protocol.
* persistentVolume.aks.fileShareName: The `File share name` of your File share instance.
* persistentVolume.aks.azureStorageAccountName: The `base64 encoded storage account name` of the File share instance in your storage account.
* persistentVolume.aks.azureStorageAccountKey: The `base64 encoded storage account key` of the File share instance in your storage account.

Refer [here](docs/configuration.md) for advanced configuration including SSL termination, optional client libraries, etc.

### Install Bold BI in On-Premise cluster

```console
helm install [RELEASE_NAME] boldbi/boldbi --set clusterProvider=onpremise,appBaseUrl=<app_base_url>,persistentVolume.onpremise.hostPath=/run/desktop/mnt/host/<local_directory> [flags]
```

> **INFO:**  
* clusterProvider: The type of kubernetes cluster provider you are using.
* appBaseUrl: Domain or IP address of the machine with http protocol.
* persistentVolume.onpremise.hostPath: The shared folder path in your host machine.

Refer [here](docs/configuration.md) for advanced configuration including SSL termination, optional client libraries, etc.

### Install Bold BI with Istio Ingress Gateway

To install Bold BI with Istio, run the helm install command with the following flag. Please refere [here](docs/configuration.md#istio-ingress-gateway) for more details.

```console
helm install [RELEASE_NAME] boldbi/boldbi --set loadBalancer.type=istio [flags]
```

Refer [here](docs/configuration.md) for advanced configuration including SSL termination, optional client libraries, etc.

## Advanced Installation

Just like any typical Helm chart, you'll need to craft a `values.yaml` file that would define/override any of the values exposed into the default [values.yaml](boldbi/values.yaml)

```console
helm install [RELEASE_NAME] boldbi/boldbi -f my-values.yaml
```

Refer [here](docs/configuration.md) for advanced configuration including SSL termination, optional client libraries, etc.

_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._

## Upgrade Chart

```console
helm upgrade [RELEASE_NAME] boldbi/boldbi [flags]
```

_See [helm upgrade](https://helm.sh/docs/helm/helm_upgrade/) for command documentation._

## Uninstall Chart

```console
helm uninstall [RELEASE_NAME]
```

This removes all the Kubernetes components associated with the chart and deletes the release.

_See [helm uninstall](https://helm.sh/docs/helm/helm_uninstall/) for command documentation._

## Application Startup

Configure the Bold BI On-Premise application startup to use the application. Please refer the following link for more details on configuring the application startup.
    
https://help.boldbi.com/embedded-bi/application-startup