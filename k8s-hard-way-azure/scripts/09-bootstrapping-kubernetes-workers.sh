#!/bin/bash

for (( i=0; i<2; i++ ));
do

WORKER="worker-$i"
PUBLIC_IP_ADDRESS=$(az network public-ip show -g kubernetes \
  -n ${WORKER}-pip --query "ipAddress" -otsv)

ssh -o "StrictHostKeyChecking no" \
  kuberoot@${PUBLIC_IP_ADDRESS} \
  'bash -s' < ./scripts/09-kubernetes-workers.sh

done