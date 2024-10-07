locals {
  subnets = flatten([
    for vnet_key, vnet_value in var.vnets : [
      for subnet_key, subnet_value in vnet_value.subnets : {
        vnet_key                      = vnet_key
        vnet_name                     = vnet_value["vnet_name"]
        subnet_key                    = subnet_key
        subnet_name                   = lookup(subnet_value, "subnet_name", [])
        subnet_address_prefixes       = subnet_value["address_prefixes"]
        delegation                    = lookup(subnet_value, "delegation", [])
        nsg_inbound_rules             = lookup(subnet_value, "nsg_inbound_rules", [])
        nsg_outbound_rules            = lookup(subnet_value, "nsg_outbound_rules", [])
        route_table_routes            = lookup(subnet_value, "route_table_routes", [])
        disable_bgp_route_propagation = lookup(subnet_value, "disable_bgp_route_propagation", false)
        disable_nsg                   = lookup(subnet_value, "disable_nsg", false)
        disable_rt                    = lookup(subnet_value, "disable_rt", false)
        service_endpoints             = lookup(subnet_value, "service_endpoints", [])
      }
    ]
  ])
}

data "azurerm_resource_group" "vnet_resource_group" {
  name = var.resource_group_name
}

resource "azurerm_virtual_network" "vnet" {

  for_each            = { for vnet in var.vnets : "${vnet.vnet_name}" => vnet }
  name                = each.value.vnet_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.vnet_resource_group.name
  address_space       = each.value.address_prefix
  dns_servers         = each.value.dns_servers
  depends_on = [
    data.azurerm_resource_group.vnet_resource_group
  ]
}

resource "azurerm_subnet" "snet" {
  for_each             = { for subnet in local.subnets : "${subnet.vnet_name}.${subnet.subnet_name}" => subnet }
  resource_group_name  = data.azurerm_resource_group.vnet_resource_group.name
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  address_prefixes     = each.value.subnet_address_prefixes
  service_endpoints    = each.value.service_endpoints
  dynamic "delegation" {
    for_each = lookup(each.value, "delegation", [])
    content {
      name = lookup(delegation.value, "name", null)
      service_delegation {
        name    = lookup(delegation.value.service_delegation, "name", null)
        actions = lookup(delegation.value.service_delegation, "actions", null)
      }
    }
  }
  depends_on = [
    azurerm_virtual_network.vnet
  ]
}

resource "azurerm_network_security_group" "nsg" {
  for_each            = { for subnet in local.subnets : "${subnet.vnet_name}.${subnet.subnet_name}" => subnet if subnet.disable_nsg != true }
  name                = "nsg-${each.value.subnet_name}"
  resource_group_name = data.azurerm_resource_group.vnet_resource_group.name
  location            = var.location
  tags                = var.tags
  dynamic "security_rule" {
    for_each = concat(lookup(each.value, "nsg_inbound_rules", []), lookup(each.value, "nsg_outbound_rules", []))
    content {
      name                       = security_rule.value[0] == "" ? "Default" : security_rule.value[0]
      priority                   = security_rule.value[1] == "" ? "1000" : security_rule.value[1]
      direction                  = security_rule.value[2] == "" ? "Inbound" : security_rule.value[2]
      access                     = security_rule.value[3] == "" ? "Allow" : security_rule.value[3]
      protocol                   = security_rule.value[4] == "" ? "Tcp" : security_rule.value[4]
      source_port_range          = "*"
      destination_port_range     = security_rule.value[5] == "" ? "*" : security_rule.value[5]
      source_address_prefix      = security_rule.value[6] == "" ? element(each.value.subnet_address_prefixes, 0) : security_rule.value[6]
      destination_address_prefix = security_rule.value[7] == "" ? element(each.value.subnet_address_prefixes, 0) : security_rule.value[7]
      description                = "${security_rule.value[2]}_Port_${security_rule.value[5]}"
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg-association" {
  for_each                  = { for subnet in local.subnets : "${subnet.vnet_name}.${subnet.subnet_name}" => subnet if subnet.disable_nsg != true }
  subnet_id                 = azurerm_subnet.snet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}

resource "azurerm_route_table" "rt" {
  for_each                      = { for subnet in local.subnets : "${subnet.vnet_name}.${subnet.subnet_name}" => subnet if subnet.disable_rt != true }
  name                          = "rt-${each.value.subnet_name}"
  resource_group_name           = data.azurerm_resource_group.vnet_resource_group.name
  location                      = var.location
  disable_bgp_route_propagation = each.value.disable_bgp_route_propagation
  tags                          = var.tags

  dynamic "route" {
    for_each = lookup(each.value, "route_table_routes", [])
    content {
      name                   = lookup(route.value, "name", null)
      address_prefix         = lookup(route.value, "address_prefix", null)
      next_hop_type          = lookup(route.value, "next_hop_type", null)
      next_hop_in_ip_address = lookup(route.value, "next_hop_type") == "VirtualAppliance" ? lookup(route.value, "next_hop_in_ip_address") : null
    }
  }
}

resource "azurerm_subnet_route_table_association" "rt-association" {
  for_each       = { for subnet in local.subnets : "${subnet.vnet_name}.${subnet.subnet_name}" => subnet if subnet.disable_rt != true }
  subnet_id      = azurerm_subnet.snet[each.key].id
  route_table_id = azurerm_route_table.rt[each.key].id
}

