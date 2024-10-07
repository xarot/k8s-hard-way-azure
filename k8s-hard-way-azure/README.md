# kubernetes-hard-way-azure

Author: xarot/Ismo Korlin

This is following the steps in https://github.com/ivanfioravanti/kubernetes-the-hard-way-on-azure (steps 01-12).

Creates Kubernetes hard way configuration but does everything with Terraform for infra and scripts for configuring the certs, config files and VMs etc.

Should be working out of the box in WSL (or bash), but the step 12. DNS addon and Busybox may fail on first run as it seems to have some problem with the terminal (error: Unable to use a TTY - input is not a terminal or the right kind of file) and on the second run it is already running.

Terraform files are named as per the steps done in the doc above. For more security, update the VNET object NSG rules as desired as the VMs have public IPs.

To run:

1. Set variables in terraform.auto.tfvars
2. Terraform init
3. Terraform apply --auto-approve

To destroy:

1. Terraform destroy

Note. this may be using old version of TF and providers, so upgrade as you see fit. I found this old code from my home workstation and thought to share it for anyone wishes to try this with Terraform.
