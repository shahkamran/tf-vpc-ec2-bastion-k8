#
#
#
variable "cluster_name" {
  default = "kubemasters2019.k8s.local"
}
variable "region" {
}

variable "key_name" {
}

variable "bucket_id" {
}

variable "az-names" {
}

variable "instance_type" {
}

# Amazon Linux AMI
# Most recent as of 2015-12-02
variable "ami" {
}

#
# From other modules
#
variable "public_subnet_id" {
}

variable "bastion_ssh_sg_id" {
}

variable "private_subnet_id" {
}
/*
variable "private_subnets" {
}

variable "private_subnets" {
}
*/
variable "ssh_from_bastion_sg_id" {
}

variable "web_access_from_nat_sg_id" {
}

#
#
#variable "aws_instance.bastion.public_ip" {}
#  }
