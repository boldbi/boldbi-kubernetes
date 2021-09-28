# Upgrading Bold BI to 4.1.36

This section explains how to upgrade Bold BI to 4.1.36 version in your Kubernetes cluster. You can refer to the features and enhancements from this [Release Notes](https://www.boldbi.com/release-history/enterprise/).


## Backup the existing data
Before upgrading the Bold BI to latest version, make sure to take the backup of the following items.

* Files and folders from the shared location, which you have mounted to the deployments by persistent volume claims (pvclaim_*.yaml).

* Database backup - Take a backup of Database, to restore incase if the upgrade was not successful or if applications are not working properly after the upgrade.


## Proceeding with upgrade
Bold BI updates the database schema of your current version to the latest version. The upgrade process will retain all the resources and settings from the previous deployment.

You can download the upgrade script from this [link](https://raw.githubusercontent.com/boldbi/boldbi-kubernetes/v4.2_common_idp/upgrade/upgrade.sh) or use the below command.

```sh
curl -o upgrade_boldbi.sh https://raw.githubusercontent.com/boldbi/boldbi-kubernetes/v4.2_common_idp/upgrade/upgrade.sh
```

Run the following command to execute the shell script to upgrade Bold BI.

```sh
./upgrade.sh --version="4.2.68" --namespace="<namespace>" --app_base_url="<application_base_url>" --optional_libs="<comma_separated_library_names>" --bing_map_enable="true" --bing_map_api_key="<widget_bing_map_api_key>"
```


> **INFO:** 
> 1. You can ignore `--bing_map_enable` and `--bing_map_api_key` arguments from the above upgrade command if you are not using Bing Map Widget.
> 2. You can also ignore `--optional_libs` argument if not needed.



<table>
    <tr>
      <td>
       version
      </td>
      <td>
      Image tag of the current version, which you are going to upgrade.
      </td>
    </tr>
    <tr>
      <td>
       namespace
      </td>
      <td>
       namespace in which your existing Bold BI application was running. </br>
       Default value: <i>default</i>
      </td>
    </tr>
    <tr>
      <td>
       app_base_url*
      </td>
      <td>
       Application base URL of your Bold BI Deployment. </br>
      </td>
    </tr>
    <tr>
      <td>
       optional_libs
      </td>
      <td>
       Comma seperated optional libraries. </br>
       Default value is <i>null</i>
      </td>
    </tr>
    <tr>
      <td>
       bing_map_enable
      </td>
      <td>
       If you are using Bing Map widget, Set this value to <i>true</i> </br>
       Default value is <i>false</i>
      </td>
    </tr>
     <tr>
      <td>
       bing_map_enable
      </td>
      <td>
       If you are using Bing Map widget please ignore this argument </br>
      </td>
    </tr>
</table>
