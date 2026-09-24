variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "azure-production-platform-rg"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "azure-production-vnet"
}