#!/usr/bin/env bash
export MSYS_NO_PATHCONV=1  # для Git Bash на Windows: не превращать /CN=... в путь
# пользователь:группа — группа попадает в поле O сертификата
for u in devops-admin:platform-admins sales-dev:sales-developers manager:viewers security-officer:security; do
  n=${u%%:*}; g=${u##*:}
  openssl req -new -newkey rsa:2048 -nodes -keyout $n.key -out $n.csr -subj "/CN=$n/O=$g" 2>/dev/null
  kubectl apply -f - <<YAML
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata: {name: $n}
spec: {request: $(base64 -w0 < $n.csr), signerName: kubernetes.io/kube-apiserver-client, usages: [client auth]}
YAML
  kubectl certificate approve $n
  kubectl get csr $n -o jsonpath='{.status.certificate}' | base64 -d > $n.crt
  kubectl config set-credentials $n --client-certificate=$n.crt --client-key=$n.key --embed-certs
  kubectl config set-context $n --cluster=minikube --user=$n
done
