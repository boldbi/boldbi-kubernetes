# Bold BI on Microsoft Azure Kubernetes Service

## Deployment prerequisites

1. Create a Kubernetes cluster in Microsoft Azure Kubernetes Service (AKS) to deploy Bold BI.

2. Create a File share instance in your storage account and note the File share name to store the shared folders for applications’ usage.

3. Encode the storage account name and storage key in base64 format.

4. Connect with your Microsoft AKS cluster.

## Running

1. Add the Superset helm repository

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

Just like any typical Helm chart, you'll need to craft a values.yaml file that would define/override any of the values exposed into the default values.yaml

_See [configuration](configuration.md) for more details._

### Install and run

```console
# Helm 3
helm upgrade --install --values my-values.yaml [RELEASE_NAME] boldbi/boldbi
```

_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._

## Uninstall Chart

```console
# Helm 3
helm uninstall [RELEASE_NAME]
```

This removes all the Kubernetes components associated with the chart and deletes the release.

_See [helm uninstall](https://helm.sh/docs/helm/helm_uninstall/) for command documentation._

## Upgrade Chart

```console
# Helm 3
helm upgrade [RELEASE_NAME] boldbi/boldbi [flags]
```

_See [helm upgrade](https://helm.sh/docs/helm/helm_upgrade/) for command documentation._

Visit the chart's [CHANGELOG](./CHANGELOG.md) to view the chart's release history.
For migration between major version check [migration guide](#migration-guide).

## Application Startup

Configure the Bold BI On-Premise application startup to use the application. Please refer the following link for more details on configuring the application startup.
    
https://help.boldbi.com/embedded-bi/application-startup