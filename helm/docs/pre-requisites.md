# Deployment Pre-requisites

## Create a cluster

* [Google Kubernetes Engine (GKE)](#gke-cluster)
* [Amazon Elastic Kubernetes Service (EKS)](#eks-cluster)
* [Azure Kubernetes Service (AKS)](#aks-cluster)
* [On-premise](#on-premise-cluster)

### GKE Cluster

1. Create a Kubernetes cluster in Google Cloud Platform (GCP) to deploy Bold BI.

   https://console.cloud.google.com/kubernetes 

2. Connect with your GKE cluster.

   https://cloud.google.com/kubernetes-engine/docs/quickstart

### EKS Cluster

1. Create an Amazon EKS cluster and [node group](https://docs.aws.amazon.com/eks/latest/userguide/eks-compute.html) to deploy Bold BI.

   https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html 

2. Connect to your Amazon EKS cluster.

### AKS Cluster

1. Create a Kubernetes cluster in Microsoft Azure Kubernetes Service (AKS) to deploy Bold BI.

2. Connect with your Microsoft AKS cluster.

### On-Premise Cluster

1. Create a Kubernetes onpremise cluster to deploy Bold BI.

2. Follow the instructions to [Create an On-Premise cluster](https://kubernetes.io/docs/setup/).


## File Storage

* [Google Kubernetes Engine (GKE)](#gke-file-storage)
* [Amazon Elastic Kubernetes Service (EKS)](#eks-file-storage)
* [Azure Kubernetes Service (AKS)](#aks-file-storage)
* [On-premise](#on-premise-file-storage)

### GKE File Storage

1. Create a Google filestore instance to store the shared folders for applications’ usage.

   https://console.cloud.google.com/filestore 

2. Note the **File share name** and **IP address** after creating filestore instance.

![File Share details](images/gke_file_share_details.png)

### EKS File Storage

1. Deploy the EFS CSI Driver to your cluster and create an Amazon Elastic File System (EFS) volume to store the shared folders for applications’ usage by following the below link.

   https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html 

2. Note the **File system ID** after creating EFS file system.

![AWS EFS](images/aws-efs.png)

### AKS File Storage

1. Create a File share instance in your storage account and note the File share name to store the shared folders for applications’ usage.

2. Encode the storage account name and storage key in base64 format.

### On-Premise File Storage

Create a folder in your machine to store the shared folders for applications’ usage.

Ex: `D://app/shared`

mention this location in install command as like below
	
Ex: `D://app/shared` -> `/run/desktop/mnt/host/d/app/shared`


## Load Balancing

Currently we have provided support for `Nginx` and `Istio` as Load Balancers in Bold BI. By default Nginx is used as reverse proxy for Bold BI.

### Ingress-Nginx

If you need to configure Bold BI with Ingress, [Install Nginx ingress controller](https://kubernetes.github.io/ingress-nginx/deploy/) in your cluster

If you have the SSL certificate for your DNS and need to configure the site with your SSL certificate, run the following command to create a TLS secret with your SSL certificate.

```console
kubectl create secret tls boldbi-tls -n boldbi --key <key-path> --cert <certificate-path>
```

### Istio Ingress Gateway

If you need to configure Bold BI with Istio, [Install Istio ingress gateway](https://istio.io/latest/docs/setup/install/) in your cluster.

> **INFO:**  Install istio ingress gateway in your cluster
* GKE cluster: https://cloud.google.com/istio/docs/istio-on-gke/installing

* EKS cluster: https://aws.amazon.com/blogs/opensource/getting-started-istio-eks/

* AKS cluster: https://docs.microsoft.com/en-us/azure/aks/servicemesh-istio-install 

* OnPremise cluster: https://istio.io/latest/docs/setup/platform-setup/docker/

If you have the SSL certificate for your DNS and need to configure the site with your SSL certificate, run the following command to create a TLS secret with your SSL certificate.

```console
kubectl create secret tls boldbi-tls -n istio-system --key <key-path> --cert <certificate-path>
```

To install Bold BI with Istio, run the helm install command with the following flag

```console
helm install [RELEASE_NAME] boldbi/boldbi --set loadBalancer.type=istio [flags]
```
