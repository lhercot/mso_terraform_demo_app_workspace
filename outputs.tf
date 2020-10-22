output "db_ip_address" {
  value = module.demo_vm.ip_address
  description = "The private IP address of the DB VM"
}