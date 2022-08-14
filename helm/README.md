# Deploy Bold BI using Helm

This chart installs [Bold BI](https://www.boldbi.com/) on Kubernetes. You can create Kubernetes cluster on either cloud or on-premise infrastructure. Please follow the below documentation for Bold BI deployment in a specific cloud and on-premise environments.
    
## Deployment prerequisites

* [Install Helm](https://helm.sh/docs/intro/install/) to deploy Bold BI using Helm.
* [File Storage](docs/pre-requisites.md#file-storage)
* [Create and connect a cluster](docs/pre-requisites.md#create-a-cluster)
* [Load Balancing](docs/pre-requisites.md#load-balancing)

> **Note:** Note the [Ingress IP address](docs/pre-requisites.md#get-ingress-ip) to use it while crafting values.yaml when installing Bold BI with helm chart.

## Get Repo Info

1. Add the Bold BI helm repository

```console
helm repo add boldbi https://boldbi.github.io/boldbi-kubernetes
helm repo update
```

2. View charts in repo

```console
helm search repo boldbi

NAME            CHART VERSION   APP VERSION     DESCRIPTION
boldbi/boldbi   5.2.48           5.2.48          Embed powerful analytics inside your apps and t...
```

_See [helm repo](https://helm.sh/docs/helm/helm_repo/) for command documentation._

## Install Chart

For Helm chart, you'll need to craft a `values.yaml`.

* For `GKE` please download the values.yaml file [here](https://raw.githubusercontent.com/boldbi/boldbi-kubernetes/v5.2.48/helm/custom-values/gke-values.yaml).
* For `EKS` please download the values.yaml file [here](https://raw.githubusercontent.com/boldbi/boldbi-kubernetes/v5.2.48/helm/custom-values/eks-values.yaml).
* For `AKS` please download the values.yaml file [here](https://raw.githubusercontent.com/boldbi/boldbi-kubernetes/v5.2.48/helm/custom-values/aks-values.yaml).

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
       namespace
      </td>
      <td>
       The namespace in which the Bold BI resources will be dpleoyed in the kubernetes cluster.<br/>
       The default namespace is <i>bold-services</i>
      </td>
    </tr>
    <tr>
      <td>
       appBaseUrl *
      </td>
      <td>
       Domain or <a href='docs/pre-requisites.md#get-ingress-ip'>Ingress IP address</a> with http/https protocol. Follow the <a href='docs/configuration.md#ssl-termination'>SSL Termination</a> to configure SSL certificate for https protocol after deploying Bold BI in your cluster.
      </td>
    </tr>
    <tr>
      <td>
       optionalLibs
      </td>
      <td>
       These are the client libraries used in Bold BI by default.<br/>
       '<i>mongodb,mysql,influxdb,snowflake,oracle,npgsql</i>'<br/>
       Please refer to <a href='docs/configuration.md#client-libraries'>Optional Client Libraries</a> section to know more.
      </td>
    </tr>
    <tr>
      <td>
       clusterProvider
      </td>
      <td>
       The type of kubernetes cluster provider you are using.<br/>
       The recommended values are '<i>gke,eks,aks and onpremise</i>'
      </td>
    </tr>
    <tr>
      <td>
       persistentVolume *
      </td>
      <td>
       Please refer to <a href='docs/configuration.md#persistent-volume'>this</a> section to know more on how to set Persistant Volumes for Bold BI.
      </td>
    </tr>
    <tr>
      <td>
       loadBalancer
      </td>
      <td>
       Currently we have provided support for Nginx and Istio as Load Balancers in Bold BI. Please refer to <a href='docs/configuration.md#load-balancing'>this</a> section for configuring Load balancer for Bold BI.
      </td>
    </tr>
    <tr>
      <td>
       autoscaling
      </td>
      <td>
       By default autoscaling is enabled in Bold BI. Please refer to <a href='docs/configuration.md#auto-scaling'>this</a> section to configure autoscaling in Bold BI.
      </td>
    </tr>
    <tr>
      <td>
       bingMapWidget
      </td>
      <td>
       Please refer to <a href='docs/configuration.md#bing-map-widget'>this</a> section to configure Bing Map Widget in Bold BI.
      </td>
    </tr>
    <tr>
      <td>
       BOLD_SERVICES_UNLOCK_KEY
      </td>
      <td>
       License key of Bold BI
      </td>
    </tr>
    <tr>
      <td>
       BOLD_SERVICES_DB_TYPE *
      </td>
      <td>
       Type of database server can be used for configuring the Bold BI.<br/><br />The following DB types are accepted:<br />1. mssql – Microsoft SQL Server/Azure SQL Database<br />2. postgresql – PostgreSQL Server<br />3. mysql – MySQL/MariaDB Server
      </td>
    </tr>
    <tr>
      <td>
       BOLD_SERVICES_DB_HOST *
      </td>
      <td>
       Name of the Database Server
      </td>
    </tr>
    <tr>
      <td>
       BOLD_SERVICES_DB_PORT
      </td>
      <td>
       The system will use the following default port numbers based on the database server type.<br />PostgrSQL – 5234<br />MySQL -3306<br /><br />Please specify the port number for your database server if it is configured on a different port.<br /><br />For MS SQL Server, this parameter is not necessary.
      </td>
    </tr>
    <tr>
      <td>
       BOLD_SERVICES_DB_USER *
      </td>
      <td>
       Username for the database server<br /><br />Please refer to [this documentation](https://help.boldbi.com/embedded-bi/faq/what-are-the-database-permissions-required-to-set-up-bold-bi-embedded/) for information on the user's permissions.
      </td>
    </tr>
    <tr>
      <td>
       BOLD_SERVICES_DB_PASSWORD *
      </td>
      <td>
       The database user's password
      </td>
    </tr>
    <tr>
      <td>
       BOLD_SERVICES_DB_NAME
      </td>
      <td>
       If the database name is not specified, the system will create a new database called bold services.<br /><br />If you specify a database name, it should already exist on the server.
      </td>
    </tr>
    <tr>
      <td>
       BOLD_SERVICES_POSTGRESQL_MAINTENANCE_DB
      </td>
      <td>
       For PostgreSQL DB Servers, this is an optional parameter.<br />The system will use the database name `postgres` by default.<br />If your database server uses a different default database, please provide it here.
      </td>
    </tr>
    <tr>
      <td>
       BOLD_SERVICES_DB_ADDITIONAL_PARAMETERS
      </td>
      <td>
       If your database server requires additional connection string parameters, include them here.<br /><br />Connection string parameters can be found in the official document.<br />My SQL: https://dev.mysql.com/doc/connector-net/en/connector-net-8-0-connection-options.html<br />PostgreSQL: https://www.npgsql.org/doc/connection-string-parameters.html<br />MS SQL: https://docs.microsoft.com/en-us/dotnet/api/system.data.sqlclient.sqlconnection.connectionstring<br /><br /><b>Note:</b> A semicolon(;) should be used to separate multiple parameters.
      </td>
    </tr>
    <tr>
      <td>
       BOLD_SERVICES_USER_EMAIL *
      </td>
      <td>   
       It should be a valid email.
      </td>
    </tr>
    <tr>
      <td>
       BOLD_SERVICES_USER_PASSWORD *
      </td>
      <td>     
       It should meet our password requirements.
      </td>
    </tr>
</table>
<br/>

> **Note:** Items marked with `*` are mandatory fields in values.yaml

Run the following command to delpoy Bold BI in your cluster.

```console
helm install [RELEASE_NAME] boldbi/boldbi -f [Crafted values.yaml file]
```
Ex:  `helm install boldbi boldbi/boldbi -f my-values.yaml`

Refer [here](docs/configuration.md) for advanced configuration including SSL termination, optional client libraries, etc.

_See [helm install](https://helm.sh/docs/helm/helm_install/) for command documentation._

## Upgrade

Run the following command to get the latest version of Bold BI helm chart.

```console
helm repo update
```

Run the below command to apply changes in your Bold BI release or upgrading Bold BI to latest version.

```console
helm upgrade [RELEASE_NAME] boldbi/boldbi -f [Crafted values.yaml file]
```

Ex:  `helm upgrade boldbi boldbi/boldbi -f my-values.yaml`

## Uninstall Chart

```console
helm uninstall [RELEASE_NAME]
```
Ex:  `helm uninstall boldbi`

This removes all the Kubernetes components associated with the chart and deletes the release.

_See [helm uninstall](https://helm.sh/docs/helm/helm_uninstall/) for command documentation._

## Application Startup

Configure the Bold BI On-Premise application startup to use the application. Please refer the following link for more details on configuring the application startup.
    
https://help.boldbi.com/embedded-bi/application-startup
