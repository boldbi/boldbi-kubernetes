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

	# Extracting the first two parts of the version number
	IFS='.' read -ra version_components <<< "$version"

	major=${version_components[0]}
	minor=${version_components[1]}

    # Concatenating the major and minor parts to compare
    combined_version="$major.$minor"

	if (( $(echo "$combined_version >= 7.2" | bc -l) )); then

		if ! kubectl get deployment bold-etl-deployment &>/dev/null; then
			read -p "Do you wish to enable Bold ETL service? [yes / no]: " yn
			case $yn in
			[Yy]* )
				[ -n "$app_base_url" ] || read -p 'Enter the app_base_url: ' app_base_url

				if [ ! -d "boldbi_7-2" ]; then mkdir boldbi_7-2; fi

				# Downloading deployment files.."
				if [ ! -f "boldbi_7-2/bold-etl.yaml" ]; then curl -o boldbi_7-2/bold-etl.yaml https://raw.githubusercontent.com/boldbi/boldbi-kubernetes/v$version/deploy/deployment.yaml; fi
				if [ ! -f "boldbi_7-2/ingress.yaml" ]; then curl -o boldbi_7-2/ingress.yaml https://raw.githubusercontent.com/boldbi/boldbi-kubernetes/v$version/deploy/ingress.yaml; fi

				# deployment file changes changes
				sed -i "s/<namespace>/$namespace/g" boldbi_7-2/bold-etl.yaml.yaml
				sed -i "s/<namespace>/$namespace/g" boldbi_7-2/ingress.yaml

				# applying new changes to cluster
				
				kubectl apply -f boldbi_7-2/bold-etl.yaml.yaml
				kubectl apply -f boldbi_7-2/hpa.yaml
				
				# Update ingress file with app_base url before applying.  		
				# Function to check if a string is an IP address
				is_ip() {
					[[ $1 =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]
				}
				
				# Extract the protocol and domain from the URL
				protocol=$(echo "$app_base_url" | awk -F: '{print $1}')
				domain=$(echo "$app_base_url" | awk -F[/:] '{print $4}')

				# Check if app_base_url is an IP address
				if is_ip "$domain"; then
					kubectl apply -f boldbi_7-2/ingress.yaml
				else
					# Update the Ingress file based on the protocol
					if [ "$protocol" == "http" ]; then
					sed -i -e "s|^ *- #host: example.com|  - host: $domain|" "boldbi_7-2/ingress.yaml"
					kubectl apply -f boldbi_7-2/ingress.yaml
					elif [ "$protocol" == "https" ]; then
					sed -i -e "s|^ *#tls|  tls|" "boldbi_7-2/ingress.yaml"
					sed -i -e "s|^ *#- hosts:|  - hosts:|" "boldbi_7-2/ingress.yaml"
					sed -i -e "s|^ *#- example.com|    - $domain|" "boldbi_7-2/ingress.yaml"
					sed -i -e "s|^ *#secretName: bold-tls|    secretName: bold-tls|" "boldbi_7-2/ingress.yaml"
					sed -i -e "s|^ *- #host: example.com|  - host: $domain|" "boldbi_7-2/ingress.yaml"
					kubectl apply -f boldbi_7-2/ingress.yaml
					fi
				fi
				kubectl set image deployment/id-web-deployment id-web-container=gcr.io/boldbi-294612/bold-identity:$version --namespace=$namespace --record 
				kubectl set image deployment/id-api-deployment id-api-container=gcr.io/boldbi-294612/bold-identity-api:$version --namespace=$namespace --record 
				kubectl set image deployment/id-ums-deployment id-ums-container=gcr.io/boldbi-294612/bold-ums:$version --namespace=$namespace --record 
				kubectl set image deployment/bi-web-deployment bi-web-container=gcr.io/boldbi-294612/boldbi-server:$version --namespace=$namespace --record 
				kubectl set image deployment/bi-api-deployment bi-api-container=gcr.io/boldbi-294612/boldbi-server-api:$version --namespace=$namespace --record 
				kubectl set image deployment/bi-jobs-deployment bi-jobs-container=gcr.io/boldbi-294612/boldbi-server-jobs:$version --namespace=$namespace --record 
				kubectl set image deployment/bi-dataservice-deployment bi-dataservice-container=gcr.io/boldbi-294612/boldbi-designer:$version --namespace=$namespace --record

				kubectl apply -f  https://raw.githubusercontent.com/boldbi/boldbi-kubernetes/v$version/deploy/version-config.yaml
				;;
			[Nn]* )

				;;
			* )
				echo "Please answer yes or no."
				;;
			esac
		else
				kubectl set image deployment/id-web-deployment id-web-container=gcr.io/boldbi-294612/bold-identity:$version --namespace=$namespace --record 
				kubectl set image deployment/id-api-deployment id-api-container=gcr.io/boldbi-294612/bold-identity-api:$version --namespace=$namespace --record 
				kubectl set image deployment/id-ums-deployment id-ums-container=gcr.io/boldbi-294612/bold-ums:$version --namespace=$namespace --record 
				kubectl set image deployment/bi-web-deployment bi-web-container=gcr.io/boldbi-294612/boldbi-server:$version --namespace=$namespace --record 
				kubectl set image deployment/bi-api-deployment bi-api-container=gcr.io/boldbi-294612/boldbi-server-api:$version --namespace=$namespace --record 
				kubectl set image deployment/bi-jobs-deployment bi-jobs-container=gcr.io/boldbi-294612/boldbi-server-jobs:$version --namespace=$namespace --record 
				kubectl set image deployment/bi-dataservice-deployment bi-dataservice-container=gcr.io/boldbi-294612/boldbi-designer:$version --namespace=$namespace --record
				kubectl set image deployment/bold-etl-deployment bold-etl-container=gcr.io/boldbi-294612/bold-etl:$version --namespace=$namespace --record
				
				kubectl apply -f  https://raw.githubusercontent.com/boldbi/boldbi-kubernetes/v$version/deploy/version-config.yaml		
		fi 
				
	else if (( $(echo "$combined_version < 7.2" | bc -l) )); then
				kubectl set image deployment/id-web-deployment id-web-container=gcr.io/boldbi-294612/bold-identity:$version --namespace=$namespace --record 
				kubectl set image deployment/id-api-deployment id-api-container=gcr.io/boldbi-294612/bold-identity-api:$version --namespace=$namespace --record 
				kubectl set image deployment/id-ums-deployment id-ums-container=gcr.io/boldbi-294612/bold-ums:$version --namespace=$namespace --record 
				kubectl set image deployment/bi-web-deployment bi-web-container=gcr.io/boldbi-294612/boldbi-server:$version --namespace=$namespace --record 
				kubectl set image deployment/bi-api-deployment bi-api-container=gcr.io/boldbi-294612/boldbi-server-api:$version --namespace=$namespace --record 
				kubectl set image deployment/bi-jobs-deployment bi-jobs-container=gcr.io/boldbi-294612/boldbi-server-jobs:$version --namespace=$namespace --record 
				kubectl set image deployment/bi-dataservice-deployment bi-dataservice-container=gcr.io/boldbi-294612/boldbi-designer:$version --namespace=$namespace --record
				
				kubectl apply -f  https://raw.githubusercontent.com/boldbi/boldbi-kubernetes/v$version/deploy/version-config.yaml

fi
