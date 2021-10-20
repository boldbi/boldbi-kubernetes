# Deploy Bold BI using Helm

This chart installs [Bold BI](https://www.boldbi.com/) on Kubernetes. You can create Kubernetes cluster on either cloud or on-premise infrastructure. Please follow the below documentation for Bold BI deployment in a specific cloud and on-premise environments.
    
## Deployment prerequisites

* [Install Helm](https://helm.sh/docs/intro/install/) to deploy Bold BI using Helm.
* [File Storage](docs/pre-requisites.md#file-storage)
* [Create and connect a cluster](docs/pre-requisites.md#create-a-cluster)
* [Load Balancing](docs/pre-requisites.md#load-balancing)

**Note:** Note the [Ingress IP address](docs/pre-requisites.md#get-ingress-ip) to use it while crafting values.yaml when installing Bold BI with helm chart.

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

For Helm chart, you'll need to craft a `values.yaml`.

* For `GKE` please download the values.yaml file [here](https://raw.githubusercontent.com/boldbi/boldbi-kubernetes/v4.2.68/helm/custom-values/gke-values.yaml).
* For `EKS` please download the values.yaml file [here](https://raw.githubusercontent.com/boldbi/boldbi-kubernetes/v4.2.68/helm/custom-values/eks-values.yaml).
* For `AKS` please download the values.yaml file [here](https://raw.githubusercontent.com/boldbi/boldbi-kubernetes/v4.2.68/helm/custom-values/aks-values.yaml).
* For `OnPremise` please download the values.yaml file [here](https://raw.githubusercontent.com/boldbi/boldbi-kubernetes/v4.2.68/helm/custom-values/onpremise-values.yaml).

<br/>

<table>
    <tr>
      <td>
       Name
      </td>
      <td>
       Description
      </td>
    </tr>
    <tr>
      <td>
       namespace
      </td>
      <td>
       The namespace in which the Bold BI resources will be dpleoyed in the kubernetes cluster.<br/>
       The default namespace is <i>bold-services</i>
      </td>
    </tr>
    <tr>
      <td>
       appBaseUrl *
      </td>
      <td>
       Domain or <a href='docs/pre-requisites.md#get-ingress-ip'>Ingress IP address</a> with http/https protocol. Follow the <a href='docs/configuration.md#ssl-termination'>SSL Termination</a> to configure SSL certificate for https protocol after deploying Bold BI in your cluster.
      </td>
    </tr>
    <tr>
      <td>
       optionalLibs
      </td>
      <td>
       These are the client libraries used in Bold BI by default.<br/>
       '<i>phantomjs,mongodb,mysql,influxdb,snowflake,oracle,npgsql</i>'<br/>
       Please refer to <a href='docs/configuration.md#client-libraries'>Optional Client Libraries</a> section to know more.
      </td>
    </tr>
    <tr>
      <td>
       clusterProvider
      </td>
      <td>
       The type of kubernetes cluster provider you are using.<br/>
       The recommended values are '<i>gke,eks,aks and onpremise</i>'
      </td>
    </tr>
    <tr>
      <td>
       persistentVolume *
      </td>
      <td>
       Please refer to <a href='docs/configuration.md#persistent-volume'>this</a> section to know more on how to set Persistant Volumes for Bold BI.
      </td>
    </tr>
    <tr>
      <td>
       loadBalancer
      </td>
      <td>
       Currently we have provided support for Nginx and Istio as Load Balancers in Bold BI. Please refer to <a href='docs/configuration.md#load-balancing'>this</a> section for configuring Load balancer for Bold BI.
      </td>
    </tr>
    <tr>
      <td>
       autoscaling
      </td>
      <td>
       By default autoscaling is enabled in Bold BI. Please refer to <a href='docs/configuration.md#auto-scaling'>this</a> section to configure autoscaling in Bold BI.
      </td>
    </tr>
    <tr>
      <td>
       bingMapWidget
      </td>
      <td>
       Please refer to <a href='docs/configuration.md#bing-map-widget'>this</a> section to configure Bing Map Widget in Bold BI.
      </td>
    </tr>
</table>
<br/>

**Note:** Items marked with `*` are mandatory fields in values.yaml

Run the following command to delpoy Bold BI in your cluster.

```console
helm install [RELEASE_NAME] boldbi/boldbi -f [Crafted values.yaml file]
```
Ex:  `helm install boldbi boldbi/boldbi -f my-values.yaml`

Refer [here](docs/configuration.md) for advanced configuration including SSL termination, optional client libraries, etc.

_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._

## Upgrade

Helm upgrade support will be there after 4.2.68.

### Apply changes in Bold BI release

Run the following command to apply changes in your Bold BI release.

```console
helm upgrade [RELEASE_NAME] boldbi/boldbi -f [Crafted values.yaml file]
```

Ex:  `helm upgrade boldbi boldbi/boldbi -f my-values.yaml`

## Uninstall Chart

```console
helm uninstall [RELEASE_NAME]
```
Ex:  `helm uninstall boldbi`

This removes all the Kubernetes components associated with the chart and deletes the release.

_See [helm uninstall](https://helm.sh/docs/helm/helm_uninstall/) for command documentation._

## Application Startup

Configure the Bold BI On-Premise application startup to use the application. Please refer the following link for more details on configuring the application startup.
    
https://help.boldbi.com/embedded-bi/application-startup
