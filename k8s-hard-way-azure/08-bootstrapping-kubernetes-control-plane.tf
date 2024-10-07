
resource "null_resource" "bootstrapping_kubernetes_control_plane" {
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = "./scripts/08-bootstrapping-kubernetes-control-plane.sh"
  }

  depends_on = [null_resource.bootstrapping_etcd]
}

resource "null_resource" "check_kubernetes_control_plane" {
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = "./scripts/08-control-plane-check.sh"
  }

  depends_on = [module.k8s-worker-vm1, module.k8s-worker-vm2, module.k8s-controller-vm1, module.k8s-controller-vm2, module.k8s-controller-vm3, time_sleep.vm_wait_60_seconds, null_resource.bootstrapping_kubernetes_control_plane]
}

