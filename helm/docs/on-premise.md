# Bold BI on On-Premise Kubernetes Cluster

## Deployment prerequisites

Create a folder in your machine to store the shared folders for applications’ usage.

Ex: `D://app/shared`

mention this location in install command as like below
	
Ex: `D://app/shared` -> `/run/desktop/mnt/host/d/app/shared`	

## Get Repo Info

```console
$ helm repo add boldbi https://boldbi.github.io/boldbi-kubernetes
$ helm repo update
```

_See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation._

## Install Chart

```console
# Helm 3
$ helm install [RELEASE_NAME] boldbi/boldbi --set clusterType=onpremise,appBaseUrl=[Host URL],persistentVolume.onpremise.hostPath=/run/desktop/mnt/host/[local_directory] [flags]
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
$ helm upgrade [RELEASE_NAME] boldbi/boldbi [flags]
```

_See [helm upgrade](https://helm.sh/docs/helm/helm_upgrade/) for command documentation._

Visit the chart's [CHANGELOG](./CHANGELOG.md) to view the chart's release history.
For migration between major version check [migration guide](#migration-guide).	

## Application Startup

Configure the Bold BI On-Premise application startup to use the application. Please refer the following link for more details on configuring the application startup.
    
https://help.boldbi.com/embedded-bi/application-startup