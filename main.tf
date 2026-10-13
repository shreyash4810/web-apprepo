locals {
  common_tags = {
    environment = "dev"
    managed_by  = "terraform"
  }
}

module "resource_group" {
  source   = "./modules/resource_group"
  name     = var.resource_group_name
  location = var.location
  tags     = local.common_tags
}

module "network" {
  source              = "./modules/network"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  vnet_name           = var.vnet_name
  address_space       = var.vnet_address_space
  subnets             = var.subnets
  tags                = local.common_tags
}

module "dev_vm" {
  source               = "./modules/linux_vm"
  name                 = var.vm_name
  resource_group_name  = module.resource_group.name
  location             = module.resource_group.location
  subnet_id            = module.network.subnet_ids["dev-app"]
  size                 = var.vm_size
  admin_username       = var.vm_admin_username
  admin_ssh_public_key = var.vm_admin_ssh_public_key
  tags                 = local.common_tags
}