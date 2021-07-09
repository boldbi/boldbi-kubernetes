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

3. Configure your setting overrides

## Install Chart

```console
# GKE
helm install [RELEASE_NAME] boldbi/boldbi --set clusterProvider=gke,appBaseUrl=<app_base_url>,persistentVolume.gke.fileShareName=<file_share_name>,persistentVolume.gke.fileShareIp=<file_share_ip_address> [flags]

# EKS
helm install [RELEASE_NAME] boldbi/boldbi --set clusterProvider=gke,appBaseUrl=<app_base_url>,persistentVolume.eks.efsFileSystemId=<efs_file_system_id> [flags]

# AKS
helm install [RELEASE_NAME] boldbi/boldbi --set clusterProvider=gke,appBaseUrl=<app_base_url>,persistentVolume.aks.fileShareName=<file_share_name>,persistentVolume.aks.azureStorageAccountName=<base64_azurestorageaccountname>,persistentVolume.aks.azureStorageAccountKey=<base64_azurestorageaccountkey> [flags]

# On-Premise
helm install [RELEASE_NAME] boldbi/boldbi --set clusterProvider=onpremise,appBaseUrl=<app_base_url>,persistentVolume.onpremise.hostPath=/run/desktop/mnt/host/<local_directory> [flags]
```

Just like any typical Helm chart, you'll need to craft a values.yaml file that would define/override any of the values exposed into the default values.yaml

_See [configuration](docs/configuration.md) for more details._

_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._

## Uninstall Chart

```console
helm uninstall [RELEASE_NAME]
```

This removes all the Kubernetes components associated with the chart and deletes the release.

_See [helm uninstall](https://helm.sh/docs/helm/helm_uninstall/) for command documentation._

## Upgrade Chart

```console
helm upgrade [RELEASE_NAME] boldbi/boldbi [flags]
```

_See [helm upgrade](https://helm.sh/docs/helm/helm_upgrade/) for command documentation._

## Application Startup

Configure the Bold BI On-Premise application startup to use the application. Please refer the following link for more details on configuring the application startup.
    
https://help.boldbi.com/embedded-bi/application-startup