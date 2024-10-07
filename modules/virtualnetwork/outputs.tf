output "virtual_network_names" {
  value = values(azurerm_virtual_network.vnet).*.name
}

output "virtual_network_ids" {
  value = values(azurerm_virtual_network.vnet).*.id
}