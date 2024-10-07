resource "time_sleep" "dns_wait_120_seconds" {
  depends_on = [null_resource.bootstrapping_kubernetes_workers]

  create_duration = "120s"
}


resource "null_resource" "dns_addon" {
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = "./scripts/12-dns-addon.sh"
  }

  depends_on = [module.k8s-worker-vm1, module.k8s-worker-vm2, module.k8s-controller-vm1, module.k8s-controller-vm2, module.k8s-controller-vm3, time_sleep.vm_wait_60_seconds, null_resource.configuring_kubectl, time_sleep.dns_wait_120_seconds]
}