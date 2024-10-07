module "vnet" {
  source              = "./modules/virtualnetwork"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  vnets               = var.vnets
  tags                = var.tags
  depends_on          = [azurerm_resource_group.rg]
}
