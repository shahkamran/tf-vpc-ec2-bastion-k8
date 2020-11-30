##################################################################################
# VARIABLES
##################################################################################

variable "aws_access_key" {
}

variable "aws_secret_key" {
}

variable "private_key_path" {
}

variable "existing-proper-user" {
  default = "terraform-k8"
}

variable "region" {
  default = "eu-west-2"
}

variable "az-names" {
  default = "eu-west-2a,eu-west-2b,eu-west-2c"
}
variable "key_name" {
  default = "terraform-ec2-key"
}

variable "amis" {
  default = {
    eu-west-1 = "ami-047bb4163c506cd98"
    eu-west-2 = "ami-f976839e"
  }
}

variable "instance_type" {
  default = "t2.micro"
}

variable "network_address_space" {
  default = "10.1.0.0/16"
}

variable "billing_code_tag" {
}

variable "environment_tag" {
}

variable "bucket_name" {
}

variable "instance_count" {
  default = 1
}

variable "subnet_count" {
  default = 2
}
