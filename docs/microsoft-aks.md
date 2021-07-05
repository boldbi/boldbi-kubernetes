# Bold BI on Microsoft Azure Kubernetes Service

## Deployment prerequisites

1. Create a Kubernetes cluster in Microsoft Azure Kubernetes Service (AKS) to deploy Bold BI.

2. Create a File share instance in your storage account and note the File share name to store the shared folders for applications’ usage.

3. Encode the storage account name and storage key in base64 format.

4. Connect with your Microsoft AKS cluster.

## Get Repo Info

```console
$ helm repo add rahul-subash https://rahul-subash.github.io/helm-chart
$ helm repo update
```

_See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation._

## Install Chart

```console
# Helm 3
$ helm install [RELEASE_NAME] rahul-subash/boldbi --set clusterType=aks,appBaseUrl=[Host URL],persistentVolume.aks.fileShareName=[File share name],persistentVolume.aks.azureStorageAccountName=[base64_azurestorageaccountname],persistentVolume.aks.azureStorageAccountKey=[base64_azurestorageaccountkey] [flags]
```

_See [configuration](configuration.md) below._

_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._

## Uninstall Chart

```console
# Helm 3
$ helm uninstall [RELEASE_NAME]
```

This removes all the Kubernetes components associated with the chart and deletes the release.

_See [helm uninstall](https://helm.sh/docs/helm/helm_uninstall/) for command documentation._

## Upgrade Chart

```console
# Helm 3
$ helm upgrade [RELEASE_NAME] rahul-subash/boldbi [flags]
```

_See [helm upgrade](https://helm.sh/docs/helm/helm_upgrade/) for command documentation._

Visit the chart's [CHANGELOG](./CHANGELOG.md) to view the chart's release history.
For migration between major version check [migration guide](#migration-guide).

## Application Startup

Configure the Bold BI On-Premise application startup to use the application. Please refer the following link for more details on configuring the application startup.
    
https://help.boldbi.com/embedded-bi/application-startup