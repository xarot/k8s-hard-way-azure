resource "azurerm_availability_set" "k8s_controller_as" {
  name                = "controller-as"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = var.tags
}

resource "azurerm_availability_set" "k8s_worker_as" {
  name                = "worker-as"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = var.tags
}