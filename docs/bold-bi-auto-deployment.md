# Bold BI auto deployment on Kubernetes Service

## Deployment Methods

There are two ways to deploy Bold BI on the Kubernetes cluster. Please refer to the following documents for Bold BI deployment:

* [Deploy Bold BI using kubectl](#deployment-prerequisites)
* [Deploy Bold BI using Helm]()

## Deploy Bold BI using kubectl

[Bold BI](https://www.boldbi.com/) can be deployed manually on Kubernetes cluster. You can create Kubernetes cluster on cloud cluster providers(GKE,AKS and EKS). After completing cluster creation, connect to it and you can download the configuration files [here](../deploy/). This directory includes configuration YAML files, which contains all the configuration settings needed to deploy Bold BI on Kubernetes cluster.

### Deployment prerequisites

* [Install Kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) to deploy Bold BI using kubectl.
* [File Storage](pre-requisites.md#file-storage)
* [Create and connect a cluster](pre-requisites.md#create-a-cluster)
* Load Balancing- [Nginx](pre-requisites.md#ingress-nginx)


### Steps for Bold BI auto deployment on 

1. Download the files for Bold BI deployment from [here]().

2. Configure the pvclaim.yaml file based on your cluster provider.
 
    * [Amazon Elastic Kubernetes Service (EKS)](persistent-volumes.md#azure-kubernetes-service)
    * [Azure Kubernetes Service (AKS)](persistent-volumes.mdpersistent-volumes.md#amazon-elastic-kubernetes-service)
    * [Google Kubernetes Engine (GKE)](persistent-volumes.mdpersistent-volumes.md#google-kubernetes-engine)

3. After connecting with your cluster, deploy the latest Nginx ingress controller to your cluster using the following command.

    ```sh
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/cloud/deploy.yaml
    ```
4. Navigate to the folder where the deployment files were downloaded from **Step 1**.

5. Enter the variable information needed to complete the auto deployment in <b>secrets-and-configmap.yaml</b> as shown below.

    * Enter the Bold BI licence key, username, and database server details in the secrets-and-configmap.yaml file.
        
        ![licence-and-user-details](images/licence-and-user-details.png)

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
        
        
        
    *  If you want to use custom values for branding enter the branding image and site identifier variable details in the secrets-and-configmap.yaml otherwise Bold BI 
       will take the default values.
        
       ![branding-details](images/branding-details.png)
  
  Environment variables for configuring `Branding` in backend
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




