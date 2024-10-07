output "virtual_machine_id" {
  value = azurerm_linux_virtual_machine.linux-vm.id
}
output "virtual_machine_name" {
  value = azurerm_linux_virtual_machine.linux-vm.name
}

output "vm_computer_name" {
  value = azurerm_linux_virtual_machine.linux-vm.computer_name
}

output "private_ip_address" {
  value = azurerm_network_interface.vm-nic.ip_configuration[0].private_ip_address
}

output "public_ip_address" {
  value = azurerm_public_ip.vm-pip[0].ip_address
}

output "network_interface_id" {
  value = azurerm_network_interface.vm-nic.id
}