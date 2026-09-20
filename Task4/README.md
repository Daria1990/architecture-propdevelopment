# Задание 4. Ролевой доступ к кластеру Kubernetes

- `roles.md` — таблица ролей, их прав и групп пользователей
- `1-create-users.sh` — создание пользователей (сертификаты через CSR API, группа в поле `O`)
- `2-create-roles.sh` — пространства имён по доменам и роли
- `3-create-bindings.sh` — привязка групп к ролям

## Запуск

```shell
minikube start
bash 1-create-users.sh
bash 2-create-roles.sh
bash 3-create-bindings.sh
```

## Проверка

```shell
kubectl auth can-i create deployments -n sales --context=sales-dev   # yes
kubectl auth can-i create deployments -n zhku  --context=sales-dev   # no
kubectl auth can-i get secrets -n zhku --context=manager             # no
kubectl auth can-i get secrets -n zhku --context=security-officer    # yes
```
