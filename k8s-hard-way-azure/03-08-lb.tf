resource "azurerm_lb" "k8s_lb" {
  name                = "kubernetes-lb"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.k8s_pip.id
  }
}

resource "azurerm_lb_backend_address_pool" "k8s_lb_bapool" {
  loadbalancer_id = azurerm_lb.k8s_lb.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "k8s_lb_probe" {
  loadbalancer_id = azurerm_lb.k8s_lb.id
  name            = "kubernetes-apiserver-probe"
  port            = 6443
  protocol        = "Tcp"
}


resource "azurerm_lb_rule" "example" {
  loadbalancer_id                = azurerm_lb.k8s_lb.id
  name                           = "LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 6443
  backend_port                   = 6443
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.k8s_lb_bapool.id]
  probe_id                       = azurerm_lb_probe.k8s_lb_probe.id
}