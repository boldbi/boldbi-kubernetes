#!/usr/bin/env bash
# Copyright (c) Syncfusion Inc. All rights reserved.
#

while [ $# -gt 0 ]; do
  case "$1" in
    --bi_version=*)
      bi_version="${1#*=}"
      ;;
	--reports_version=*)
      reports_version="${1#*=}"
      ;;
    --namespace=*)
      namespace="${1#*=}"
      ;;
    *)
  esac
  shift
done

[ -n "$bi_version" ] || read -p 'Enter the Bold BI version to upgrade: ' bi_version
[ -n "$reports_version" ] || read -p 'Enter the Bold Reports version to upgrade: ' reports_version

	
if [ -z "$namespace" ]
then
	namespace="default"
fi

## Upgrade Bold BI
kubectl set image deployment/id-web-deployment id-web-container=gcr.io/boldbi-294612/bold-identity:$bi_version --namespace=$namespace --record 
kubectl set image deployment/id-api-deployment id-api-container=gcr.io/boldbi-294612/bold-identity-api:$bi_version --namespace=$namespace --record 
kubectl set image deployment/id-ums-deployment id-ums-container=gcr.io/boldbi-294612/bold-ums:$bi_version --namespace=$namespace --record 
kubectl set image deployment/bi-web-deployment bi-web-container=gcr.io/boldbi-294612/boldbi-server:$bi_version --namespace=$namespace --record 
kubectl set image deployment/bi-api-deployment bi-api-container=gcr.io/boldbi-294612/boldbi-server-api:$bi_version --namespace=$namespace --record 
kubectl set image deployment/bi-jobs-deployment bi-jobs-container=gcr.io/boldbi-294612/boldbi-server-jobs:$bi_version --namespace=$namespace --record 
kubectl set image deployment/bi-dataservice-deployment bi-dataservice-container=gcr.io/boldbi-294612/boldbi-designer:$bi_version --namespace=$namespace --record

## Upgrade Bold Reports
kubectl set image deployment/reports-web-deployment reports-web-container=gcr.io/boldreports/boldreports-server:$reports_version --namespace=$namespace --record 
kubectl set image deployment/reports-api-deployment reports-api-container=gcr.io/boldreports/boldreports-server-api:$reports_version --namespace=$namespace --record 
kubectl set image deployment/reports-jobs-deployment reports-jobs-container=gcr.io/boldreports/boldreports-server-jobs:$reports_version --namespace=$namespace --record 
kubectl set image deployment/reports-reportservice-deployment reports-reportservice-container=gcr.io/boldreports/boldreports-designer:$reports_version --namespace=$namespace --record
