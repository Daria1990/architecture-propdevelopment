#!/usr/bin/env bash
kubectl create clusterrolebinding platform-admins --clusterrole=platform-admin --group=platform-admins
kubectl create clusterrolebinding viewers         --clusterrole=viewer         --group=viewers
kubectl create clusterrolebinding security        --clusterrole=secrets-reader --group=security
kubectl create clusterrolebinding security-view   --clusterrole=viewer         --group=security
for ns in sales zhku finance data; do
  kubectl create rolebinding developers -n $ns --role=developer --group=$ns-developers
done
