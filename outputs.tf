output "db_ip_address" {
  value = module.demo_vm.ip_address
  description = "The private IP address of the DB VM"
}

output "azure_vm_public_ip_address" {
  value = module.azure.public_ip_address
  description = "The public IP address of the VM"
}

output "azure_vm_private_ip_address" {
  value = module.azure.ip_address
  description = "The private IP address of the VM"
}