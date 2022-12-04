variable "username" {
    type = string
}

variable "password" {
    type = string  
}

variable "rds_endpoint" {
    type = string  
}

variable "dbClusterIdentifier" {
    type = string  
}

variable "vpc_subnet_ids" {
  type = list(string)
}
variable "security_group" {
  type = list(string)
}