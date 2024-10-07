module "k8s-controller-vm1" {
  source                     = "./modules/vm-linux"
  location                   = "westeurope"
  secrets_key_vault          = azurerm_key_vault.k8s-secrets-kv.name
  secrets_key_vault_rg       = azurerm_resource_group.rg.name
  virtual_network_name       = module.vnet.virtual_network_names[0]
  subnet_name                = "kubernetes-subnet"
  vnet_resource_group_name   = azurerm_resource_group.rg.name
  resource_group_name        = azurerm_resource_group.rg.name
  vm_name                    = "controller-0"
  vm_computer_name           = "controller-0"
  create_pip                 = true
  pip_sku                    = "Standard"
  pip_allocation_method      = "Static"
  private_ip_allocation_type = "Static"
  private_ip_address         = "10.240.0.10"
  enable_ip_forwarding       = true
  tags                       = var.tags
  vm_image_publisher         = "Canonical"
  vm_image_offer             = "UbuntuServer"
  vm_image_sku               = "18.04-LTS"
  vm_image_version           = "latest"
  vm_os_disk_size            = "80"
  vm_size                    = "Standard_B1s"
  vm_username                = "kuberoot"
  vm_admin_password_disable  = true
  vm_os_disk_caching         = "ReadWrite"
  vm_os_disk_storage_type    = "Standard_LRS"
  ssh_public_key             = var.ssh_public_key
  as_id                      = azurerm_availability_set.k8s_controller_as.id


  vm_data_disks = []
  depends_on = [
    azurerm_resource_group.rg,
    azurerm_key_vault.k8s-secrets-kv,
    module.vnet
  ]

}

module "k8s-controller-vm2" {
  source                     = "./modules/vm-linux"
  location                   = "westeurope"
  secrets_key_vault          = azurerm_key_vault.k8s-secrets-kv.name
  secrets_key_vault_rg       = azurerm_resource_group.rg.name
  virtual_network_name       = module.vnet.virtual_network_names[0]
  subnet_name                = "kubernetes-subnet"
  vnet_resource_group_name   = azurerm_resource_group.rg.name
  resource_group_name        = azurerm_resource_group.rg.name
  vm_name                    = "controller-1"
  vm_computer_name           = "controller-1"
  create_pip                 = true
  pip_sku                    = "Standard"
  pip_allocation_method      = "Static"
  private_ip_allocation_type = "Static"
  private_ip_address         = "10.240.0.11"
  enable_ip_forwarding       = true
  tags                       = var.tags
  vm_image_publisher         = "Canonical"
  vm_image_offer             = "UbuntuServer"
  vm_image_sku               = "18.04-LTS"
  vm_image_version           = "latest"
  vm_os_disk_size            = "80"
  vm_size                    = "Standard_B1s"
  vm_username                = "kuberoot"
  vm_admin_password_disable  = true
  vm_os_disk_caching         = "ReadWrite"
  vm_os_disk_storage_type    = "Standard_LRS"
  ssh_public_key             = var.ssh_public_key
  as_id                      = azurerm_availability_set.k8s_controller_as.id


  vm_data_disks = []
  depends_on = [
    azurerm_resource_group.rg,
    azurerm_key_vault.k8s-secrets-kv,
    module.vnet
  ]

}

module "k8s-controller-vm3" {
  source                     = "./modules/vm-linux"
  location                   = "westeurope"
  secrets_key_vault          = azurerm_key_vault.k8s-secrets-kv.name
  secrets_key_vault_rg       = azurerm_resource_group.rg.name
  virtual_network_name       = module.vnet.virtual_network_names[0]
  subnet_name                = "kubernetes-subnet"
  vnet_resource_group_name   = azurerm_resource_group.rg.name
  resource_group_name        = azurerm_resource_group.rg.name
  vm_name                    = "controller-2"
  vm_computer_name           = "controller-2"
  create_pip                 = true
  pip_sku                    = "Standard"
  pip_allocation_method      = "Static"
  private_ip_allocation_type = "Static"
  private_ip_address         = "10.240.0.12"
  enable_ip_forwarding       = true
  tags                       = var.tags
  vm_image_publisher         = "Canonical"
  vm_image_offer             = "UbuntuServer"
  vm_image_sku               = "18.04-LTS"
  vm_image_version           = "latest"
  vm_os_disk_size            = "80"
  vm_size                    = "Standard_B1s"
  vm_username                = "kuberoot"
  vm_admin_password_disable  = true
  vm_os_disk_caching         = "ReadWrite"
  vm_os_disk_storage_type    = "Standard_LRS"
  ssh_public_key             = var.ssh_public_key
  as_id                      = azurerm_availability_set.k8s_controller_as.id


