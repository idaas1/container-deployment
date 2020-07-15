{{/* vim: set filetype=mustache: */}}

{{/*
###############################################################################
# Licensed Materials - Property of IBM.
# Copyright IBM Corporation 2019. All Rights Reserved.
# U.S. Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
#
# Contributors:
#  IBM Corporation
###############################################################################
*/}}


{{- /*
Chart specific config file for SCH (Shared Configurable Helpers)

_sch-chart-config.tpl is a config file for the chart to specify additional 
values and/or override values defined in the sch/_config.tpl file.
*/ -}}

{{- define "isvaconfig.sch.chart.config.values" -}}
sch:
  chart:
    appName: "isvaconfig"
    config:
      servicename: "isvaconfig"
    metering:
      productName: "IBM Security Verify Access"
      productID: "5725-V90"
      productVersion: "10.0.0.0"
    nodeAffinity:
      nodeAffinityRequiredDuringScheduling:
        operator: In
        values:
        - amd64
{{- end -}}
