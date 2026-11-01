locals {
  prefix = "${var.project_name}-${var.environment}"
  common_tags = {
    environment = var.environment
    project     = "azure-secure-devops-portfolio"
    managed_by  = "terraform"
    purpose     = "learning-demo"
  }
  # Azure storage names must be globally unique and 3-24 alphanumeric characters.
  storage_name = "st${substr(var.project_name, 0, 8)}${var.environment}${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  upper   = false
  special = false
}

resource "azurerm_resource_group" "demo" {
  name     = "${local.prefix}-rg"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_virtual_network" "demo" {
  name                = "${local.prefix}-vnet"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  address_space       = [var.vnet_cidr]
  tags                = local.common_tags
}

resource "azurerm_subnet" "app" {
  name                 = "snet-app"
  resource_group_name  = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.demo.name
  address_prefixes     = [var.app_subnet_cidr]
}

resource "azurerm_subnet" "ops" {
  name                 = "snet-ops"
  resource_group_name  = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.demo.name
  address_prefixes     = [var.ops_subnet_cidr]
}

resource "azurerm_network_security_group" "app" {
  name                = "${local.prefix}-app-nsg"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  tags                = local.common_tags

  # Defense in depth: no unsolicited incoming Internet traffic to this demo subnet.
  security_rule {
    name                       = "deny-internet-inbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" "ops" {
  name                = "${local.prefix}-ops-nsg"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
  tags                = local.common_tags

  security_rule {
    name                       = "deny-public-ssh-rdp"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["22", "3389"]
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "app" {
  subnet_id                 = azurerm_subnet.app.id
  network_security_group_id = azurerm_network_security_group.app.id
}

resource "azurerm_subnet_network_security_group_association" "ops" {
  subnet_id                 = azurerm_subnet.ops.id
  network_security_group_id = azurerm_network_security_group.ops.id
}

resource "azurerm_storage_account" "demo" {
  name                            = local.storage_name
  resource_group_name             = azurerm_resource_group.demo.name
  location                        = azurerm_resource_group.demo.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  min_tls_version                 = "TLS1_2"
  https_traffic_only_enabled      = true
  allow_nested_items_to_be_public = false
  public_network_access_enabled   = false
  shared_access_key_enabled       = false
  tags                            = local.common_tags
}
# Intentional: no private endpoint or public access path is provisioned.
# To actually use storage data, add an authorized network path + Entra RBAC.
# No VMs, public IPs, or paid application workloads are created.
