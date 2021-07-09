# Bold BI on Kubernetes Cluster

With [Bold BI](https://www.boldbi.com/) embed powerful analytics inside your apps and turn your customers into success stories with built-in intelligence features.

This chart installs Bold BI on Kubernetes. You can create Kubernetes cluster on either cloud or on-premise infrastructure. The following links explain Bold BI Kubernetes deployment in a specific cloud and on-premise environments.
    
## Deployment prerequisites

* [Google Kubernetes Engine (GKE)](#GKE)
* [Amazon Elastic Kubernetes Service (EKS)](#EKS)
* [Azure Kubernetes Service (AKS)](#AKS)
* [On-premise](#On-Premise)

### GKE

1. Create a Kubernetes cluster in Google Cloud Platform (GCP) to deploy Bold BI.

   https://console.cloud.google.com/kubernetes 

2. Create a Google filestore instance to store the shared folders for applications’ usage.

   https://console.cloud.google.com/filestore 

3. Note the **File share name** and **IP address** after creating filestore instance.

![File Share details](docs/images/gke_file_share_details.png)

4. Connect with your GKE cluster.

   https://cloud.google.com/kubernetes-engine/docs/quickstart
   
Just like any typical Helm chart, you'll need to craft a values.yaml file that would define/override any of the values exposed into the default values.yaml

_See [configuration](docs/configuration.md) for more details._

Replace your DNS or IP address in the `<app_base_url>`.

Ex: `http://example.com`, `https://example.com`, `http://<ip_address>`

```console
appBaseUrl: <app_base_url>
clusterProvider: gke
    
persistentVolume:
  gke:
    fileShareName: <file_share_name>
    fileShareIp: <file_share_ip_address>
```

### EKS

1. Create an Amazon EKS cluster and [node group](https://docs.aws.amazon.com/eks/latest/userguide/eks-compute.html) to deploy Bold BI.

   https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html 

2. Connect to your Amazon EKS cluster.

3. Deploy the EFS CSI Driver to your cluster and create an Amazon Elastic File System (EFS) volume to store the shared folders for applications’ usage by following the below link.

   https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html 

4. Note the **File system ID** after creating EFS file system.

![AWS EFS](docs/images/aws-efs.png)

Just like any typical Helm chart, you'll need to craft a values.yaml file that would define/override any of the values exposed into the default values.yaml

_See [configuration](docs/configuration.md) for more details._

Replace your DNS or IP address in the `<app_base_url>`.

Ex: `http://example.com`, `https://example.com`, `http://<ip_address>`

```console
appBaseUrl: <app_base_url>
clusterProvider: eks
    
persistentVolume:
  eks:
    efsFileSystemId: <efs_file_system_id>
```

### AKS

1. Create a Kubernetes cluster in Microsoft Azure Kubernetes Service (AKS) to deploy Bold BI.

2. Create a File share instance in your storage account and note the File share name to store the shared folders for applications’ usage.

3. Encode the storage account name and storage key in base64 format.

4. Connect with your Microsoft AKS cluster.

Just like any typical Helm chart, you'll need to craft a values.yaml file that would define/override any of the values exposed into the default values.yaml

_See [configuration](docs/configuration.md) for more details._

Replace your DNS or IP address in the `<app_base_url>`.

Ex: `http://example.com`, `https://example.com`, `http://<ip_address>`

```console
appBaseUrl: <app_base_url>
clusterProvider: aks
    
persistentVolume:
  aks:
    fileShareName: <file_share_name>
    # base64 string
    azureStorageAccountName: <base64_azurestorageaccountname>
    # base64 string
    azureStorageAccountKey: <base64_azurestorageaccountkey>
```

### On-Premise

Create a folder in your machine to store the shared folders for applications’ usage.

Ex: `D://app/shared`

mention this location in install command as like below
	
Ex: `D://app/shared` -> `/run/desktop/mnt/host/d/app/shared`

Just like any typical Helm chart, you'll need to craft a values.yaml file that would define/override any of the values exposed into the default values.yaml

_See [configuration](docs/configuration.md) for more details._

Replace your DNS or IP address in the `<app_base_url>`.

Ex: `http://example.com`, `https://example.com`, `http://<ip_address>`

```console
appBaseUrl: <app_base_url>
clusterProvider: onpremise
    
persistentVolume:
  onpremise:
    hostPath: /run/desktop/mnt/host/<local_directory>
```

### Proxying

Currently we have provided support for Nginx and Istio. By default Nginx is used as reverse proxy for Bold BI. If you are using istio then you can change the value as `istio` in your values.yaml

Deploy the latest Nginx ingress controller to your cluster using the following command.

```console
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.41.2/deploy/static/provider/cloud/deploy.yaml
```

If you need to configure Bold BI with Istio, [install istio ingress gateway](https://istio.io/latest/docs/setup/install/) in your cluster.

```console
# Install istio ingress gateway in your GKE cluster
https://cloud.google.com/istio/docs/istio-on-gke/installing

# Install istio ingress gateway in your EKS cluster
https://aws.amazon.com/blogs/opensource/getting-started-istio-eks/

# Install istio ingress gateway in your AKS cluster
https://docs.microsoft.com/en-us/azure/aks/servicemesh-istio-install
```

If you have the SSL certificate for your DNS and need to configure the site with your SSL certificate, run the following command to create a TLS secret with your SSL certificate.

```console
# Secret for ingress-nginx
kubectl create secret tls boldbi-tls -n boldbi --key <key-path> --cert <certificate-path>

# Secret for istio
kubectl create secret tls boldbi-tls -n istio-system --key <key-path> --cert <certificate-path>
```

Change the values accordingly in your own vaues.yaml

```console
loadBalancer:
  type: nginx
  affinityCookieExpiration: 600
  # For Kubernetes >= 1.18 you should specify the ingress-controller via the field ingressClassName
  # See https://kubernetes.io/blog/2020/04/02/improvements-to-the-ingress-api-in-kubernetes-1.18/#specifying-the-class-of-an-ingress
  # ingressClassName: nginx
  secretName: boldbi-tls
  # tls:
	# hostArray:
	  # - hosts: 
		  # - kubernetes.docker.internal
		  # - example.com
		# secretName: boldbi-tls
```

You can map multiple domains in ingress as like below.

```console
loadBalancer:
  type: nginx
  affinityCookieExpiration: 600
  # For Kubernetes >= 1.18 you should specify the ingress-controller via the field ingressClassName
  # See https://kubernetes.io/blog/2020/04/02/improvements-to-the-ingress-api-in-kubernetes-1.18/#specifying-the-class-of-an-ingress
  # ingressClassName: nginx
  secretName: boldbi-tls
   tls:
	 hostArray:
	   - hosts: 
		   - k8s-yokogawa-cd1.boldbi.com
		   - k8s-yokogawa-cd2.boldbi.com
		   - k8s-yokogawa-cd3.boldbi.com
		   - k8s-yokogawa-cd4.boldbi.com
		 secretName: boldbi-tls
```

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
# Helm 3
helm install [RELEASE_NAME] boldbi/boldbi -f my-values.yaml [flags]
```

_See [configuration](docs/configuration.md) for more details._

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

## Application Startup

Configure the Bold BI On-Premise application startup to use the application. Please refer the following link for more details on configuring the application startup.
    
https://help.boldbi.com/embedded-bi/application-startup