#!/bin/bash

CONTROLLER="controller-0"
PUBLIC_IP_ADDRESS=$(az network public-ip show -g kubernetes \
  -n ${CONTROLLER}-pip --query "ipAddress" -otsv)

ssh -o "StrictHostKeyChecking no" \
  kuberoot@${PUBLIC_IP_ADDRESS} \
  'bash -s' < ./scripts/09-kubectl-check-nodes.sh

