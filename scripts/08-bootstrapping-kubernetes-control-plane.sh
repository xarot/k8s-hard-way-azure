#!/bin/bash

for (( i=0; i<3; i++ ));
do

CONTROLLER="controller-$i"
PUBLIC_IP_ADDRESS=$(az network public-ip show -g kubernetes \
  -n ${CONTROLLER}-pip --query "ipAddress" -otsv)

ssh -o "StrictHostKeyChecking no" \
  kuberoot@${PUBLIC_IP_ADDRESS} \
  'bash -s' < ./scripts/08-control-plane.sh

done