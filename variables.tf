variable "subscription_id" {
  description = "Your authorized Azure subscription ID; supply via a local tfvars file."
  type        = string
  sensitive   = true
}

variable "location" {
  description = "Azure deployment region"
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Deployment environment label"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "test"], var.environment)
    error_message = "This practice project permits only dev or test environments."
  }
}

variable "project_name" {
  description = "Short lowercase alphanumeric name used in resource naming"
  type        = string
  default     = "cloudops"
  validation {
    condition     = can(regex("^[a-z][a-z0-9]{2,9}$", var.project_name))
    error_message = "Use 3-10 lowercase letters/digits, starting with a letter."
  }
}

variable "vnet_cidr" {
  description = "CIDR of Azure VNet"
  type        = string
  default     = "10.42.0.0/16"
}

variable "app_subnet_cidr" {
  description = "CIDR of the application subnet"
  type        = string
  default     = "10.42.1.0/24"
}

variable "ops_subnet_cidr" {
  description = "CIDR of the operations subnet"
  type        = string
  default     = "10.42.2.0/24"
}
