# Deploy Bold BI using Helm

This helm chart installs [Bold BI](https://www.boldbi.com/) on Kubernetes. You can create Kubernetes cluster in cloud cluster providers(GKE,AKS and EKS). Please follow the below documentation for Bold BI deployment in a specific cloud environments.

## Deployment prerequisites

* [Install Helm](https://helm.sh/docs/intro/install/) to deploy Bold BI using Helm.
* [File Storage](../docs/pre-requisites.md#file-storage)
* [Create and connect a cluster](../docs/pre-requisites.md#create-a-cluster)
* [Load Balancing](../docs/pre-requisites.md#load-balancing)

**Note:** Note the [Ingress IP address](docs/pre-requisites.md#get-ingress-ip) and map it with a DNS to crafting values.yaml when installing Bold BI with helm chart.

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
boldbi/boldbi   5.3.83           5.3.83         Embed powerful analytics inside your apps and t...
```

_See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation._

3. 
