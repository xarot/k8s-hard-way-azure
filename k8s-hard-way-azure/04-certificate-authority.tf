resource "time_sleep" "vm_wait_60_seconds" {
  depends_on = [module.k8s-worker-vm1, module.k8s-worker-vm2, module.k8s-controller-vm1, module.k8s-controller-vm2, module.k8s-controller-vm3]

  create_duration = "60s"
}


resource "null_resource" "certificate_authority" {
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = "./scripts/04-certificate-authority.sh"
  }

  depends_on = [module.k8s-worker-vm1, module.k8s-worker-vm2, module.k8s-controller-vm1, module.k8s-controller-vm2, module.k8s-controller-vm3, time_sleep.vm_wait_60_seconds]
}

