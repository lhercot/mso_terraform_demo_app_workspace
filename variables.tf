variable "org" {
  description = "The Terraform Cloud organisation to connect to"
}

variable "network_workspace" {
  description = "The Terraform Cloud workspace to connect to"
}

variable "name_prefix" {
  type = string
  default = "TF-"
  description = "A prefix that will be added to all the object names"
}

variable "db_ip_address" {
  type = string
  default = "10.101.10.11"
  description = "The IP address of the DB VM to point to"
}