#!/bin/bash

echo "Create the CA configuration file"

cat > ca-config.json <<EOF
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}
EOF

echo "Create the CA certificate signing request"

cat > ca-csr.json <<EOF
{
  "CN": "Kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IT",
      "L": "Milan",
      "O": "Kubernetes",
      "OU": "MI",
      "ST": "Italy"
    }
  ]
}
EOF

echo "Generate the CA certificate and private key"

cfssl gencert -initca ca-csr.json | cfssljson -bare ca

echo "Create the admin client certificate signing request"

cat > admin-csr.json <<EOF
{
  "CN": "admin",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IT",
      "L": "Milan",
      "O": "system:masters",
      "OU": "Kubernetes The Hard Way",
      "ST": "Italy"
    }
  ]
}
EOF

echo "Generate the admin client certificate and private key"

cfssl gencert \
-ca=ca.pem \
-ca-key=ca-key.pem \
-config=ca-config.json \
-profile=kubernetes \
admin-csr.json | cfssljson -bare admin

echo "Generate a certificate and private key for each Kubernetes worker node"  

for instance in worker-0 worker-1; do
cat > ${instance}-csr.json <<EOF
{
  "CN": "system:node:${instance}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IT",
      "L": "Milan",
      "O": "system:nodes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Italy"
    }
  ]
}
EOF

EXTERNAL_IP=$(az network public-ip show -g kubernetes \
  -n ${instance}-pip --query ipAddress -o tsv)

INTERNAL_IP=$(az vm show -d -n ${instance} -g kubernetes --query privateIps -o tsv)

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=${instance},${EXTERNAL_IP},${INTERNAL_IP} \
  -profile=kubernetes \
  ${instance}-csr.json | cfssljson -bare ${instance}
done

echo "Generate the kube-controller-manager client certificate and private key"

{

cat > kube-controller-manager-csr.json <<EOF
{
  "CN": "system:kube-controller-manager",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IT",
      "L": "Milan",
      "O": "system:kube-controller-manager",
      "OU": "Kubernetes The Hard Way",
      "ST": "Italy"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager

}

echo "Create the kube-proxy client certificate signing request"

cat > kube-proxy-csr.json <<EOF
{
  "CN": "system:kube-proxy",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IT",
      "L": "Milano",
      "O": "system:node-proxier",
      "OU": "Kubernetes The Hard Way",
      "ST": "Italy"
    }
  ]
}
EOF

echo "Generate the kube-proxy client certificate and private key"

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-proxy-csr.json | cfssljson -bare kube-proxy

echo "Generate the kube-scheduler client certificate and private key"

{

cat > kube-scheduler-csr.json <<EOF
{
  "CN": "system:kube-scheduler",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IT",
      "L": "Milan",
      "O": "system:kube-scheduler",
      "OU": "Kubernetes The Hard Way",
      "ST": "Italy"
    }
  ]
}
EOF



cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-scheduler-csr.json | cfssljson -bare kube-scheduler

}

echo "Retrieve the kubernetes-the-hard-way static IP address"

KUBERNETES_PUBLIC_ADDRESS=$(az network public-ip show -g kubernetes \
  -n kubernetes-pip --query "ipAddress" -o tsv)

echo "Create the Kubernetes API Server certificate signing request"  

  cat > kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IT",
      "L": "Milan",
      "O": "Kubernetes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Italy"
    }
  ]
}
EOF

echo "Generate the Kubernetes API Server certificate and private key"

KUBERNETES_HOSTNAMES=kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.svc.cluster.local

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=10.32.0.1,10.240.0.10,10.240.0.11,10.240.0.12,${KUBERNETES_PUBLIC_ADDRESS},127.0.0.1,${KUBERNETES_HOSTNAMES} \
  -profile=kubernetes \
  kubernetes-csr.json | cfssljson -bare kubernetes

echo "Generate the service-account certificate and private key"

{

cat > service-account-csr.json <<EOF
{
  "CN": "service-accounts",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "IT",
      "L": "Milan",
      "O": "Kubernetes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Italy"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  service-account-csr.json | cfssljson -bare service-account

}

echo "Copy the appropriate certificates and private keys to each worker instance"

for instance in worker-0 worker-1; do
  PUBLIC_IP_ADDRESS=$(az network public-ip show -g kubernetes \
    -n ${instance}-pip --query "ipAddress" -o tsv)

  scp -o StrictHostKeyChecking=no ca.pem ${instance}-key.pem ${instance}.pem kuberoot@${PUBLIC_IP_ADDRESS}:~/
done

echo "Copy the appropriate certificates and private keys to each controller instance"

for instance in controller-0 controller-1 controller-2; do
  PUBLIC_IP_ADDRESS=$(az network public-ip show -g kubernetes \
    -n ${instance}-pip --query "ipAddress" -o tsv)

  scp -o StrictHostKeyChecking=no ca.pem ca-key.pem kubernetes-key.pem kubernetes.pem \
    service-account-key.pem service-account.pem kuberoot@${PUBLIC_IP_ADDRESS}:~/
done

