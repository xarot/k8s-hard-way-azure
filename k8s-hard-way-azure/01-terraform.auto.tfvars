subscription_id = "ADD-YOUR-SUBSCRIPTION-ID-HERE" 
location        = "westeurope" #location for resources
resource_group  = "kubernetes" #resource group name for deployment
keyvault_name   = "ik-kvk8stest003" #keyvault name or use your own if this is already taken
ssh_public_key  = "Add your public key here ssh-rsa..." #add your public key from the key pair you use for connecting to VMs
tags = {
  Owner = "YOUR-NAME"
}

vnets = [
  {
    vnet_name      = "kubernetes-vnet"
    address_prefix = ["10.240.0.0/16"]
    dns_servers    = []
    subnets = [
      {
        subnet_name      = "kubernetes-subnet"
        address_prefixes = ["10.240.0.0/24"]
        delegation       = []
        nsg_inbound_rules = [
          ["Allow_Inbound_SSH", "1000", "Inbound", "Allow", "Tcp", "22", "*", "*"],
          ["Allow_Inbound_6443", "1001", "Inbound", "Allow", "Tcp", "6443", "*", "*"],
          #   ["Allow_Inbound_TCP__10_240_0_0_16_to_10_240_0_0_24", "110", "Inbound", "Allow", "Tcp", "*", "10.240.0.0/16", "10.240.0.0/24"],
          #   ["Allow_Inbound_TCP_10_240_0_0_24_to_10_240_0_0_16", "120", "Inbound", "Allow", "Tcp", "*", "10.240.0.0/24", "10.240.0.0/16"],
          #   ["Allow_Inbound_UDP_10_200_0_0_16_to_10_240_0_0_24", "130", "Inbound", "Allow", "Udp", "*", "10.200.0.0/16", "10.240.0.0/24"],
          #   ["Allow_Inbound_UDP_10_200_0_0_16_to_10_240_0_0_16", "140", "Inbound", "Allow", "Udp", "*", "10.240.0.0/24", "10.240.0.0/16"],
          #   ["Allow_Inbound_ICMP_10_200_0_0_16_to_10_240_0_0_24", "150", "Inbound", "Allow", "Icmp", "*", "10.200.0.0/16", "10.240.0.0/24"],
          #   ["Allow_Inbound_ICMP_10_240_0_0_24_to_10_200_0_0_16", "160", "Inbound", "Allow", "Icmp", "*", "10.240.0.0/24", "10.200.0.0/16"],
          #   ["Allow_Inbound_SSH_any_to_10_240_0_0_24", "170", "Inbound", "Allow", "Tcp", "22", "0.0.0.0/0", "10.240.0.0/24"],
          #   ["Allow_Inbound_ApiServer_6443_any_to_10_240_0_0_24", "180", "Inbound", "Allow", "Tcp", "6443", "0.0.0.0/0", "10.240.0.0/24"],
          #   ["Allow_Inbound_ICMP_any_to_10_240_0_0_24", "190", "Inbound", "Allow", "Icmp", "*", "0.0.0.0/0", "10.240.0.0/24"],
          #   ["Allow_Inbound_homeinternet_", "200", "Inbound", "Allow", "Tcp", "*", "", "*"],
        ]
        nsg_outbound_rules = []
        service_endpoints  = []
        route_table_routes = [
          {
            name                   = "kubernetes-route-10-200-0-0-24",
            address_prefix         = "10.200.0.0/24",
            next_hop_type          = "VirtualAppliance"
            next_hop_in_ip_address = "10.240.0.20"
          },
          {
            name                   = "kubernetes-route-10-200-1-0-24",
            address_prefix         = "10.200.1.0/24",
            next_hop_type          = "VirtualAppliance"
            next_hop_in_ip_address = "10.240.0.21"
          }
        ]
      }
    ]
  }
]