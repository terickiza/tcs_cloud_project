variable "resource_group_name" {
  description = "Nombre del Resource Group existente en Azure donde se desplegarán los recursos."
  type        = string
}

variable "vnet_e08" {
  description = "Nombre de la Virtual Network a crear."
  type        = string
  default     = "vnet-e08"
}

variable "vnet_e8_address_space" {
  description = "Espacio de direcciones CIDR para la VNet."
  type        = list(string)
  default     = ["10.58.0.0/16"]
}

variable "subnet_e08" {
  description = "Nombre de la Subnet principal."
  type        = string
  default     = "snet-e08"
}

variable "subnet_e8_prefix" {
  description = "Prefijo CIDR de la Subnet."
  type        = string
  default     = "10.58.1.0/24"
}

variable "tags" {
  description = "Tags comunes para los recursos."
  type        = map(string)
  default = {
    owner      = "erick.iza"
    managed-by = "terraform"
    env        = "lab"
  }
}