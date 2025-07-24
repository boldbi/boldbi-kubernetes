# Deployment Pre-requisites

## File Storage

* [Google Kubernetes Engine (GKE)](#gke-file-storage)
* [Amazon Elastic Kubernetes Service (EKS)](#eks-file-storage)
* [Azure Kubernetes Service (AKS)](#aks-file-storage)

### GKE File Storage

1. Create a Google filestore instance to store the shared folders for application usage.

   https://console.cloud.google.com/filestore 

2. Note the **File share name** and **IP address** after creating filestore instance.

![File Share details](images/gke_file_share_details.png)

### EKS File Storage

1. Deploy the EFS CSI Driver to your cluster and create an Amazon Elastic File System (EFS) volume to store the shared folders for application usage by following the below link.

   https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html 

2. Note the **File system ID** after creating EFS file system.

![AWS EFS](images/aws-efs.png)

### Oracle File System

1. Create a File System volume by following the link below to store the Bold BI application data. 

    [Creating a File System Mount Target and Export](https://docs.oracle.com/en-us/iaas/compute-cloud-at-customer/topics/file/creating-a-file-system-mount-target-and-export.htm)

2. Note the File System OCID, Mount Target IP, and Export Path.

![OKE Filesystem](images/oke_filesystem.png)

### AKS File Storage

#### SMB

1. Create a File share instance in your storage account and note the File share name to store the shared folders for application usage.

2. Encode the storage account name and storage key in `base64` format.

For encoding the values to base64 please run the following command in powershell

```console
[System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("<plain-text>"))
```

![File Share details](images/aks-file-storage.png)

#### NFS

For optimal persistence and performance, **it is highly recommended to configure an NFS file share from a Premium Storage Account**. NFS provides reliable, high-throughput storage, making it an ideal choice for Linux-based containers and stateful applications running on AKS.

##### Steps to Configure NFS File Share:

1. **Create an NFS File Share**

   * Navigate to your **Premium Storage Account** in Azure.
   * Create a **new NFS file share**.
   * Note down the **Storage Account Name** and **File Share Name**. These will be referenced in your Persistent Volume configuration.

     ![File Share details](images/Storage-account-nfs.png)

2. **Locate the Hostname**

   * Go to the **Properties** section of the NFS File Share.
   * Identify and note the **hostname**. This will be used for mounting the file share in Kubernetes Persistent Volumes.
   * Example Hostname Format: `premiumstorage1234.file.core.windows.net`.

   ![File Share details](images/nfs-hostname.png)

**NOTE:** The premium storage account of the NFS fileshare must be within the same subscription as the AKS cluster.

### ACK File Sotrage

1. Follow the documentation provided at [this link](https://www.alibabacloud.com/help/en/nas/latest/create-a-nas-file-system) to create a file system in Alibaba Cloud.

2. Once the file system is created, locate and click on the cube icon. This will allow you to view the mount target hostname. Take note of the mount target hostname, as you will need it for mounting the file system with our application.

   ![NAS-Mount-Target](images/Nas-mount-target.png)

## Create and connect a cluster

* [Google Kubernetes Engine (GKE)](#gke-cluster)
* [Amazon Elastic Kubernetes Service (EKS)](#eks-cluster)
* [Azure Kubernetes Service (AKS)](#aks-cluster)
* [Alibaba Cloud Kubernetes (ACK)](#ack-cluster)

### GKE Cluster

1. Create a Kubernetes cluster in Google Cloud Platform (GCP) to deploy Bold BI.

   https://console.cloud.google.com/kubernetes 

2. Connect with your GKE cluster.

   https://cloud.google.com/kubernetes-engine/docs/quickstart

### EKS Cluster

1. Create an Amazon EKS cluster and [node group](https://docs.aws.amazon.com/eks/latest/userguide/eks-compute.html) to deploy Bold BI.

   https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html 

2. Connect to your Amazon EKS cluster.
   https://aws.amazon.com/premiumsupport/knowledge-center/eks-cluster-connection/

### AKS Cluster

1. Create a Kubernetes cluster in Microsoft Azure Kubernetes Service (AKS) to deploy Bold BI.
   https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough-portal

2. Connect with your Microsoft AKS cluster.
   https://docs.microsoft.com/en-us/azure/aks/kubernetes-walkthrough-portal#connect-to-the-cluster

### ACK Cluster

1. Follow the documentation provided at the below link to create a Kubernetes cluster in Alibaba Cloud for deploying Bold BI.
   https://www.alibabacloud.com/help/en/container-service-for-kubernetes/latest/create-an-ack-managed-cluster

2. Refer to the instructions provided at the below link to connect to your Alibaba ACK cluster using kubectl.
   https://www.alibabacloud.com/help/en/container-service-for-kubernetes/latest/connect-to-ack-clusters-by-using-kubectl

## Load Balancing

Currently we have provided support for `Nginx` and `Istio` as Load Balancers in Bold BI. By default Nginx is used as reverse proxy for Bold BI.

### Install Ingress-nginx using kubectl

If you need to configure Bold BI with Ingress, [Install Nginx ingress controller](https://kubernetes.github.io/ingress-nginx/deploy/) in your cluster please refer below and run the command accordingly.

<br/>
<table>
    <tr>
      <td>
       <b>Name</b>
      </td>
      <td>
       <b>Description</b>
      </td>
    </tr>
    <tr>
      <td>
       GKE Cluster
      </td>
      <td>
       kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.3/deploy/static/provider/cloud/deploy.yaml
      </td>
    </tr>
    <tr>
      <td>
       EKS Cluster
      </td>
      <td>
       kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.3/deploy/static/provider/aws/deploy.yaml
      </td>
    </tr>
    <tr>
      <td>
       AKS Cluster
      </td>
      <td>
       kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.3/deploy/static/provider/cloud/deploy.yaml
      </td>
    </tr>
    <tr>
      <td>
       OnPremise
      </td>
      <td>
       kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.3/deploy/static/provider/cloud/deploy.yaml
      </td>
    </tr>
</table>
<br/>

After installed the nginx-ingress using kubectl, run the below command to set **allow-snippet-annotations** as true.

``` 
kubectl patch configmap ingress-nginx-controller -n ingress-nginx -p '{\"data\":{\"allow-snippet-annotations\":\"true\"}}' --type=strategic
```

### Install Ingress-nginx using helm
If you want to configure latest Ingress-Nginx using helm in your cluster, please use below commands.

Add the Ingress-Nginx helm repository.
```
helm repo add nginx-stable https://helm.nginx.com/stable
```
Run the following command to delpoy Ingress-Nginx in your cluster.
```
helm install ingress-nginx ingress-nginx/ingress-nginx --version 4.11.3 --namespace ingress-nginx --create-namespace --set controller.service.externalTrafficPolicy=Local --set controller.config.allow-snippet-annotations="true"
```
### Istio Ingress Gateway

If you need to configure Bold BI with Istio, [Install Istio ingress gateway](https://istio.io/latest/docs/setup/install/) in your cluster please refer to the corresponing reference links

<br/>
<table>
    <tr>
      <td>
       <b>Name</b>
      </td>
      <td>
       <b>Description</b>
      </td>
    </tr>
    <tr>
      <td>
       GKE Cluster
      </td>
      <td>
      https://cloud.google.com/istio/docs/istio-on-gke/installing
      </td>
    </tr>
    <tr>
      <td>
       EKS Cluster
      </td>
      <td>
       https://aws.amazon.com/blogs/opensource/getting-started-istio-eks/
      </td>
    </tr>
    <tr>
      <td>
       AKS Cluster
      </td>
      <td>
       https://docs.microsoft.com/en-us/azure/aks/servicemesh-istio-install
      </td>
    </tr>
    <tr>
      <td>
       OnPremise
      </td>
      <td>
       https://istio.io/latest/docs/setup/platform-setup/docker/
      </td>
    </tr>
</table>
<br/>

### Get Ingress IP

Run the following command to get the ingress IP address.

```console
# Nginx
kubectl get service/ingress-nginx-controller -n ingress-nginx

# Istio
kubectl get service/istio-ingressgateway -n istio-system
```

Note the ingress `EXTERNAL-IP` address and map it with your DNS. If you do not have the DNS and want to use the application, then you can use the ingress IP address.
