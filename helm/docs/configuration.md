# Configuration

See [Customizing the Chart Before Installing](https://helm.sh/docs/intro/using_helm/#customizing-the-chart-before-installing).
To see all configurable options with detailed comments, visit the chart's [values.yaml](../boldbi/values.yaml), or run these configuration commands:

```console
# Helm 3
helm show values boldbi/boldbi
```

## Client Libraries

Read the optional client library license agreement from the following link.

[Consent to deploy client libraries](../docs/consent-to-deploy-client-libraries.md)

Note the optional client libraries from the above link as comma separated names and replace it in `<comma_separated_library_names>` place.

```console
optionalLibs: <comma_separated_library_names>
```

## Persistent Volume

### Name

Persistent volumes were global resources. So if you already have Bold BI installed in your cluster, then the previous persistent volume name will conflict with current installation. Change this name to avoid conflicts with previous Bold BI persistent volumes.

By default the persistent volume name used in Bold BI is `boldbi-fileserver`. 

```console
persistentVolume:
  # persistent volumes were global resources. 
  # so if you already have Bold BI installed in your cluster, 
  # then the previous persistent volume name will conflict with current installation.
  # Change this name to avoid conflicts with previous Bold BI persistent volumes.
  name: boldbi-fileserver
```

### Capacity

Generally, a PV will have a specific storage capacity. This is set using the PV's capacity attribute. See the [Kubernetes Resource Model](https://git.k8s.io/community/contributors/design-proposals/scheduling/resources.md) to understand the units expected by capacity.

By default the persistent volume capacity used in Bold BI is `3Gi`. 

```console
persistentVolume:
  capacity: 3Gi
```

### Persistent volume configuration for each cluster

1. GKE

```console
clusterProvider: gke
    
persistentVolume:
  gke:
    fileShareName: <file_share_name>
    fileShareIp: <file_share_ip_address>
```

> **INFO:**  
* clusterProvider: The type of kubernetes cluster provider you are using.
* persistentVolume.gke.fileShareName: The `File share name` of your filestore instance.
* persistentVolume.gke.fileShareIp: The `IP address` of your filestore instance.

2. EKS

```console
clusterProvider: eks
    
persistentVolume:
  eks:
    efsFileSystemId: <efs_file_system_id>
```

> **INFO:**  
* clusterProvider: The type of kubernetes cluster provider you are using.
* persistentVolume.eks.efsFileSystemId: The `File system ID` of your EFS file system.

3. AKS

```console
clusterProvider: aks
    
persistentVolume:
  aks:
    fileShareName: <file_share_name>
    # base64 string
    azureStorageAccountName: <base64_azurestorageaccountname>
    # base64 string
    azureStorageAccountKey: <base64_azurestorageaccountkey>
```

> **INFO:**  
* clusterProvider: The type of kubernetes cluster provider you are using.
* persistentVolume.aks.fileShareName: The `File share name` of your File share instance.
* persistentVolume.aks.azureStorageAccountName: The `base64 encoded storage account name` of the File share instance in your storage account.
* persistentVolume.aks.azureStorageAccountKey: The `base64 encoded storage account key` of the File share instance in your storage account.

4. On-Premise

```console
clusterProvider: onpremise
    
persistentVolume:
  onpremise:
    hostPath: /run/desktop/mnt/host/<local_directory>
```

> **INFO:**  
* clusterProvider: The type of kubernetes cluster provider you are using.
* persistentVolume.onpremise.hostPath: The shared folder path in your host machine.


## Load Balancing

### Ingress-Nginx

By default Nginx is used as reverse proxy for Bold BI. To configure load balancing in Bold BI take a look at the below snipet. 

```console
loadBalancer:
  type: nginx
```

The default `ingressClassName` is `nginx`. Please refer [here](https://kubernetes.io/docs/concepts/services-networking/ingress/#deprecated-annotation) for more details.

```console
loadBalancer:
  # For Kubernetes >= 1.18 you should specify the ingress-controller via the field ingressClassName
  # See https://kubernetes.io/blog/2020/04/02/improvements-to-the-ingress-api-in-kubernetes-1.18/#specifying-the-class-of-an-ingress
  # ingressClassName: nginx
```

### Istio Ingress Gateway

If you need to configure Bold BI with Istio then you can change the value as `istio` in your configuration like below.

```console
loadBalancer:
  type: istio
```

### sticky session

You can change the affinityCookieExpiration time. The default value is 600s.

```console
loadBalancer:
  affinityCookieExpiration: 600
```

### SSL Termination

If you have the SSL certificate for your DNS and need to configure the site with your SSL certificate, just pass your DNS with `https` protocol to `appBaseUrl`, by doing this it will automatically enable SSL in both Ingress and Istio.

> **NOTE:**  You have to create the TLS Secret with name `boldbi-tls` or else change the secret name in your values.yaml

Run the following command to create a TLS secret with your SSL certificate.

```console
# Ingress
kubectl create secret tls boldbi-tls -n boldbi --key <key-path> --cert <certificate-path>

# Istio
kubectl create secret tls boldbi-tls -n istio-system --key <key-path> --cert <certificate-path>
```

### Map multiple domains

You can map mutiple domains in both Ingress Nginx and Istio like below. While mapping multiple domains you have to include the `appBaseUrl` in any of the matching host array.

FOr multiple domain scenerio the `singleHost` secret will not be considered, you have to mention your secret inside `multipleHost` section.

`Ingress Nginx`

```console
loadBalancer:
  singleHost:
    secretName: boldbi-tls

  multipleHost:
    hostArray:
      - hosts: 
          - cd1.abc.com
          - cd2.abc.com
        secretName: tls-secret1
      - hosts: 
          - cd1.xyz.com
          - cd2.xyz.com
        secretName: tls-secret2
```

`Istio Ingress Gateway`

```console
loadBalancer:
  singleHost:
    secretName: boldbi-tls

  multipleHost:
    hostArray:
      - hosts: 
          - cd1.abc.com
          - cd2.abc.com
        secretName: tls-secret
```

## Bing Map Widget

If you need to use **Bing Map** widget feature, enable this to `true` and API key value for `<widget_bing_map_api_key>`. By default this feature will be set to false.

```console
bingMapWidget:
  enabled: <true / false>
  apiKey: <widget_bing_map_api_key>
```
