data "terraform_remote_state" "network" {
  backend = "remote"
  config = {
    organization = var.org
    workspaces = {
      name = var.network_workspace
    }
  }
}

terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "vsphere" {
  # Configuration options
  // Requires ENV variable VSPHERE_USER 
  // Requires ENV variable VSPHERE_PASSWORD
  // Requires ENV variable VSPHERE_SERVER

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

# Deploy VM to On-Premises site
module "demo_vm" {
  source  = "app.terraform.io/cisco-dcn-ecosystem/demo_vm/vsphere"
  version = "0.0.2"

  vmware_dvs = data.terraform_remote_state.network.outputs.vmware_vds
  vmware_portgroup = data.terraform_remote_state.network.outputs.vmware_portgroup
  vm_name = "TF-Wordpress-DB"
  db_ip_address = var.db_ip_address
  db_gateway = data.terraform_remote_state.network.outputs.db_gateway
}

provider "azurerm" {
  features {}
  // Requires ENV variable ARM_SUBSCRIPTION_ID
  // Requires ENV variable ARM_CLIENT_ID
  // Requires ENV variable ARM_CLIENT_SECRET
  // Requires ENV variable ARM_TENANT_ID
}

# Deploy VM to Azure site
module "demo-azure" {
  source  = "app.terraform.io/cisco-dcn-ecosystem/demo-mso/azurerm"
  version = "0.0.2"

  vm_name = "TF-Wordpress-Web"
  db_ip_address = var.db_ip_address
  subnet_name = data.terraform_remote_state.network.outputs.azure_subnet_name
  virtual_network_name = data.terraform_remote_state.network.outputs.virtual_network_name
  vm_resource_group_name = "VMs_WoS_TF-Hybrid_Cloud_VRF_westus"
  net_resource_group_name = data.terraform_remote_state.network.outputs.resource_group_name
}

provider "aws" {
  # Configuration options
  region = "us-west-1"
}

# Deploy VM to AWS site
module "demo_aws" {
  source  = "app.terraform.io/cisco-dcn-ecosystem/demo_mso/aws"
  version = "0.0.3"

  vm_name = "TF-Wordpress-Web"
  db_ip_address = var.db_ip_address
  subnet_dn = data.terraform_remote_state.network.outputs.aws_subnet_dn
  region = data.terraform_remote_state.network.outputs.aws_region
}