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
appBaseUrl: <app_base_url>
optionalLibs: <comma_separated_library_names>
clusterProvider: <cluster_type>
```

## Persistent Volume

### Capacity

Generally, a PV will have a specific storage capacity. This is set using the PV's capacity attribute. See the [Kubernetes Resource Model](https://git.k8s.io/community/contributors/design-proposals/scheduling/resources.md) to understand the units expected by capacity.

By default the persistent volume capacity used in Bold BI is `3Gi`. 

### Name

By default the persistent volume name used in Bold BI is `boldbi-fileserver`. 

```console
persistentVolume:
  # persistent volumes were global resources. 
  # so if you already have Bold BI installed in your cluster, 
  # then the previous persistent volume name will conflict with current installation.
  # Change this name to avoid conflicts with previous Bold BI persistent volumes.
  name: boldbi-fileserver
  capacity: 3Gi
```

## Bing Map Widget

If you need to use **Bing Map** widget feature, enable this to `true` and API key value for `<widget_bing_map_api_key>`.

```console
bingMapWidget:
  enabled: <true / false>
  apiKey: <widget_bing_map_api_key>
```
