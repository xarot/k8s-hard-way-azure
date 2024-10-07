variable "secrets_key_vault" {
  description = "Key Vault where to store secrets"
  type        = string
}

variable "secrets_key_vault_rg" {
  description = "Resource Group of the Key Vault where to store secrets"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group for the VM"
  default     = true
}

variable "vnet_resource_group_name" {
  description = "VNET resource group where the existing VNET"
  default     = true
}

variable "virtual_network_name" {
  description = "Name of the existing VNET"
  default     = true
}

variable "subnet_name" {
  description = "Subnet of the existing VNET subnet"
  default     = true
}

variable "location" {
  description = "Location of the resources"
  type        = string
}

variable "vm_name" {
  description = "Virtual Machine resource and computer name"
  type        = string
}

variable "vm_computer_name" {
  description = "Hostname (optional)"
  type        = string
  default     = ""
}

variable "create_pip" {
  description = "If public IP should be created"
  type        = string
}

variable "pip_allocation_method" {
  description = "Allocation method if public IP is created"
  type        = string
}

variable "pip_sku" {
  description = "SKU of the PIP if public IP is created"
  type        = string
}


variable "private_ip_address" {
  description = "Private IP address for the Virtual Machine if static IP is chosen"
  type        = string
}


variable "private_ip_allocation_type" {
  description = "Private IP address allocation method for Virtual Machine"
  type        = string
}
variable "vm_data_disks" {
  description = "Managed Data Disks object"
  type = list(object({
    name                 = optional(string)
    storage_account_type = optional(string)
    disk_size_gb         = optional(number)
  }))
  default = []
}

variable "vm_image_publisher" {
  description = "Name of the publisher of the image (az vm image list)"
  default     = "MicrosoftWindowsServer"
}

variable "vm_image_offer" {
  description = "The name of the offer (az vm image list)"
  default     = "WindowsServer"
}

variable "vm_image_sku" {
  description = "Image SKU to apply (az vm image list)"
  default     = "2019-Datacenter"
}

variable "vm_image_version" {
  description = "Version of the image to apply"
  default     = "latest"
}

variable "vm_os_disk_size" {
  description = "Size of the OS disk in GB"
  default     = 128
}
variable "vm_os_disk_caching" {
  description = "Caching setting of the OS disk"
  default     = "ReadWrite"
}
variable "vm_os_disk_storage_type" {
  description = "Storage Account type of the OS disk"
  default     = "Standard_LRS"
}

variable "vm_size" {
  description = "Specifies the size of the virtual machine"
  type        = string
  default     = "Standard_A2_V2"
}

variable "vm_username" {
  description = "Username of the Virtual Machine"
  type        = string
}

variable "vm_admin_password_disable" {
  description = "Disable Admin Password of the Virtual Machine and use public key?"
  type        = bool
}

variable "enable_ip_forwarding" {
  description = "Enable IP forwarding?"
  type        = bool
  default     = false
}

variable "ssh_public_key" {
  description = "SSH public key"
  type        = string
  default     = null
}

variable "ppg_id" {
  description = "ID of the proximity placement group"
  type        = string
  default     = null
}

variable "as_id" {
  description = "ID of the availability set"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
}

