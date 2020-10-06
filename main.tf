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
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Deploy VM to On-Premises site
module "demo_vm" {
  source  = "app.terraform.io/cisco-dcn-ecosystem/demo_vm/vsphere"
  version = "0.0.1"

  vmware_dvs = data.terraform_remote_state.network.outputs.vmware_vds
  vmware_portgroup = data.terraform_remote_state.network.outputs.vmware_portgroup
  vm_name = "TF-Wordpress-DB"
  db_ip_address = var.db_ip_address
  db_gateway = data.terraform_remote_state.network.outputs.db_gateway
}

# Deploy VM to Azure site
module "demo-azure" {
  source  = "app.terraform.io/cisco-dcn-ecosystem/demo-mso/azurerm"
  version = "0.0.1"

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