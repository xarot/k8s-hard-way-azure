data "azurerm_resource_group" "keyvault_rg" {
  name = var.secrets_key_vault_rg
}

data "azurerm_key_vault" "keyvault" {
  name                = var.secrets_key_vault
  resource_group_name = data.azurerm_resource_group.keyvault_rg.name
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_resource_group" "vnet_rg" {
  name = var.vnet_resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  resource_group_name = data.azurerm_resource_group.vnet_rg.name
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  resource_group_name  = data.azurerm_resource_group.vnet_rg.name
}

# Password

resource "random_password" "vmpassword" {
  length  = 24
  special = true
}

# Data disks

resource "azurerm_managed_disk" "data_disk" {
  for_each = var.vm_data_disks != null ? {
    for index, disk in var.vm_data_disks : "${disk.name}" => { index : index, disk : disk }
  } : {}
  name                 = format("${var.vm_name}-dd-%03s", each.value.index + 1)
  resource_group_name  = data.azurerm_resource_group.rg.name
  location             = data.azurerm_resource_group.rg.location
  storage_account_type = each.value.disk.storage_account_type
  create_option        = "Empty"
  disk_size_gb         = each.value.disk.disk_size_gb
  tags                 = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# VM

resource "azurerm_linux_virtual_machine" "linux-vm" {
  admin_password               = var.vm_admin_password_disable ? null : azurerm_key_vault_secret.vmpassword.value
  admin_username               = var.vm_username
  location                     = var.location
  name                         = var.vm_name
  computer_name                = var.vm_computer_name == "" ? var.vm_name : var.vm_computer_name
  network_interface_ids        = [azurerm_network_interface.vm-nic.id]
  resource_group_name          = data.azurerm_resource_group.rg.name
  size                         = var.vm_size
  availability_set_id          = var.as_id
  proximity_placement_group_id = var.ppg_id

  source_image_reference {
    publisher = var.vm_image_publisher
    offer     = var.vm_image_offer
    sku       = var.vm_image_sku
    version   = var.vm_image_version
  }

  disable_password_authentication = var.vm_admin_password_disable

  dynamic "admin_ssh_key" {
    for_each = var.vm_admin_password_disable ? [1] : []
    content {
      public_key = var.ssh_public_key
      username   = var.vm_username
    }
  }

  os_disk {
    name                 = "${var.vm_name}-osdisk"
    caching              = var.vm_os_disk_caching
    storage_account_type = var.vm_os_disk_storage_type
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# Data disks attachment

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk" {
  for_each = var.vm_data_disks != null ? {
    for index, disk in var.vm_data_disks : "${disk.name}" => { index : index, disk : disk }
  } : {}
  managed_disk_id    = azurerm_managed_disk.data_disk[each.key].id
  virtual_machine_id = azurerm_linux_virtual_machine.linux-vm.id
  lun                = each.value.index
  caching            = "ReadWrite"
}

# PIP

resource "azurerm_public_ip" "vm-pip" {
  count               = var.create_pip ? 1 : 0
  name                = "${var.vm_name}-pip"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  sku                 = var.pip_sku
  allocation_method   = var.pip_sku == "Standard" ? var.pip_allocation_method : "Static"
  tags                = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# Virtual Machine NIC 

resource "azurerm_network_interface" "vm-nic" {
  name                 = "${var.vm_name}-nic0"
  resource_group_name  = data.azurerm_resource_group.rg.name
  location             = var.location
  enable_ip_forwarding = var.enable_ip_forwarding
  ip_configuration {
    name                          = "${var.vm_name}-nic0-ipconfig"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address            = var.private_ip_allocation_type == "Static" ? var.private_ip_address : null
    private_ip_address_allocation = var.private_ip_allocation_type
    public_ip_address_id          = var.create_pip ? azurerm_public_ip.vm-pip[0].id : ""
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

# KV Secret from password

resource "azurerm_key_vault_secret" "vmpassword" {

  key_vault_id = data.azurerm_key_vault.keyvault.id
  name         = "${var.vm_name}-password"
  value        = random_password.vmpassword.result

}