  vm_data_disks = []
  depends_on = [
    azurerm_resource_group.rg,
    azurerm_key_vault.k8s-secrets-kv,
    module.vnet
  ]

}

module "k8s-worker-vm1" {
  source                     = "./modules/vm-linux"
  location                   = "westeurope"
  secrets_key_vault          = azurerm_key_vault.k8s-secrets-kv.name
  secrets_key_vault_rg       = azurerm_resource_group.rg.name
  virtual_network_name       = module.vnet.virtual_network_names[0]
  subnet_name                = "kubernetes-subnet"
  vnet_resource_group_name   = azurerm_resource_group.rg.name
  resource_group_name        = azurerm_resource_group.rg.name
  vm_name                    = "worker-0"
  vm_computer_name           = "worker-0"
  create_pip                 = true
  pip_sku                    = "Standard"
  pip_allocation_method      = "Static"
  private_ip_allocation_type = "Static"
  private_ip_address         = "10.240.0.20"
  enable_ip_forwarding       = true
  tags                       = { pod_cidr = "10.200.0.0/24" }
  vm_image_publisher         = "Canonical"
  vm_image_offer             = "UbuntuServer"
  vm_image_sku               = "18.04-LTS"
  vm_image_version           = "latest"
  vm_os_disk_size            = "80"
  vm_size                    = "Standard_B1s"
  vm_username                = "kuberoot"
  vm_admin_password_disable  = true
  vm_os_disk_caching         = "ReadWrite"
  vm_os_disk_storage_type    = "Standard_LRS"
  ssh_public_key             = var.ssh_public_key
  as_id                      = azurerm_availability_set.k8s_worker_as.id


  vm_data_disks = []
  depends_on = [
    azurerm_resource_group.rg,
    azurerm_key_vault.k8s-secrets-kv,
    module.vnet
  ]

}

module "k8s-worker-vm2" {
  source                     = "./modules/vm-linux"
  location                   = "westeurope"
  secrets_key_vault          = azurerm_key_vault.k8s-secrets-kv.name
  secrets_key_vault_rg       = azurerm_resource_group.rg.name
  virtual_network_name       = module.vnet.virtual_network_names[0]
  subnet_name                = "kubernetes-subnet"
  vnet_resource_group_name   = azurerm_resource_group.rg.name
  resource_group_name        = azurerm_resource_group.rg.name
  vm_name                    = "worker-1"
  vm_computer_name           = "worker-1"
  create_pip                 = true
  pip_sku                    = "Standard"
  pip_allocation_method      = "Static"
  private_ip_allocation_type = "Static"
  private_ip_address         = "10.240.0.21"
  enable_ip_forwarding       = true
  tags                       = { pod_cidr = "10.200.1.0/24" }
  vm_image_publisher         = "Canonical"
  vm_image_offer             = "UbuntuServer"
  vm_image_sku               = "18.04-LTS"
  vm_image_version           = "latest"
  vm_os_disk_size            = "80"
  vm_size                    = "Standard_B1s"
  vm_username                = "kuberoot"
  vm_admin_password_disable  = true
  vm_os_disk_caching         = "ReadWrite"
  vm_os_disk_storage_type    = "Standard_LRS"
  ssh_public_key             = var.ssh_public_key
  as_id                      = azurerm_availability_set.k8s_worker_as.id


  vm_data_disks = []
  depends_on = [
    azurerm_resource_group.rg,
    azurerm_key_vault.k8s-secrets-kv,
    module.vnet
  ]

}

resource "azurerm_network_interface_backend_address_pool_association" "bapool_controller_1_lb_association" {
  network_interface_id    = module.k8s-controller-vm1.network_interface_id
  ip_configuration_name   = "controller-0-nic0-ipconfig"
  backend_address_pool_id = azurerm_lb_backend_address_pool.k8s_lb_bapool.id
}

resource "azurerm_network_interface_backend_address_pool_association" "bapool_controller_2_lb_association" {
  network_interface_id    = module.k8s-controller-vm2.network_interface_id
  ip_configuration_name   = "controller-1-nic0-ipconfig"
  backend_address_pool_id = azurerm_lb_backend_address_pool.k8s_lb_bapool.id
}

resource "azurerm_network_interface_backend_address_pool_association" "bapool_controller_3_lb_association" {
  network_interface_id    = module.k8s-controller-vm3.network_interface_id
  ip_configuration_name   = "controller-2-nic0-ipconfig"
  backend_address_pool_id = azurerm_lb_backend_address_pool.k8s_lb_bapool.id
}
