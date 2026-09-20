#!/usr/bin/env bash
NS="sales zhku finance data"
for ns in $NS; do kubectl create ns $ns; done

kubectl apply -f - <<'YAML'
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata: {name: platform-admin}
rules: [{apiGroups: ["*"], resources: ["*"], verbs: ["*"]}]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata: {name: viewer}
rules: [{apiGroups: ["", apps, batch], resources: [pods, pods/log, services, configmaps, events, deployments, jobs], verbs: [get, list, watch]}]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata: {name: secrets-reader}
rules: [{apiGroups: [""], resources: [secrets], verbs: [get, list, watch]}]
YAML

for ns in $NS; do kubectl apply -f - <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata: {name: developer, namespace: $ns}
rules: [{apiGroups: ["", apps, batch], resources: [pods, pods/log, services, configmaps, deployments, jobs], verbs: ["*"]}]
YAML
done
