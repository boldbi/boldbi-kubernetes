# Configuration

See [Customizing the Chart Before Installing](https://helm.sh/docs/intro/using_helm/#customizing-the-chart-before-installing).
To see all configurable options with detailed comments, visit the chart's [values.yaml](../charts/values.yaml), or run these configuration commands:

```console
# Helm 3
$ helm show values boldbi/boldbi
```

## Client Libraries

Read the optional client library license agreement from the following link.

[Consent to deploy client libraries](../docs/consent-to-deploy-client-libraries.md)

Note the optional client libraries from the above link as comma separated names and replace it in `[comma_separated_library_names]` place.

```console
# Helm 3
$ helm install [RELEASE_NAME] boldbi/boldbi --set optionalLibs=[comma_separated_library_names] [flags]
```

## Bing Map Widget

If you need to use **Bing Map** widget feature, enter value for `widget_bing_map_enable` environment variable as `true` and API key value for `widget_bing_map_api_key` on **deployment.yaml** file.

```console
# Helm 3
$ helm install [RELEASE_NAME] boldbi/boldbi --set bingMapWidget.enabled=true,bingMapWidget.apiKey=[api-key] [flags]
```
