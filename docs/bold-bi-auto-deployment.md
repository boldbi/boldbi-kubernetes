# Bold BI auto deployment using kubectl on Kubernetes Service

This section helps you to deploy Bold BI](https://www.boldbi.com/) in Kubernetes without manually activating licensing and configuring startup from the browser. This also helps us to customize the branding using environment variables.

## Deployment Methods

There are two ways to deploy Bold BI on the Kubernetes cluster. Please refer to the following documents for Bold BI deployment.

* [Deploy Bold BI using kubectl](bold-bi-auto-deployment.md#deploy-bold-bi-using-kubectl)
* [Deploy Bold BI using Helm](#)
   

## Deploy Bold BI using kubectl

The below steps helps you do deploy Bold BI using kubectl in a kubernetes cluster.You can create Kubernetes cluster on cloud cluster providers(GKE,AKS and EKS). After completing cluster creation, connect to it and you can download the configuration files [here](../deploy/auto-deployment.zip). This directory includes configuration YAML files, which contains all the configuration settings needed to deploy Bold BI on Kubernetes cluster.

## Deployment prerequisites

The following requirements are necessary to deploy the Bold BI solution using kubectl. 

* [Install Kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) to deploy Bold BI using kubectl.
* [File Storage](pre-requisites.md#file-storage)
* [Create and connect a cluster](pre-requisites.md#create-a-cluster)
* Load Balancing- [Nginx](https://kubernetes.github.io/ingress-nginx/deploy/)


## Steps for Bold BI auto deployment using kubectl.

The following links explain Bold BI Kubernetes deployment in a specific cloud environments.

    * [Azure Kubernetes Service(AKS)](persistent-volumes.md#azure-kubernetes-service)
    * [Amazon Elastic Kubernetes Service(EKS)](persistent-volumes.md#amazon-elastic-kubernetes-service)
    * [Google Kubernetes Engine (GKE)](persistent-volumes.md#google-kubernetes-engine)
       
### Bold BI on Microsoft Azure Kubernetes Service

1. Download the deployment file from [here](https://raw.githubusercontent.com/boldbi/boldbi-kubernetes/UMP-22952-Autodeployment-documentation/deploy/auto-deployment/deploy_aks.yaml) to deloy Bold BI on AKS.

2. Navigate to the folder where the deployment files were downloaded from **Step 1**.

3. Create a File share instance in your storage account and note the File share name to store the shared folders for application usage.

4. Encode the storage account name and storage key in base64 format.
  
   For encoding the values to base64 please run the following command in powershell

    ```console
    [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes("<plain-text>"))
    ```

   ![File Share details](images/deploy/aks/aks-file-storage.png)

5. Open **deploy_aks.yaml** file, downloaded in **Step 1**. Replace the **base64 encoded storage account name**, **base64 encoded storage account key**, and **File share name** which are noted in above steps to `<base64_azurestorageaccountname>`, `<base64_azurestorageaccountkey>`, and `<file_share_name>` places in the file respectively. You can also change the storage size in the YAML file.

    ![PV Claim](images/deploy/aks/pv_claim.png)

6. After connecting with your cluster, deploy the latest Nginx ingress controller to your cluster using the following command.

   ```sh
   kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/cloud/deploy.yaml
   ```

7. Enter the variable information needed for complete the auto deployment in <b>deploy_aks.yaml</b> file as shown below.

    * Enter the Bold BI licence key, user and database server details.
        
        ![Licence-and-User-Details](images/deploy/aks/licence-and-user-details.png)

        ## Environment variables details for configuring `Application Startup` in backend

        | Name                          |Required| Description   | 
        | -------------                 |----------| ------------- |
        |`BOLD_SERVICES_UNLOCK_KEY`|Yes|License key of Bold BI|
        |`BOLD_SERVICES_DB_TYPE`|Yes|Type of database server can be used for configuring the Bold BI.<br/><br />The following DB types are accepted:<br />1. mssql –           Microsoft SQL Server/Azure SQL Database<br />2. postgresql – PostgreSQL Server<br />3. mysql – MySQL/MariaDB Server|
        |`BOLD_SERVICES_DB_HOST`|Yes|Name of the Database Server|
        |`BOLD_SERVICES_DB_PORT`|No|The system will use the following default port numbers based on the database server type.<br />PostgrSQL – 5234<br />MySQL -3306<br         /><br />Please specify the port number for your database server if it is configured on a different port.<br /><br />For MS SQL Server, this parameter is not           necessary.|
        |`BOLD_SERVICES_DB_USER`|Yes|Username for the database server<br /><br />Please refer to [this documentation](https://help.boldbi.com/embedded-bi/faq/what-are-         the-database-permissions-required-to-set-up-bold-bi-embedded/) for information on the user's permissions.|
        |`BOLD_SERVICES_DB_PASSWORD`|Yes|The database user's password|
        |`BOLD_SERVICES_DB_NAME`|No|If the database name is not specified, the system will create a new database called bold services.<br /><br />If you specify a             database name, it should already exist on the server.|
        |`BOLD_SERVICES_POSTGRESQL_MAINTENANCE_DB`|No|For PostgreSQL DB Servers, this is an optional parameter.<br />The system will use the database name `postgres`           by default.<br />If your database server uses a different default database, please provide it here.|
        |`BOLD_SERVICES_DB_ADDITIONAL_PARAMETERS`|No|If your database server requires additional connection string parameters, include them here.<br /><br />Connection         string parameters can be found in the official document.<br />My SQL: https://dev.mysql.com/doc/connector-net/en/connector-net-8-0-connection-options.html<br           />PostgreSQL: https://www.npgsql.org/doc/connection-string-parameters.html<br />MS SQL: https://docs.microsoft.com/en-                       us/dotnet/api/system.data.sqlclient.sqlconnection.connectionstring<br /><br /><b>Note:</b> A semicolon(;) should be used to separate multiple parameters.|
        |`BOLD_SERVICES_USER_EMAIL`|Yes|It should be a valid email.|
        |`BOLD_SERVICES_USER_PASSWORD`|Yes|It should meet our password requirements.|

        <details>
          <summary>
            Example for above environment variables: 
          </summary>

          apiVersion: v1
          kind: Secret
          metadata:  
            name: bold-license-key
            namespace: bold-services
          type: Opaque
          stringData:
            BOLD_SERVICES_UNLOCK_KEY: "@332e332e30fgfTa4NmxTdRataMFgre/GC5AyCj+BHVoCO4ax6M61s=eyJFbWFpbCI6InN1YmJpcmFtYW5peWFuLnRAc3luY2Z1c2lvbi5jb20iLCJQcm9kdWN0cyI6"
          ---
          apiVersion: v1
          kind: Secret
          metadata:  
            name: bold-user-secret
            namespace: bold-services
          type: Opaque
          stringData:
            # It should be a valid email.
            BOLD_SERVICES_USER_EMAIL: "admin@boldbi.com"

            # It should meet our password requirements.
            BOLD_SERVICES_USER_PASSWORD: "Admin@123"
          ---
          apiVersion: v1
          kind: Secret
          metadata:  
            name: bold-db-secret
            namespace: bold-services
          type: Opaque
          stringData:
            # Type of database server can be used for configuring the Bold BI. Eg: mssql, mysql and postgresql
            BOLD_SERVICES_DB_TYPE: "postgresql"

            # Name of the Database Server
            BOLD_SERVICES_DB_HOST: "localhost"

            # The system will use the following default port numbers based on the database server type.
            # PostgrSQL – 5432 and MySQL -3306
            # Please specify the port number for your database server if it is configured on a different port.
            # For MS SQL Server, this parameter is not necessary.
            BOLD_SERVICES_DB_PORT: "5432"

            # Username for the database server
            # Please refer to this documentation for information on the user's permissions.
            # https://help.boldbi.com/embedded-bi/faq/what-are-the-database-permissions-required-to-set-up-bold-bi-embedded/
            BOLD_SERVICES_DB_USER: "boldbi@boldbi-docker"

            # The database user's password
            BOLD_SERVICES_DB_PASSWORD: "F8o:z$jasoKkel"

            # If the database name is not specified, the system will create a new database called bold services.
            # If you specify a database name, it should already exist on the server.
            BOLD_SERVICES_DB_NAME: ""

            # For PostgreSQL DB Servers, this is an optional parameter.
            # The system will use the database name postgres by default.
            # If your database server uses a different default database, please provide it here.
            BOLD_SERVICES_POSTGRESQL_MAINTENANCE_DB: "postgres"

            # If your database server requires additional connection string parameters, include them here
            # Connection string parameters can be found in the official document.
            # My SQL: https://dev.mysql.com/doc/connector-net/en/connector-net-8-0-connection-options.html
            # PostgreSQL: https://www.npgsql.org/doc/connection-string-parameters.html
            # MS SQL: https://docs.microsoft.com/en-us/dotnet/api/system.data.sqlclient.sqlconnection.connectionstring
            # Note: A semicolon(;) should be used to separate multiple parameters.
            BOLD_SERVICES_DB_ADDITIONAL_PARAMETERS: ""
          ---
        </details>

    *  If you want to use custom values for branding enter the branding image and site identifier variable details.otherwise Bold BI will take the default values.
        
       ![Branding-Details](images/deploy/aks/branding-details.png)
  
        ## Environment variables for configuring `Branding` in backend

        The following environment variables are optional. If they are not provided, Bold BI will use the default configured values.

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
               BOLD_SERVICES_BRANDING_MAIN_LOGO
              </td>
              <td>   
               This is the header logo for the application, and the preferred image size is 40 x 40 pixels.
              </td>
            </tr>
            <tr>
              <td>
               BOLD_SERVICES_BRANDING_LOGIN_LOGO
              </td>
              <td>     
               This is the login logo for the application, and the preferred image size is 200 x 40 pixels.
              </td>
            </tr>
            <tr>
              <td>
               BOLD_SERVICES_BRANDING_EMAIL_LOGO
              </td>
              <td>     
               This is an email logo, and the preferred image size is 200 x 40 pixels.
              </td>
            </tr>
            <tr>
              <td>
               BOLD_SERVICES_BRANDING_FAVICON
              </td>
              <td>     
               This is a favicon, and the preferred image size is 40 x 40 pixels. 
              </td>
            </tr>
            <tr>
              <td>
               BOLD_SERVICES_BRANDING_FOOTER_LOGO
              </td>
              <td>     
               This is powered by the logo, and the preferred size is 100 x 25 pixels.
               <br />
               <br />
               <b>Note:</b><br/>• All branding variables are accepted as URL.<br/>• <b>Ex:</b> https://example.com/loginlogo.jpg.<br/>• <b>Image type:</b> png, svg, jpg,   jpeg.<br/>• If you want to use custom branding, provide the value for all branding variables. If all variable values are given, the application will use the branding images, otherwise, it will take the default logos. 
              </td>
            </tr>
            <tr>
              <td>
               BOLD_SERVICES_SITE_NAME
              </td>
              <td>
              This is organization name.     
              <br />
               If the value is not given, the site will be deployed using the default name.
              </td>
            </tr>
            <tr>
              <td>
               BOLD_SERVICES_SITE_IDENTIFIER
              </td>
              <td>     
               This is site identifier, and it will be the part of the application URL.
              <br />
              If the value is not given, the site will be deployed using the default value.
              </td>
            </tr>
        </table>
        <br/>
        <details>
          <summary>
            <span style="color:blue"> Example for above environment variables:</span>  
          </summary>

            apiVersion: v1
            kind: ConfigMap
            metadata:
              name: branding-config
              namespace: bold-services
            # All the branding images variables are accepted as URL.
            # Image type: png, svg, jpg, jpeg
            # Ex: https://example.com/loginlogo.jpg
            data:
              # This is the header logo for the application, and the preferred image size is 40 x 40 pixels.
              <span style="color:yellow">BOLD_SERVICES_BRANDING_MAIN_LOGO: "https://i.postimg.cc/FRyqDKPT/branding-header-logo.png"</span>
              
              # This is the login logo for the application, and the preferred image size is 200 x 40 pixels.
              BOLD_SERVICES_BRANDING_LOGIN_LOGO: "https://i.postimg.cc/FRyqDKPT/branding-header-logo.png"
              
              # This is an email logo, and the preferred image size is 200 x 40 pixels.
              BOLD_SERVICES_BRANDING_EMAIL_LOGO: "https://i.postimg.cc/FRyqDKPT/branding-header-logo.png"
              
              # This is a favicon, and the preferred image size is 40 x 40 pixels.
              BOLD_SERVICES_BRANDING_FAVICON: "https://i.postimg.cc/FRyqDKPT/branding-header-logo.png "
              
              # This is powered by the logo, and the preferred size is 100 x 25 pixels.
              BOLD_SERVICES_BRANDING_FOOTER_LOGO: "https://i.postimg.cc/FRyqDKPT/branding-header-logo.png "
              
              # This is organization name.
              BOLD_SERVICES_SITE_NAME: "Autodeployment"
              
              # This is site identifier, and it will be the part of the application URL.
              BOLD_SERVICES_SITE_IDENTIFIER: "branding"

              # Note: If you want to use the custom branding, provide the value for all branding variables 
              # If all variable values are given, application will use the branding images,
              # otherwise it will take the default logos.
            ---     
        </details>

           
    * If you need to use **Bing Map** widget feature, enter value for `widget_bing_map_enable` environment variable as `true` and API key value for               `widget_bing_map_api_key`.
       
       ![Enable-Bingmap](images/deploy/aks/bingmap_enable.png)

6. If you have a DNS to map with the application, then you can continue with the following steps, else skip to **Step 11**. 

7. Uncomment the host value and replace your DNS hostname with `example.com` in deploy_aks.yaml file in line **1442**.

      ![DNS](images/deploy/aks/ingress_http_yaml.png)

8. If you have the SSL certificate for your DNS and need to configure the site with your SSL certificate, follow the below step or you can skip to **Step 11**.

9.  Run the following command to create a TLS secret with your SSL certificate.

```sh
kubectl create secret tls bold-tls -n bold-services --key <key-path> --cert <certificate-path>
```

10. Now, uncomment the `tls` section and replace your DNS hostname with `example.com` in ingress spec and save the file.

       ![ingress DNS](images/deploy/aks/ingress_yaml.png)

11. Now, run the following command to get the ingress IP address.

      ```sh
      kubectl get svc -n ingress-nginx
      ```
      Repeat the above command till you get the IP address in EXTERNAL-IP tab as shown in the following image. 
      ![Ingress Address](images/deploy/aks/ingress_address.png) 

12. Note the EXTERNAL-IP address and map it with your DNS, if you have added the DNS in **deploy_aks.yaml** file. If you do not have the DNS and want to use the application, then you can use the EXTERNAL-IP address.

13. Replace your DNS or EXTERNAL-IP address in `<application_base_url>` place.

    Ex:  `http://example.com`, `https://example.com`, `http://<ingress_ip_address>`
    
    ![App_Base_Url](images/deploy/aks/app_base_url.png) 
    
14. Read the optional client library license agreement from the following link.

    [Consent to deploy client libraries](../docs/consent-to-deploy-client-libraries.md)
    
15. By default all the client libraries will be installed for Bold BI in Kubernetes. Still you can still overwrite them by mentioning the required libraries as comma separated like below in the environment variable noted from the above link.

    ![Optinal_Lib](images/deploy/aks/optional_lib.png) 

16. Now, run the following commands to deploy Bold BI in your kubernetes cluster.

    ```sh
    kubectl apply -f deploy.yaml
    ```

17. Use the following command to get the pods status.

     ```sh
    kubectl get pods -n bold-services
     ```
    ![Pod status](images/deploy/pod_status.png) 

18. Wait till you see the applications in running state. Then use your DNS or EXTERNAL-IP address you got from below command to access the application in the browser.
    
     ```sh
    kubectl get ingress -n bold-services
    ```
    ![Ingress Address](images/deploy/aks/ingress.png)

    ![Browser_veiw](images/deploy/Browser_veiw.png) 
    
19. If you facing any Deployment Error,Click Proceed to the application startup page link and Please refer the following link for more details on configuring the application startup manually.
    
    https://help.boldbi.com/embedded-bi/application-startup
    
    



1. Download the deployment file [here](https://raw.githubusercontent.com/boldbi/boldbi-kubernetes/UMP-22952-Autodeployment-documentation/deploy/auto-deployment/deploy_aks.yaml) to deloy Bold BI on AKS.

2. Navigate to the folder where the deployment files were downloaded from **Step 1**.

3. Refer to the below link to configure the persistent volume based on your cluster provider.
 
    * [Azure Kubernetes Service(AKS)](persistent-volumes.md#azure-kubernetes-service)
    * [Amazon Elastic Kubernetes Service(EKS)](persistent-volumes.md#amazon-elastic-kubernetes-service)
    * [Google Kubernetes Engine (GKE)](persistent-volumes.md#google-kubernetes-engine)

4. After connecting with your cluster, deploy the latest Nginx ingress controller to your cluster using the following command.
            <br>
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
                   kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/cloud/deploy.yaml
                  </td>
                </tr>
                <tr>
                  <td>
                   EKS Cluster
                  </td>
                  <td>
                   kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/aws/deploy.yaml
                  </td>
                </tr>
                <tr>
                  <td>
                   AKS Cluster
                  </td>
                  <td>
                   kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/cloud/deploy.yaml
                  </td>
                </tr>
            </table>
            </br>
5. Enter the variable information needed to complete the auto deployment in <b>deploy.yaml</b> as shown below.

    * Enter the Bold BI licence key, user, and database server details.
        
        ![Licence-and-User-Details](images/licence-and-user-details.png)

        ## Environment variables details for configuring `Application Startup` in backend

        | Name                          |Required| Description   | 
        | -------------                 |----------| ------------- |
        |`BOLD_SERVICES_UNLOCK_KEY`|Yes|License key of Bold BI|
        |`BOLD_SERVICES_DB_TYPE`|Yes|Type of database server can be used for configuring the Bold BI.<br/><br />The following DB types are accepted:<br />1. mssql –           Microsoft SQL Server/Azure SQL Database<br />2. postgresql – PostgreSQL Server<br />3. mysql – MySQL/MariaDB Server|
        |`BOLD_SERVICES_DB_HOST`|Yes|Name of the Database Server|
        |`BOLD_SERVICES_DB_PORT`|No|The system will use the following default port numbers based on the database server type.<br />PostgrSQL – 5234<br />MySQL -3306<br         /><br />Please specify the port number for your database server if it is configured on a different port.<br /><br />For MS SQL Server, this parameter is not           necessary.|
        |`BOLD_SERVICES_DB_USER`|Yes|Username for the database server<br /><br />Please refer to [this documentation](https://help.boldbi.com/embedded-bi/faq/what-are-         the-database-permissions-required-to-set-up-bold-bi-embedded/) for information on the user's permissions.|
        |`BOLD_SERVICES_DB_PASSWORD`|Yes|The database user's password|
        |`BOLD_SERVICES_DB_NAME`|No|If the database name is not specified, the system will create a new database called bold services.<br /><br />If you specify a             database name, it should already exist on the server.|
        |`BOLD_SERVICES_POSTGRESQL_MAINTENANCE_DB`|No|For PostgreSQL DB Servers, this is an optional parameter.<br />The system will use the database name `postgres`           by default.<br />If your database server uses a different default database, please provide it here.|
        |`BOLD_SERVICES_DB_ADDITIONAL_PARAMETERS`|No|If your database server requires additional connection string parameters, include them here.<br /><br />Connection         string parameters can be found in the official document.<br />My SQL: https://dev.mysql.com/doc/connector-net/en/connector-net-8-0-connection-options.html<br           />PostgreSQL: https://www.npgsql.org/doc/connection-string-parameters.html<br />MS SQL: https://docs.microsoft.com/en-                       us/dotnet/api/system.data.sqlclient.sqlconnection.connectionstring<br /><br /><b>Note:</b> A semicolon(;) should be used to separate multiple parameters.|
        |`BOLD_SERVICES_USER_EMAIL`|Yes|It should be a valid email.|
        |`BOLD_SERVICES_USER_PASSWORD`|Yes|It should meet our password requirements.|
        
        
        
    *  If you want to use custom values for branding enter the branding image and site identifier variable details.otherwise Bold BI will take the default values.
        
       ![Branding-Details](images/branding-details.png)
  
        ## Environment variables for configuring `Branding` in backend

        The following environment variables are optional. If they are not provided, Bold BI will use the default configured values.

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
               BOLD_SERVICES_BRANDING_MAIN_LOGO
              </td>
              <td>   
               This is the header logo for the application, and the preferred image size is 40 x 40 pixels.
              </td>
            </tr>
            <tr>
              <td>
               BOLD_SERVICES_BRANDING_LOGIN_LOGO
              </td>
              <td>     
               This is the login logo for the application, and the preferred image size is 200 x 40 pixels.
              </td>
            </tr>
            <tr>
              <td>
               BOLD_SERVICES_BRANDING_EMAIL_LOGO
              </td>
              <td>     
               This is an email logo, and the preferred image size is 200 x 40 pixels.
              </td>
            </tr>
            <tr>
              <td>
               BOLD_SERVICES_BRANDING_FAVICON
              </td>
              <td>     
               This is a favicon, and the preferred image size is 40 x 40 pixels. 
              </td>
            </tr>
            <tr>
              <td>
               BOLD_SERVICES_BRANDING_FOOTER_LOGO
              </td>
              <td>     
               This is powered by the logo, and the preferred size is 100 x 25 pixels.
               <br />
               <br />
               <b>Note:</b><br/>• All branding variables are accepted as URL.<br/>• <b>Ex:</b> https://example.com/loginlogo.jpg.<br/>• <b>Image type:</b> png, svg, jpg,   jpeg.<br/>• If you want to use custom branding, provide the value for all branding variables. If all variable values are given, the application will use the branding images, otherwise, it will take the default logos. 
              </td>
            </tr>
            <tr>
              <td>
               BOLD_SERVICES_SITE_NAME
              </td>
              <td>
              This is organization name.     
              <br />
               If the value is not given, the site will be deployed using the default name.
              </td>
            </tr>
            <tr>
              <td>
               BOLD_SERVICES_SITE_IDENTIFIER
              </td>
              <td>     
               This is site identifier, and it will be the part of the application URL.
              <br />
              If the value is not given, the site will be deployed using the default value.
              </td>
            </tr>
        </table>
        <br/>
        
        
    * If you need to use **Bing Map** widget feature, enter value for `widget_bing_map_enable` environment variable as `true` and API key value for               `widget_bing_map_api_key`.
       
       ![Enable-Bingmap](images/enable-bingmap.png)

6. If you have a DNS to map with the application, then you can continue with the following steps, else skip to **Step 11**. 

7. Open the **ingress.yaml** file. Uncomment the host value and replace your DNS hostname with `example.com` and save the file.

8. If you have the SSL certificate for your DNS and need to configure the site with your SSL certificate, follow the below step or you can skip to **Step 11**.

9.  Run the following command to create a TLS secret with your SSL certificate.

```sh
kubectl create secret tls bold-tls -n bold-services --key <key-path> --cert <certificate-path>
```

10. Now, uncomment the `tls` section and replace your DNS hostname with `example.com` in ingress spec and save the file.

       ![ingress DNS](images/ingress_yaml.png)

11. Run the following command for applying the Bold BI ingress to get the IP address of Nginx ingress.

```sh
kubectl apply -f ingress.yaml
```

12. Now, run the following command to get the ingress IP address.

```sh
kubectl get ingress -n bold-services
```

Repeat the above command till you get the IP address in ADDRESS tab as shown in the following image.
![Ingress Address](images/ingress_address.png) 

13. Note the ingress IP address and map it with your DNS, if you have added the DNS in **ingress.yaml** file. If you do not have the DNS and want to use the application, then you can use the ingress IP address.

14. Open the **deploy.yaml** file from the downloaded files in **Step 1**. Replace your DNS or ingress IP address in `<application_base_url>` place.

    Ex:  `http://example.com`, `https://example.com`, `http://<ingress_ip_address>`
    
    ![App_Base_Url](images/app_base_url.png) 
    
15. Read the optional client library license agreement from the following link.

    [Consent to deploy client libraries](../docs/consent-to-deploy-client-libraries.md)
    
16. By default all the client libraries will be installed for Bold BI in Kubernetes. Still you can still overwrite them by mentioning the required libraries as comma seperated like below in the environment variable noted from the above link.

    ![Optinal_Lib](images/optional_lib.png) 

17. Now, run the following commands one by one:

   ```sh
   kubectl apply -f secrets-and-configmap.yaml

   kubectl apply -f deploy.yaml
   ```

18. Use the following command to get the pods status.

   ```sh
   kubectl get pods -n bold-services
   ```
![Pod status](images/pod_status.png) 

19. Wait till you see the applications in running state. Then use your DNS or ingress IP address you got from **Step 12** to access the application in the browser.

    ![Browser_veiw](images/Browser_veiw.png) 
    
20. If you facing any Deployment Error,Click Proceed to the application startup page link and Please refer the following link for more details on configuring the application startup manually.
    
    https://help.boldbi.com/embedded-bi/application-startup
    
    
    
    
    
    
    
    
1. Download the deployment file [here](https://raw.githubusercontent.com/boldbi/boldbi-kubernetes/UMP-22952-Autodeployment-documentation/deploy/auto-deployment/deploy_aks.yaml) to deloy Bold BI on AKS.

2. Navigate to the folder where the deployment files were downloaded from **Step 1**.

3. Refer to the below link to configure the persistent volume based on your cluster provider.
 
    * [Azure Kubernetes Service(AKS)](persistent-volumes.md#azure-kubernetes-service)
    * [Amazon Elastic Kubernetes Service(EKS)](persistent-volumes.md#amazon-elastic-kubernetes-service)
    * [Google Kubernetes Engine (GKE)](persistent-volumes.md#google-kubernetes-engine)

4. After connecting with your cluster, deploy the latest Nginx ingress controller to your cluster using the following command.
            <br>
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
                   kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/cloud/deploy.yaml
                  </td>
                </tr>
                <tr>
                  <td>
                   EKS Cluster
                  </td>
                  <td>
                   kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/aws/deploy.yaml
                  </td>
                </tr>
                <tr>
                  <td>
                   AKS Cluster
                  </td>
                  <td>
                   kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/cloud/deploy.yaml
                  </td>
                </tr>
            </table>
            </br>
5. Enter the variable information needed to complete the auto deployment in <b>deploy.yaml</b> as shown below.

    * Enter the Bold BI licence key, user, and database server details.
        
        ![Licence-and-User-Details](images/licence-and-user-details.png)

        ## Environment variables details for configuring `Application Startup` in backend

        | Name                          |Required| Description   | 
        | -------------                 |----------| ------------- |
        |`BOLD_SERVICES_UNLOCK_KEY`|Yes|License key of Bold BI|
        |`BOLD_SERVICES_DB_TYPE`|Yes|Type of database server can be used for configuring the Bold BI.<br/><br />The following DB types are accepted:<br />1. mssql –           Microsoft SQL Server/Azure SQL Database<br />2. postgresql – PostgreSQL Server<br />3. mysql – MySQL/MariaDB Server|
        |`BOLD_SERVICES_DB_HOST`|Yes|Name of the Database Server|
        |`BOLD_SERVICES_DB_PORT`|No|The system will use the following default port numbers based on the database server type.<br />PostgrSQL – 5234<br />MySQL -3306<br         /><br />Please specify the port number for your database server if it is configured on a different port.<br /><br />For MS SQL Server, this parameter is not           necessary.|
        |`BOLD_SERVICES_DB_USER`|Yes|Username for the database server<br /><br />Please refer to [this documentation](https://help.boldbi.com/embedded-bi/faq/what-are-         the-database-permissions-required-to-set-up-bold-bi-embedded/) for information on the user's permissions.|
        |`BOLD_SERVICES_DB_PASSWORD`|Yes|The database user's password|
        |`BOLD_SERVICES_DB_NAME`|No|If the database name is not specified, the system will create a new database called bold services.<br /><br />If you specify a             database name, it should already exist on the server.|
        |`BOLD_SERVICES_POSTGRESQL_MAINTENANCE_DB`|No|For PostgreSQL DB Servers, this is an optional parameter.<br />The system will use the database name `postgres`           by default.<br />If your database server uses a different default database, please provide it here.|
        |`BOLD_SERVICES_DB_ADDITIONAL_PARAMETERS`|No|If your database server requires additional connection string parameters, include them here.<br /><br />Connection         string parameters can be found in the official document.<br />My SQL: https://dev.mysql.com/doc/connector-net/en/connector-net-8-0-connection-options.html<br           />PostgreSQL: https://www.npgsql.org/doc/connection-string-parameters.html<br />MS SQL: https://docs.microsoft.com/en-                       us/dotnet/api/system.data.sqlclient.sqlconnection.connectionstring<br /><br /><b>Note:</b> A semicolon(;) should be used to separate multiple parameters.|
        |`BOLD_SERVICES_USER_EMAIL`|Yes|It should be a valid email.|
        |`BOLD_SERVICES_USER_PASSWORD`|Yes|It should meet our password requirements.|
        
        
        
    *  If you want to use custom values for branding enter the branding image and site identifier variable details.otherwise Bold BI will take the default values.
        
       ![Branding-Details](images/branding-details.png)
  
        ## Environment variables for configuring `Branding` in backend

        The following environment variables are optional. If they are not provided, Bold BI will use the default configured values.

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
               BOLD_SERVICES_BRANDING_MAIN_LOGO
              </td>
              <td>   
               This is the header logo for the application, and the preferred image size is 40 x 40 pixels.
              </td>
            </tr>
            <tr>
              <td>
               BOLD_SERVICES_BRANDING_LOGIN_LOGO
              </td>
              <td>     
               This is the login logo for the application, and the preferred image size is 200 x 40 pixels.
              </td>
            </tr>
            <tr>
              <td>
               BOLD_SERVICES_BRANDING_EMAIL_LOGO
              </td>
              <td>     
               This is an email logo, and the preferred image size is 200 x 40 pixels.
              </td>
            </tr>
            <tr>
              <td>
               BOLD_SERVICES_BRANDING_FAVICON
              </td>
              <td>     
               This is a favicon, and the preferred image size is 40 x 40 pixels. 
              </td>
            </tr>
            <tr>
              <td>
               BOLD_SERVICES_BRANDING_FOOTER_LOGO
              </td>
              <td>     
               This is powered by the logo, and the preferred size is 100 x 25 pixels.
               <br />
               <br />
               <b>Note:</b><br/>• All branding variables are accepted as URL.<br/>• <b>Ex:</b> https://example.com/loginlogo.jpg.<br/>• <b>Image type:</b> png, svg, jpg,   jpeg.<br/>• If you want to use custom branding, provide the value for all branding variables. If all variable values are given, the application will use the branding images, otherwise, it will take the default logos. 
              </td>
            </tr>
            <tr>
              <td>
               BOLD_SERVICES_SITE_NAME
              </td>
              <td>
              This is organization name.     
              <br />
               If the value is not given, the site will be deployed using the default name.
              </td>
            </tr>
            <tr>
              <td>
               BOLD_SERVICES_SITE_IDENTIFIER
              </td>
              <td>     
               This is site identifier, and it will be the part of the application URL.
              <br />
              If the value is not given, the site will be deployed using the default value.
              </td>
            </tr>
        </table>
        <br/>
        
        
    * If you need to use **Bing Map** widget feature, enter value for `widget_bing_map_enable` environment variable as `true` and API key value for               `widget_bing_map_api_key`.
       
       ![Enable-Bingmap](images/enable-bingmap.png)

6. If you have a DNS to map with the application, then you can continue with the following steps, else skip to **Step 11**. 

7. Open the **ingress.yaml** file. Uncomment the host value and replace your DNS hostname with `example.com` and save the file.

8. If you have the SSL certificate for your DNS and need to configure the site with your SSL certificate, follow the below step or you can skip to **Step 11**.

9.  Run the following command to create a TLS secret with your SSL certificate.

```sh
kubectl create secret tls bold-tls -n bold-services --key <key-path> --cert <certificate-path>
```

10. Now, uncomment the `tls` section and replace your DNS hostname with `example.com` in ingress spec and save the file.

       ![ingress DNS](images/ingress_yaml.png)

11. Run the following command for applying the Bold BI ingress to get the IP address of Nginx ingress.

```sh
kubectl apply -f ingress.yaml
```

12. Now, run the following command to get the ingress IP address.

```sh
kubectl get ingress -n bold-services
```

Repeat the above command till you get the IP address in ADDRESS tab as shown in the following image.
![Ingress Address](images/ingress_address.png) 

13. Note the ingress IP address and map it with your DNS, if you have added the DNS in **ingress.yaml** file. If you do not have the DNS and want to use the application, then you can use the ingress IP address.

14. Open the **deploy.yaml** file from the downloaded files in **Step 1**. Replace your DNS or ingress IP address in `<application_base_url>` place.

    Ex:  `http://example.com`, `https://example.com`, `http://<ingress_ip_address>`
    
    ![App_Base_Url](images/app_base_url.png) 
    
15. Read the optional client library license agreement from the following link.

    [Consent to deploy client libraries](../docs/consent-to-deploy-client-libraries.md)
    
16. By default all the client libraries will be installed for Bold BI in Kubernetes. Still you can still overwrite them by mentioning the required libraries as comma seperated like below in the environment variable noted from the above link.

    ![Optinal_Lib](images/optional_lib.png) 

17. Now, run the following commands one by one:

   ```sh
   kubectl apply -f secrets-and-configmap.yaml

   kubectl apply -f deploy.yaml
   ```

18. Use the following command to get the pods status.

   ```sh
   kubectl get pods -n bold-services
   ```
![Pod status](images/pod_status.png) 

19. Wait till you see the applications in running state. Then use your DNS or ingress IP address you got from **Step 12** to access the application in the browser.

    ![Browser_veiw](images/Browser_veiw.png) 
    
20. If you facing any Deployment Error,Click Proceed to the application startup page link and Please refer the following link for more details on configuring the application startup manually.
    
    https://help.boldbi.com/embedded-bi/application-startup


