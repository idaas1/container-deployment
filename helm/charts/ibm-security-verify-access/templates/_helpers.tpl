
{{/*
Create the fully qualified name of the docker store secret.
We truncate at 63 chars because some Kubernetes name fields are limited to
this (by the DNS naming spec).
*/}}
{{- define "docker.credentials.secret" -}}
{{- printf "%s" .Values.global.imageCredentials.dockerSecret -}}
{{- end -}}

{{/*
Create the fully qualified name of the administration secret.
We truncate at 63 chars because some Kubernetes name fields are limited to
this (by the DNS naming spec).
*/}}
{{- define "admin.secret" -}}
{{- if .Values.global.container.adminSecret }}
{{- printf "%s" .Values.global.container.adminSecret -}}
{{- else }}
{{- printf "%s-admin" .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- end -}}

{{/*
Create the fully name of the administration secret key.
*/}}
{{- define "admin.secret.key" -}}
{{- printf "adminPassword" -}}
{{- end -}}

{{/*
Create the fully qualified name of the configuration service URL.
We truncate at 63 chars because some Kubernetes name fields are limited to
this (by the DNS naming spec).
*/}}
{{- define "config.service.url" -}}
{{- if .Values.global.configservicename -}}
{{- printf "https://%s:9443/shared_volume" (printf "%s" .Values.global.configservicename | trunc 63 | trimSuffix "-") -}}
{{- else }}
{{- printf "https://%s:9443/shared_volume" (printf "%s-isvaconfig" .Release.Name | trunc 63 | trimSuffix "-") -}}
{{- end }}
{{- end -}}

{{/*
Our well known ports.
*/}}
{{- define "admin.port" -}}
{{- printf "9443" -}}
{{- end -}}

{{- define "runtime.port" -}}
{{- printf "9443" -}}
{{- end -}}

{{- define "replica.port" -}}
{{- printf "9444" -}}
{{- end -}}
