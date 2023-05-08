{{/*
Expand the name of the chart.
*/}}
{{- define "boldbi.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "boldbi.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "boldbi.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "boldbi.labels" -}}
helm.sh/chart: {{ include "boldbi.chart" . }}
{{ include "boldbi.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "boldbi.selectorLabels" -}}
app.kubernetes.io/name: {{ include "boldbi.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "boldbi.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "boldbi.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Get KubeVersion removing pre-release information.
*/}}
{{- define "boldbi.kubeVersion" -}}
  {{- default .Capabilities.KubeVersion.Version (regexFind "v[0-9]+\\.[0-9]+\\.[0-9]+" .Capabilities.KubeVersion.Version) -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for ingress.
*/}}
{{- define "ingress.apiVersion" -}}
  {{- if and (.Capabilities.APIVersions.Has "networking.k8s.io/v1") (semverCompare ">= 1.19.x" (include "boldbi.kubeVersion" .)) -}}
      {{- print "networking.k8s.io/v1" -}}
  {{- else if .Capabilities.APIVersions.Has "networking.k8s.io/v1beta1" -}}
    {{- print "networking.k8s.io/v1beta1" -}}
  {{- else -}}
    {{- print "extensions/v1beta1" -}}
  {{- end -}}
{{- end -}}

{{/*
Return if ingress is stable.
*/}}
{{- define "ingress.isStable" -}}
  {{- eq (include "ingress.apiVersion" .) "networking.k8s.io/v1" -}}
{{- end -}}

{{/*
Return if ingress supports ingressClassName.
*/}}
{{- define "ingress.supportsIngressClassName" -}}
  {{- or (eq (include "ingress.isStable" .) "true") (and (eq (include "ingress.apiVersion" .) "networking.k8s.io/v1beta1") (semverCompare ">= 1.18.x" (include "boldbi.kubeVersion" .))) -}}
{{- end -}}
{{/*
Return if ingress supports pathType.
*/}}
{{- define "ingress.supportsPathType" -}}
  {{- or (eq (include "ingress.isStable" .) "true") (and (eq (include "ingress.apiVersion" .) "networking.k8s.io/v1beta1") (semverCompare ">= 1.18.x" (include "boldbi.kubeVersion" .))) -}}
{{- end -}}
{{/*
Return if hpa supports behavior.
*/}}
{{- define "hpa.behavior" -}}
  {{- semverCompare ">= 1.18.x" (include "boldbi.kubeVersion" .) -}}
{{- end -}}

{{/*
Define the boldbi.namespace template if set with forceNamespace or .Release.Namespace is set
*/}}
{{- define "boldbi.namespace" -}}
{{- if eq .Release.Namespace "default" -}}
{{ printf "namespace: %s" .Values.namespace.name }}
{{- else -}}
{{ printf "namespace: %s" .Release.Namespace }}
{{- end -}}
{{- end -}}

{{/*
Define the boldbi.notes template if set with forceNamespace or .Release.Namespace is set
*/}}
{{- define "boldbi.notes-pods" -}}
{{- if eq .Release.Namespace "default" -}}
{{ printf "$ kubectl get pods -n %s" .Values.namespace.name }}
{{- else -}}
{{ printf "$ kubectl get pods -n %s" .Release.Namespace }}
{{- end -}}
{{- end -}}

{{- define "boldbi.notes-hpa" -}}
{{- if eq .Release.Namespace "default" -}}
{{ printf "$ kubectl get hpa -n %s" .Values.namespace.name }}
{{- else -}}
{{ printf "$ kubectl get hpa -n %s" .Release.Namespace }}
{{- end -}}
{{- end -}}