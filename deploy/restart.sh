#!/usr/bin/env bash
# Copyright (c) Syncfusion Inc. All rights reserved.
#

while [ $# -gt 0 ]; do
  case "$1" in
    --apps=*)
      apps="${1#*=}"
      ;;
    --namespace=*)
      namespace="${1#*=}"
      ;;
    *)
  esac
  shift
done

if [ -z "$apps" ]
then
	apps="id-web,id-api,id-ums,bi-web,bi-api,bi-jobs,bi-dataservice"
fi

if [ -z "$namespace" ]
then
	namespace="default"
fi

IFS=',' read -r -a appnames <<< "$apps"

for app in "${appnames[@]}"
do

case $app in
"id-web")
kubectl -n $namespace rollout restart deployment id-web-deployment
;;
"id-api")
kubectl -n $namespace rollout restart deployment id-api-deployment
;;
"id-ums")
kubectl -n $namespace rollout restart deployment id-ums-deployment
;;
"bi-web")
kubectl -n $namespace rollout restart deployment bi-web-deployment
;;
"bi-api")
kubectl -n $namespace rollout restart deployment bi-api-deployment
;;
"bi-jobs")
kubectl -n $namespace rollout restart deployment bi-jobs-deployment
;;
"bi-dataservice")
kubectl -n $namespace rollout restart deployment bi-dataservice-deployment
;;
esac

done
