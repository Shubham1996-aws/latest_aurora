variable "region" {
    type = string
}

variable "profile" {
    type = string
}

####VPC variables#########
variable "vpc_name" {
    type = string
}

variable "vpc_cidr" {
    type = string
}

variable "azs" {
    type = list(string)
}

variable "private_subnets" {
    type = list(string)
}

variable "public_subnets" {
    type = list(string)
}

#########DB variables#####################
variable "name" {
    type = string
}

variable "engine" {
    type = string
}

variable "engine_version" {
    type = string
}

variable "instance_class" {
    type = string
}

variable "security_group" {
    type = list(string)
}

variable "cidr_blocks" {
    type = list(string)
}

variable "master_username" {
    type = string
}

variable "master_password" {
    type = string
}

variable "snapshot_identifier" {
    type = string
}


locals {
    common_tags = {
        DataTaxonomy = "Cisco Operatoins Data"
        Deployment_stack = "green"
        #Deployment_version = v0.8
        Environment = "performance"
        Name = "Iaac-LACP-Mock-green-os"
        #OwnerName = ""
        #ResourceOwner = ""
        #Security Compliance = "yes"
        ServiceName        = "Security-stack"
    }
}
