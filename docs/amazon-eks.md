# Bold BI on Amazon Elastic Kubernetes Service

## Deployment prerequisites

1. Create an Amazon EKS cluster and [node group](https://docs.aws.amazon.com/eks/latest/userguide/eks-compute.html) to deploy Bold BI.

   https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html 

2. Connect to your Amazon EKS cluster.

3. Deploy the EFS CSI Driver to your cluster and create an Amazon Elastic File System (EFS) volume to store the shared folders for applications’ usage by following the below link.

   https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html 

4. Note the **File system ID** after creating EFS file system.
![AWS EFS](images/aws-efs.png)

## Get Repo Info

```console
$ helm repo add rahul-subash https://rahul-subash.github.io/helm-chart
$ helm repo update
```

_See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation._

## Install Chart

```console
# Helm 3
$ helm install [RELEASE_NAME] rahul-subash/boldbi --set clusterType=eks,appBaseUrl=[Host URL],persistentVolume.eks.efsFileSystemId=[efs_file_system_id] [flags]
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
$ helm upgrade [RELEASE_NAME] rahul-subash/boldbi [flags]
```

_See [helm upgrade](https://helm.sh/docs/helm/helm_upgrade/) for command documentation._

Visit the chart's [CHANGELOG](./CHANGELOG.md) to view the chart's release history.
For migration between major version check [migration guide](#migration-guide).

## Application Startup

Configure the Bold BI On-Premise application startup to use the application. Please refer the following link for more details on configuring the application startup.
    
https://help.boldbi.com/embedded-bi/application-startup