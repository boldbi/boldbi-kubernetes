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
	--app_base_url=*)
      app_base_url="${1#*=}"
      ;;
	--optional_libs=*)
      optional_libs="${1#*=}"
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
	
	if [[ "$version" == *"4.2"* ]]
	then
		[ -n "$app_base_url" ] || read -p 'Enter the app_base_url: ' app_base_url
		[ -n "$optional_libs" ] || read -p 'Enter the optional libraries needed to be installed [comma seperated]: ' optional_libs
		
		if [ ! -d "boldbi_4-2" ]; then mkdir boldbi_4-2; fi
		
		# Downloading deployment files.."
		if [ ! -f "boldbi_4-2/log4net_config.yaml" ]; then curl -o boldbi_4-2/log4net_config.yaml https://raw.githubusercontent.com/boldbi/boldbi-kubernetes/v4.2_dev/deploy/log4net_config.yaml; fi
		if [ ! -f "boldbi_4-2/deployment.yaml" ]; then curl -o boldbi_4-2/deployment.yaml https://raw.githubusercontent.com/boldbi/boldbi-kubernetes/v4.2_dev/deploy/deployment.yaml; fi
		
		# deployment file changes changes
		sed -i "s/namespace: boldbi/namespace: $namespace/g" boldbi_4-2/log4net_config.yaml
		sed -i "s/namespace: boldbi/namespace: $namespace/g" boldbi_4-2/deployment.yaml
		sed -i "s,<application_base_url>,$app_base_url,g" boldbi_4-2/deployment.yaml
		sed -i "s/<comma_separated_library_names>/$optional_libs/g" boldbi_4-2/deployment.yaml
		sed -i "s/boldbi-294612/boldbi-dev-296107/g" boldbi_4-2/deployment.yaml
		sed -i "s/4.1.36/$version/g" boldbi_4-2/deployment.yaml
		
		# applying new changes to cluster
		kubectl apply -f boldbi_4-2/log4net_config.yaml
		kubectl apply -f boldbi_4-2/deployment.yaml
	else	
		kubectl set image deployment/id-web-deployment id-web-container=gcr.io/boldbi-294612/boldbi-identity:$version --namespace=$namespace --record 
		kubectl set image deployment/id-api-deployment id-api-container=gcr.io/boldbi-294612/boldbi-identity-api:$version --namespace=$namespace --record 
		kubectl set image deployment/id-ums-deployment id-ums-container=gcr.io/boldbi-294612/boldbi-ums:$version --namespace=$namespace --record 
		kubectl set image deployment/bi-web-deployment bi-web-container=gcr.io/boldbi-294612/boldbi-server:$version --namespace=$namespace --record 
		kubectl set image deployment/bi-api-deployment bi-api-container=gcr.io/boldbi-294612/boldbi-server-api:$version --namespace=$namespace --record 
		kubectl set image deployment/bi-jobs-deployment bi-jobs-container=gcr.io/boldbi-294612/boldbi-server-jobs:$version --namespace=$namespace --record 
		kubectl set image deployment/bi-dataservice-deployment bi-dataservice-container=gcr.io/boldbi-294612/boldbi-designer:$version --namespace=$namespace --record 
	fi
fi