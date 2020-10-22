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
