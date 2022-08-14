#!/usr/bin/env bash
# Copyright (c) Syncfusion Inc. All rights reserved.
#

while [ $# -gt 0 ]; do
  case "$1" in
    --version=*)
      version="${1#*=}"
      ;;
    --namespace=*)
      namespace="${1#*=}"
      ;;
    *)
  esac
  shift
done

[ -n "$version" ] || read -p 'Enter the version to upgrade: ' version

if [ -z "$version" ]
then
	echo "Version is empty."
else	
	if [ -z "$namespace" ]
	then
		namespace="default"
	fi
	
	kubectl set image deployment/id-web-deployment id-web-container=gcr.io/boldbi-294612/bold-identity:$version --namespace=$namespace --record 
	kubectl set image deployment/id-api-deployment id-api-container=gcr.io/boldbi-294612/bold-identity-api:$version --namespace=$namespace --record 
	kubectl set image deployment/id-ums-deployment id-ums-container=gcr.io/boldbi-294612/bold-ums:$version --namespace=$namespace --record 
	kubectl set image deployment/bi-web-deployment bi-web-container=gcr.io/boldbi-294612/boldbi-server:$version --namespace=$namespace --record 
	kubectl set image deployment/bi-api-deployment bi-api-container=gcr.io/boldbi-294612/boldbi-server-api:$version --namespace=$namespace --record 
	kubectl set image deployment/bi-jobs-deployment bi-jobs-container=gcr.io/boldbi-294612/boldbi-server-jobs:$version --namespace=$namespace --record 
	kubectl set image deployment/bi-dataservice-deployment bi-dataservice-container=gcr.io/boldbi-294612/boldbi-designer:$version --namespace=$namespace --record 
fi
