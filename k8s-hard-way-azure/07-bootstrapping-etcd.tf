
resource "null_resource" "bootstrapping_etcd" {
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = "./scripts/07-bootstrapping-etcd.sh"
  }

  depends_on = [module.k8s-worker-vm1, module.k8s-worker-vm2, module.k8s-controller-vm1, module.k8s-controller-vm2, module.k8s-controller-vm3, time_sleep.vm_wait_60_seconds, null_resource.data_encryption_keys]
}