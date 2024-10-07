#!/bin/bash

echo "Deploy the coredns cluster add-on"
#https://github.com/ivanfioravanti/kubernetes-the-hard-way-on-azure/issues/82

kubectl apply -f https://raw.githubusercontent.com/ivanfioravanti/kubernetes-the-hard-way-on-azure/master/deployments/coredns.yaml

sleep 180

echo "List the pods created by the kube-dns deployment"

kubectl get pods -l k8s-app=kube-dns -n kube-system

echo "Create a busybox deployment"

kubectl run busybox --image=busybox:1.28 --command -- sleep 3600

echo "List the pod created by the busybox deployment"

kubectl get pods -l run=busybox

echo "Retrieve the full name of the busybox pod"

POD_NAME=$(kubectl get pods -l run=busybox -o jsonpath="{.items[0].metadata.name}")

echo "Execute a DNS lookup for the kubernetes service inside the busybox pod"

kubectl exec -ti $POD_NAME -- nslookup kubernetes

