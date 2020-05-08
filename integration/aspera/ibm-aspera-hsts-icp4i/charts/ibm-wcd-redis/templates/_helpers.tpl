{{/*
###############################################################################
# Licensed Materials - Property of IBM.
# Copyright IBM Corporation 2018. All Rights Reserved.
# U.S. Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
#
# Contributors:
#  IBM Corporation - initial API and implementation
###############################################################################
*/}}
{{/* vim: set filetype=mustache: */}}

{{/*
Just to pass linting
*/}}
{{ define "redis.accessSecretName.emptyTemplate" }}
{{ end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "redis.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "redis.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a hostname of the default fully qualified app name.
We truncate at 24 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "redis.hostname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" | upper | replace "-" "_" -}}
{{- end -}}

{{- /*
Credit: @technosophos
https://github.com/technosophos/common-chart/
labels.standard prints the standard Helm labels.
The standard labels are frequently used in metadata.
*/ -}}
{{- define "redis.labels.standard" -}}
app: {{ template "redis.fullname" . }}
chart: {{ template "redis.chartref" . }}
release: {{ .Release.Name | quote }}
heritage: {{ .Release.Service | quote }}
{{- end -}}

{{- /*
Credit: @technosophos
https://github.com/technosophos/common-chart/
chartref prints a chart name and version.
It does minimal escaping for use in Kubernetes labels.
Example output:
  zookeeper-1.2.3
  wordpress-3.2.1_20170219
*/ -}}
{{- define "redis.chartref" -}}
  {{- replace "+" "_" .Chart.Version | printf "%s-%s" .Chart.Name -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "redis-ha.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "redis.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}


{{/*
  Generates the redis password
*/}}
{{- define "redis.password" -}}
  {{- if .Values.password -}}
    {{- .Values.password -}}
  {{- else if .Values.passwordTemplate -}}
    {{- include .Values.passwordTemplate . -}}
  {{- end -}}
{{- end -}}

{{/*
  Generates the pull secret name
*/}}
{{- define "redis.pullSecret" -}}
  {{- if .Values.image.pullSecret -}}
    {{- .Values.image.pullSecret -}}
  {{- else if .Values.pullSecretTemplate -}}
    {{- include .Values.pullSecretTemplate . -}}
  {{- end -}}
{{- end -}}

{{ define "redis.image.assemble" -}}
  {{- $params := . -}}
  {{- $context := index $params 0 -}}
  {{- $repository := index $params 1 -}}
  {{- $name := index $params 2 -}}
  {{- $tag := index $params 3 -}}
  {{ list $repository $name | join "/" | clean }}:{{ $tag }}
{{- end }}

{{ define "redis.image.server" -}}
  {{- $params := (list . .Values.image.repository .Values.image.name .Values.image.tag) -}}
  {{ include "redis.image.assemble" ($params) }}
{{- end }}
