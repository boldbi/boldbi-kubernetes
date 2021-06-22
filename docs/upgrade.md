# Upgrading Bold BI to 4.1.36

Please follow the below steps to upgrade Bold BI to 4.1.36 from 3.4.12 in your Kubernetes cluster.

1.  Download the following files to upgrade Bold BI in AKS:

    * [deployment.yaml](https://raw.githubusercontent.com/boldbi/boldbi-kubernetes/v4.1.36_istio_gateway/deploy/deployment.yaml)
    * [destination_rule.yaml](https://raw.githubusercontent.com/boldbi/boldbi-kubernetes/v4.1.36_istio_gateway/deploy/destination_rule.yaml)

2.	Connect with your Microsoft AKS cluster.

3.	Open the **deployment.yaml** file from the downloaded files in **Step 1**. Replace `<application_base_url>` and `<comma_separated_library_names>` from previous deployment.

    ![deployment.yaml](images/deployment_yaml.png) 
    
4. If you need to use **Bing Map** widget feature, enter value for `widget_bing_map_enable` environment variable as `true` and API key in `widget_bing_map_api_key` value on **deployment.yaml** and save the file.

    ![Bing Map](images/bing_map_key.png) 

5. Run the following commands one by one:

```sh
kubectl apply -f deployment.yaml
```

```sh
kubectl apply -f destination_rule.yaml
```
