
resource "null_resource" "data_encryption_keys" {
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = "./scripts/06-data-encryption-keys.sh"
  }

  depends_on = [module.k8s-worker-vm1, module.k8s-worker-vm2, module.k8s-controller-vm1, module.k8s-controller-vm2, module.k8s-controller-vm3, time_sleep.vm_wait_60_seconds, null_resource.kubernetes_configuration]
}