resource "azurerm_public_ip" "k8s_pip" {
  name                = "kubernetes-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

output "public_ip_address" {
  value = azurerm_public_ip.k8s_pip.ip_address
}