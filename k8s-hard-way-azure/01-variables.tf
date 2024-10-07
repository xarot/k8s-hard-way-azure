variable "subscription_id" {}
variable "location" {}
variable "resource_group" {}
variable "tags" {}
variable "ssh_public_key" {}
variable "keyvault_name" {}
variable "vnets" {
  description = "Virtual Networks object"
  #type = any
  type = list(object({
    vnet_name      = string
    address_prefix = list(string)
    dns_servers    = list(string)
    subnets = list(object({
      subnet_name                   = string
      address_prefixes              = list(string)
      disable_nsg                   = optional(bool)
      disable_rt                    = optional(bool)
      disable_bgp_route_propagation = optional(bool)
      delegation = optional(list(object({
        name = optional(string)
        service_delegation = optional(object({
          name    = optional(string)
          actions = optional(list(string))
        }))
      })))
      nsg_inbound_rules  = list(list(string))
      nsg_outbound_rules = list(list(string))
      service_endpoints  = list(string)
      route_table_routes = list(object({
        name                   = string
        address_prefix         = string
        next_hop_type          = string
        next_hop_in_ip_address = optional(string)
      }))
    }))

  }))
}



