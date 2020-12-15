# Bold BI on On-Premise Kubernetes Cluster
Please follow the below steps to deploy Bold BI application in your On-Premise machine kubernetes cluster.

1. Download the following files for Bold BI deployment in On-Premise,

    * [pvclaim_onpremise.yaml](../deploy/pvclaim_onpremise.yaml)
    * [deployment.yaml](../deploy/deployment.yaml)
    * [hpa.yaml](../deploy/hpa.yaml)
    * [service.yaml](../deploy/service.yaml)
    * [ingress.yaml](../deploy/ingress.yaml)

2. Open **pvclaim_onpremise.yaml** file, downloaded in above step. Replace the directory path in your host machine to the `<local_directory>` place in the file. You can also change the storage size in the YAML file. Save the file once you replaced the file share name and file share IP address.

    Ex: D://app/shared -> /run/desktop/mnt/host/**d/app/shared**

![PV Claim](images/onpremise_pvclaim.png)

3. Deploy the latest Nginx ingress controller to your cluster using the following command,

```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.41.2/deploy/static/provider/cloud/deploy.yaml
```

4. Navigate to the folder where the deployment files were downloaded from **Step 1**.

5. Map your DNS in which you want to access the application to your machine IP address.

6. Open the **ingress.yaml** file. Uncomment the host value and replace your DNS hostname with `example.com` and save the file.

7. If you have the SSL certificate for your DNS and need to configure the site with your SSL certificate, run the following command to create a TLS secret with your SSL certificate,

```sh
kubectl create secret tls boldbi-tls --key <key-path> --cert <certificate-path>
```

8. Now uncomment the `tls` section and replace your DNS hostname with `example.com` in ingress spec and save the file.

![ingress DNS](images/ingress_yaml.png)

9. Open the **deployment.yaml** file from the downloaded files on **Step 1**. Replace your DNS in `<application_base_url>` place.
    
    Ex: `http://example.com`, `https://example.com`

10. Read the optional client library license agreement from the following link,
    [Consent to deploy client libraries](../docs/consent-to-deploy-client-libraries)

11. Note the optional client libraries from the above link as comma separated names and replace in `<comma_separated_library_names>` place. Save the file after the required values has been replaced.

![deployment.yaml](images/deployment_yaml.png) 

12.	Now run the following commands one by one,

```sh
kubectl apply -f pvclaim_onpremise.yaml
```

```sh
kubectl apply -f deployment.yaml
```

```sh
kubectl apply -f hpa.yaml
```

```sh
kubectl apply -f service.yaml
```

```sh
kubectl apply -f ingress.yaml
```

13.	Now wait for some time to deploy the Bold BI On-Premise application in your Google Kubernetes cluster. 

14.	Use the following command to get the pods’ status,

```sh
kubectl get pods
```
![Pod status](images/pod_status.png) 

15.	Wait till you see all applications were in running state. Some applications may go get error and go to CrashLoopBackoff state. But they will change to Running state after some time.

16.	After deployment wait for sometime to Horizontal Pod Autoscaler (HPA) gets the metrics from pods. Use the following command to get HPA status,

```sh
kubectl get hpa
```
    If you get **<unknown>/80%** instead of actual CPU and memory usage of pods, then you do not have any metrics server running inside your cluster. Use the following command to deploy metrics server in your cluster to enable the autoscaling feature by HPA.
    
```sh
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.3.7/components.yaml
```

17.	Use your DNS hostname to access the application in browser.

18.	Configure the Bold BI On-Premise application startup to use the application. Please refer the following link for more details on configuring the application startup,
    https://help.boldbi.com/embedded-bi/application-startup