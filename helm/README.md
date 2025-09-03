# Deploy Bold BI using Helm

This Helm chart installs [Bold BI](https://www.boldbi.com/) on a Kubernetes cluster. You can create a cluster on any of the major cloud providers such as GKE, AKS, EKS, OKE, and ACK. Follow the documentation below for deployment instructions specific to each environment.

## Deployment prerequisites

* [Install Helm](https://helm.sh/docs/intro/install/) to deploy Bold BI using Helm.
* [Install Kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl)
* [File Storage](docs/pre-requisites.md#file-storage)
* [Create and connect a cluster](docs/pre-requisites.md#create-and-connect-a-cluster)
* [Load Balancing](docs/pre-requisites.md#load-balancing)

> **Note:** Note the [Ingress IP address](docs/pre-requisites.md#get-ingress-ip) and map it with a DNS to crafting values.yaml when installing Bold BI with helm chart.

## Get Repo Info

1. **Add the Bold BI Helm repository:**

```bash
helm repo add boldbi https://boldbi.github.io/boldbi-kubernetes
helm repo update
```

2. **View available charts:**

```bash
helm search repo boldbi
```

**Example output:**

| NAME          | CHART VERSION | APP VERSION | DESCRIPTION                                      |
| ------------- | ------------- | ----------- | ------------------------------------------------ |
| boldbi/boldbi | 13.1.10       | 13.1.10     | Embed powerful analytics inside your apps and t… |

_See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation._

## Deploy Bold BI

1. **Create a namespace:**

```bash
kubectl create namespace [namespace-name]
```

2. **Install the Bold BI:**

```bash
helm install [RELEASE_NAME] boldbi/boldbi -n [namespace-name] --set appBaseUrl="https://your-application-domain-name" --set clusterProvider="aks" --set persistentVolume.aks.nfs.fileShareName="your-storageaccount-name/your-fileshare-name" --set persistentVolume.aks.nfs.hostName="your-storageaccount-name.file.core.windows.net"
```

**Example:**

```bash
helm install boldbi boldbi/boldbi -n bold-services --set appBaseUrl="https://boldbi.example.com" --set clusterProvider="aks" --set persistentVolume.aks.nfs.fileShareName="premiumstorage1234/boldbi" --set persistentVolume.aks.nfs.hostName="premiumstorage1234.file.core.windows.net"
```

_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._

## Upgrade

- Run the following command to get the latest version of Bold BI helm chart.

  ```console
  helm repo update
  ```

- Create a new YAML file or update the existing one with changes such as a new image tag, environment variables, and other configuration details. Uncomment the lines by removing the # symbols and update the image tag as shown below. While upgrading, use the same YAML file that was used during installation.
  
  [boldbi/values.yaml](https://raw.githubusercontent.com/boldbi/boldbi-kubernetes/main/helm/boldbi/values.yaml)

  ```console
     image:
       repo: us-docker.pkg.dev/boldbi-294612/boldbi
       # Overrides the image tag whose default is the chart appVersion.
       tag: 12.1.5
       pullPolicy: IfNotPresent
     imagePullSecrets: []
  ```

- Run the below command to apply changes in your Bold BI release or upgrading Bold BI to latest version.

  ```console
  helm upgrade [RELEASE_NAME] boldbi/boldbi -f [Crafted values.yaml file] -n [namespace-name]
  ```

  Ex:  `helm upgrade boldbi boldbi/boldbi -f my-values.yaml -n bold-services`

## Uninstall Chart

```console
helm uninstall [RELEASE_NAME] -n [namespace-name]
```
Ex:  `helm uninstall boldbi -n bold-services`

This removes all the Kubernetes components associated with the chart and deletes the release.

_See [helm uninstall](https://helm.sh/docs/helm/helm_uninstall/) for command documentation._

## Application Startup

Configure the Bold BI On-Premise application startup to use the application. Please refer the following link for more details on configuring the application startup.
    
https://help.boldbi.com/embedded-bi/application-startup
