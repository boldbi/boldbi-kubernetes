# Bold BI on Amazon Elastic Kubernetes Service
Please follow these steps to deploy Bold BI On-Premise in Amazon Elastic Kubernetes Service (Amazon EKS).

1. Download the following files for Bold BI deployment in Amazon EKS:

    * [pvclaim_eks.yaml](../deploy/pvclaim_eks.yaml)
    * [deployment.yaml](../deploy/deployment.yaml)
    * [hpa.yaml](../deploy/hpa.yaml)
    * [service.yaml](../deploy/service.yaml)
    * [ingress.yaml](../deploy/ingress.yaml)

2. Create a Kubernetes cluster in Amazon EKS to deploy the Bold BI On-Premise application.

   https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html 

3. Create an Amazon Elastic File System (EFS) volume to store the shared folders for applications’ usage.

   https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html 

4. Note the **File system ID** after creating EFS file system.
![AWS EFS](images/aws-efs.png)

5. Open **pvclaim_eks.yaml** file, downloaded in **Step 1**. Replace the **File system ID** noted in above step to the `<efs_file_system_id>` place in the file. You can also change the storage size in the YAML file. 

![PV Claim](images/eks_pvclaim.png)

6. Connect with your Amazon EKS cluster.

7. You can skip this step if your cluster already has a CNI (Container Network Interface) running. However, if your cluster does not have any CNI or if you face any CNI related issues when deploying, you can install the Calico CNI using the following command in your EKS cluster.
    
    https://docs.projectcalico.org/about/about-calico

```sh
kubectl apply -f https://docs.projectcalico.org/v3.11/manifests/calico.yaml
```

8. Deploy the EFS CSI Driver to manage the lifecycle of Amazon EFS file systems in kubernetes containers.

    https://github.com/kubernetes-sigs/aws-efs-csi-driver

```sh
kubectl apply -k "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.0"
```

9. Deploy the latest Nginx ingress controller to your cluster using the following command.

```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.41.2/deploy/static/provider/aws/deploy.yaml
```

10. Navigate to the folder where the deployment files were downloaded from **Step 1**.

11. If you have a DNS to map with the application, you can continue with the following steps, else skip to **Step 16**. 

12. Open the **ingress.yaml** file. Uncomment the host value and replace your DNS hostname with `example.com` and save the file.

13. If you have the SSL certificate for your DNS and need to configure the site with your SSL certificate, follow the below step or you can skip to **Step 16**.

14. Run the following command to create a TLS secret with your SSL certificate.

```sh
kubectl create secret tls boldbi-tls --key <key-path> --cert <certificate-path>
```

15. Now, uncomment the `tls` section and replace your DNS hostname with `example.com` in ingress spec and save the file.

![ingress DNS](images/ingress_yaml.png)

16. Run the following command for applying the Bold BI ingress to get the IP address of Nginx ingress,

```sh
kubectl apply -f ingress.yaml
```

17.	Now, run the following command to get the ingress IP address.

```sh
kubectl get ingress
```
Repeat the above command till you get the IP address in ADDRESS tab as shown in the following image.
![Ingress Address](images/ingress_address.png) 

18. If you face any issues related to webhook while applying the Bold BI ingress, you can run the following command to remove the webhook validation in Nginx ingress.

```sh
kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission
```

19.	Note the ingress IP address and map it with your DNS if you have added the DNS in **ingress.yaml** file. If you do not have the DNS and want to use the application, then you can use the ingress IP address.

20. Open the **deployment.yaml** file from the downloaded files in **Step 1**. Replace your DNS or ingress IP address in `<application_base_url>` place.
    
    Ex: `http://example.com`, `https://example.com`, `http://<ingress_ip_address>`

21. Read the optional client library license agreement from the following link.

    [Consent to deploy client libraries](../docs/consent-to-deploy-client-libraries.md)

22. Note the optional client libraries from the above link as comma separated names and replace it in `<comma_separated_library_names>` place. Save the file after the required values has been replaced.

![deployment.yaml](images/deployment_yaml.png) 

23.	Now, run the following commands one by one:

```sh
kubectl apply -f pvclaim_eks.yaml
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

24.	Wait for some time till the Bold BI On-Premise application deployed to your Amazon EKS cluster. 

25.	Use the following command to get the pods’ status.

```sh
kubectl get pods
```
![Pod status](images/pod_status.png) 

26. Wait till you see the applications in running state. Then use your DNS or ingress IP address you got from **Step 17** to access the application in the browser.

27.	Configure the Bold BI On-Premise application startup to use the application. Please refer the following link for more details on configuring the application startup.
    
    https://help.boldbi.com/embedded-bi/application-startup
