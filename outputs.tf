output "db_ip_address" {
  value = module.demo_vm.ip_address
  description = "The private IP address of the DB VM"
}

output "azure_vm_public_ip_address" {
  value = module.demo-azure.public_ip_address
  description = "The public IP address of the VM"
}

output "azure_vm_private_ip_address" {
  value = module.demo-azure.ip_address
  description = "The private IP address of the VM"
}

output "aws_vm_public_ip_address" {
  value = module.demo_aws.public_ip_address
  description = "The public IP address of the VM in AWS"
}

output "aws_vm_private_ip_address" {
  value = module.demo_aws.ip_address
  description = "The private IP address of the VM in AWS"
}