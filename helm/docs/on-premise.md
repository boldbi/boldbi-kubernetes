# Bold BI on On-Premise Kubernetes Cluster

## Deployment prerequisites

* [Google Kubernetes Engine (GKE)](#GKE)
* [Amazon Elastic Kubernetes Service (EKS)](#EKS)
* [Azure Kubernetes Service (AKS)](#AKS)
* [On-premise](#On-Premise)

## GKE

1. Create a Kubernetes cluster in Google Cloud Platform (GCP) to deploy Bold BI.

   https://console.cloud.google.com/kubernetes 

2. Create a Google filestore instance to store the shared folders for applications’ usage.

   https://console.cloud.google.com/filestore 

3. Note the **File share name** and **IP address** after creating filestore instance.

![File Share details](images/gke_file_share_details.png)

4. Connect with your GKE cluster.

   https://cloud.google.com/kubernetes-engine/docs/quickstart
   
![Persistent Volume GKE](images/persistent_vol_gke.png)

## EKS

1. Create an Amazon EKS cluster and [node group](https://docs.aws.amazon.com/eks/latest/userguide/eks-compute.html) to deploy Bold BI.

   https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html 

2. Connect to your Amazon EKS cluster.

3. Deploy the EFS CSI Driver to your cluster and create an Amazon Elastic File System (EFS) volume to store the shared folders for applications’ usage by following the below link.

   https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html 

4. Note the **File system ID** after creating EFS file system.
![AWS EFS](images/aws-efs.png)

![Persistent Volume EKS](images/persistent_vol_eks.png)

## AKS

1. Create a Kubernetes cluster in Microsoft Azure Kubernetes Service (AKS) to deploy Bold BI.

2. Create a File share instance in your storage account and note the File share name to store the shared folders for applications’ usage.

3. Encode the storage account name and storage key in base64 format.

4. Connect with your Microsoft AKS cluster.

![Persistent Volume AKS](images/persistent_vol_aks.png)

## On-Premise

Create a folder in your machine to store the shared folders for applications’ usage.

Ex: `D://app/shared`

mention this location in install command as like below
	
Ex: `D://app/shared` -> `/run/desktop/mnt/host/d/app/shared`

![Persistent Volume OnPremise](images/persistent_vol_onpremise.png)	

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

## Install and run

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