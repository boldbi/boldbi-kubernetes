# Bold BI on Google Kubernetes Engine

## Deployment prerequisites

1. Create a Kubernetes cluster in Google Cloud Platform (GCP) to deploy Bold BI.

   https://console.cloud.google.com/kubernetes 

2. Create a Google filestore instance to store the shared folders for applications’ usage.

   https://console.cloud.google.com/filestore 

3. Note the **File share name** and **IP address** after creating filestore instance.

![File Share details](images/gke_file_share_details.png)

4. Connect with your GKE cluster.

   https://cloud.google.com/kubernetes-engine/docs/quickstart 

## Get Repo Info

```console
$ helm repo add rahul-subash https://rahul-subash.github.io/helm-chart
$ helm repo update
```

_See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation._

## Install Chart

```console
# Helm 3
$ helm install [RELEASE_NAME] rahul-subash/boldbi --set clusterType=gke,appBaseUrl=[Host URL],persistentVolume.gke.fileShareName=[File share name],persistentVolume.gke.fileShareIp=[IP address] [flags]
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