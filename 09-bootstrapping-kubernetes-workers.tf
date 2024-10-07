
resource "null_resource" "bootstrapping_kubernetes_workers" {
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = "./scripts/09-bootstrapping-kubernetes-workers.sh"
  }

  depends_on = [null_resource.bootstrapping_kubernetes_control_plane]
}

resource "time_sleep" "workers_wait_30_seconds" {
  depends_on = [null_resource.bootstrapping_kubernetes_workers]

  create_duration = "60s"
}

resource "null_resource" "check_kubernetes_nodes" {
  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = "./scripts/09-kubernetes-nodes-check.sh"
  }

  depends_on = [module.k8s-worker-vm1, module.k8s-worker-vm2, module.k8s-controller-vm1, module.k8s-controller-vm2, module.k8s-controller-vm3, time_sleep.vm_wait_60_seconds, null_resource.bootstrapping_kubernetes_workers, time_sleep.workers_wait_30_seconds]
}