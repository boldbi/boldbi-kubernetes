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
	
	if [[ "$version" == *"7.2"* ]]
	then
		[ -n "$app_base_url" ] || read -p 'Enter the app_base_url: ' app_base_url
		
		if [ ! -d "boldbi_7-2" ]; then mkdir boldbi_7-2; fi
		
		# Downloading deployment files.."
		if [ ! -f "boldbi_7-2/service.yaml" ]; then curl -o boldbi_7-2/service.yaml https://raw.githubusercontent.com/boldbi/boldbi-kubernetes/v7.2.8/deploy/service.yaml; fi
		if [ ! -f "boldbi_7-2/hpa.yaml" ]; then curl -o boldbi_7-2/hpa.yaml https://raw.githubusercontent.com/boldbi/boldbi-kubernetes/v7.2.8/deploy/hpa.yaml; fi
		if [ ! -f "boldbi_7-2/deployment.yaml" ]; then curl -o boldbi_7-2/deployment.yaml https://raw.githubusercontent.com/boldbi/boldbi-kubernetes/v7.2.8/deploy/deployment.yaml; fi
		if [ ! -f "boldbi_7-2/ingress.yaml" ]; then curl -o boldbi_7-2/service.yaml https://raw.githubusercontent.com/boldbi/boldbi-kubernetes/v7.2.8/deploy/ingress.yaml; fi

		# deployment file changes changes
		sed -i "s/<namespace>/$namespace/g" boldbi_7-2/service.yaml
		sed -i "s/<namespace>/$namespace/g" boldbi_7-2/hpa.yaml
		sed -i "s/<namespace>/$namespace/g" boldbi_7-2/deployment.yaml
		sed -i "s/<namespace>/$namespace/g" boldbi_7-2/ingress.yaml
		sed -i "s/<image_tag>/$version/g" boldbi_7-2/deployment.yaml
		sed -i "s,<application_base_url>,$app_base_url,g" boldbi_7-2/deployment.yaml

		# applying new changes to cluster

		kubectl apply -f boldbi_7-2/deployment.yaml
        kubectl apply -f boldbi_7-2/service.yaml
        kubectl apply -f boldbi_7-2/hpa.yaml
		kubectl apply -f boldbi_7-2/ingress.yaml
	fi
fi
