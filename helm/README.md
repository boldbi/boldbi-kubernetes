# Deploy Bold BI using Helm

This chart installs [Bold BI](https://www.boldbi.com/) on Kubernetes. You can create Kubernetes cluster on either cloud or on-premise infrastructure. Please follow the below documentation for Bold BI deployment in a specific cloud and on-premise environments.
    
## Deployment prerequisites

* [install helm](https://helm.sh/docs/intro/install/)
* [Create a cluster](docs/pre-requisites.md#create-a-cluster)
* [File Storage](docs/pre-requisites.md#file-storage)
* [Load Balancing](docs/pre-requisites.md#load-balancing)

## Get Repo Info

1. Add the Bold BI helm repository

```console
helm repo add boldbi https://boldbi.github.io/boldbi-kubernetes
helm repo update
```

2. View charts in repo

```console
helm search repo boldbi

NAME            CHART VERSION   APP VERSION     DESCRIPTION
boldbi/boldbi   4.2.68           4.2.68          Embed powerful analytics inside your apps and t...
```

_See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation._

## Install Chart

Just like any typical Helm chart, you'll need to craft a `values.yaml` file that would define/override any of the values exposed into the default `values.yaml`.

* For `GKE` please find the values.yaml file [here](custom-values/gke-values.yaml).
* For `EKS` please find the values.yaml file [here](custom-values/eks-values.yaml).
* For `AKS` please find the values.yaml file [here](custom-values/aks-values.yaml).
* For `OnPremise` please find the values.yaml file [here](custom-values/onpremise-values.yaml).

> **INFO:**
> * clusterProvider: The type of kubernetes cluster provider you are using.
> * appBaseUrl: Domain or IP address of the machine with http/https protocol. Follow the [SSL Termination](docs/configuration.md#ssl-termination) to configure SSL certificate for https protocol after deploying Bold BI in your cluster.
> * **Persistent Volume:** Configure the persistent volume for storing the Bold BI application data. To configure persistent volume for your cluster, refer to [Persistent volume configuration](docs/configuration.md#persistent-volume) for each cluster.

Currently we have provided support for `Nginx` and `Istio` as Load Balancers in Bold BI. The default Load Balancer is `Nginx`. Refer [here](docs/configuration.md#load-balancing) for more details.

Run the following command to delpoy Bold BI in your cluster.

```console
helm install [RELEASE_NAME] boldbi/boldbi -f my-values.yaml
```
Ex: `helm install boldbi boldbi/boldbi -f my-values.yaml`

Refer [here](docs/configuration.md) for advanced configuration including SSL termination, optional client libraries, etc.

_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._

## Upgrade Chart

helm upgrade support will be there after 4.2.68

## Uninstall Chart

```console
helm uninstall [RELEASE_NAME]
```
Ex: `helm uninstall boldbi`

This removes all the Kubernetes components associated with the chart and deletes the release.

_See [helm uninstall](https://helm.sh/docs/helm/helm_uninstall/) for command documentation._

## Application Startup

Configure the Bold BI On-Premise application startup to use the application. Please refer the following link for more details on configuring the application startup.
    
https://help.boldbi.com/embedded-bi/application-startup
