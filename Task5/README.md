# Задание 5. Сетевые политики

- `non-admin-api-allow.yaml` — две политики: трафик разрешён только внутри пар `front-end` ↔ `back-end-api` и `admin-front-end` ↔ `admin-back-end-api`

## Запуск

Нужен сетевой плагин с поддержкой политик, например Calico:

```shell
minikube start --cni=calico
for r in front-end back-end-api admin-front-end admin-back-end-api; do
  kubectl run $r-app --image=nginx --labels role=$r --expose --port 80
done
kubectl apply -f non-admin-api-allow.yaml
```

## Проверка

```shell
kubectl run test-$RANDOM --rm -it --image=alpine --labels role=front-end -- wget -qO- --timeout=2 http://back-end-api-app        # OK
kubectl run test-$RANDOM --rm -it --image=alpine --labels role=front-end -- wget -qO- --timeout=2 http://admin-back-end-api-app  # timeout
kubectl run test-$RANDOM --rm -it --image=alpine -- wget -qO- --timeout=2 http://back-end-api-app                                # timeout
```
