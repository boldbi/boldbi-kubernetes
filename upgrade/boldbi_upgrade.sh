version="$1"

[ -n "$version" ] || read -p 'Enter the version to upgrade: ' version

if [ -z "$version" ]
then
	echo "Version is empty."
else
	kubectl set image deployment/id-web-deployment id-web-container=gcr.io/boldbi-294612/boldbi-identity:$version --record
	kubectl set image deployment/id-api-deployment id-api-container=gcr.io/boldbi-294612/boldbi-identity-api:$version --record
	kubectl set image deployment/id-ums-deployment id-ums-container=gcr.io/boldbi-294612/boldbi-ums:$version --record
	kubectl set image deployment/bi-web-deployment bi-web-container=gcr.io/boldbi-294612/boldbi-server:$version --record
	kubectl set image deployment/bi-api-deployment bi-api-container=gcr.io/boldbi-294612/boldbi-server-api:$version --record
	kubectl set image deployment/bi-jobs-deployment bi-jobs-container=gcr.io/boldbi-294612/boldbi-server-jobs:$version --record
	kubectl set image deployment/bi-dataservice-deployment bi-dataservice-container=gcr.io/boldbi-294612/boldbi-designer:$version --record	
fi