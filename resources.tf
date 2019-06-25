##################################################################################
# PROVIDERS
##################################################################################

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

resource "aws_key_pair" "terraform-ec2-key" {
  key_name = "terraform-ec2-key"

  //  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDfMCqXraSPxvhL2LIGluGC7Y8UsV1PuMcH1L3u7zdHnMQl0CzAt+1yjqdcbu/OVDBMtoPfimTp5BxawuodDdEEewNSOonL517oSQqwdaunkoy6bioITMvj6iiG4ab3thy0BaT0MWb7Thbf8KDHPIxLm0fdgJHSOhXRb6TEToNCi+zm9BVYcKiYK6HBfnh4wp9CI2pyhZ1OEhly/8K+SjQzg4j8TR/5EH7JEiCl64Y5gXwNxLDyjHHiGMqk2sv6EfxRncroAYVhonG/N63Fkd1BTOIWLNovgId/ehw/+ejh2LHi5Y7+whgPzVqaFfzmhXW/RSRMaAmxeAoLZWDUpeGx kayanazimov@kayanazimov.local"
  public_key = file("~/keys/terraform-ec2-key.pub")
}

##################################################################################
# DATA
##################################################################################

data "aws_availability_zones" "available" {
}

##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #

module "vpc" {
  source = "./modules/vpc"
  name   = var.environment_tag

  cidr = var.network_address_space
  azs = slice(
    data.aws_availability_zones.available.names,
    0,
    var.subnet_count,
  )
  tags = {
    BillingCode = var.billing_code_tag
    Environment = var.environment_tag
  }
}

# SECURITY GROUPS #
resource "aws_security_group" "pub-sg" {
  name   = "pub_sg"
  vpc_id = module.vpc.vpc_id

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment_tag}-pub-sg"
    BillingCode = var.billing_code_tag
    Environment = var.environment_tag
  }
}

# private security group
resource "aws_security_group" "pri-sg" {
  name   = "pri_sg"
  vpc_id = module.vpc.vpc_id

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.network_address_space]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment_tag}-pri-sg"
    BillingCode = var.billing_code_tag
    Environment = var.environment_tag
  }
}

# INSTANCES #

module "instances" {
  source            = "./instances"
  region            = var.region
  ami               = var.amis[var.region]
  instance_type     = var.instance_type
  bucket_id         = module.bucket.bucket_id
  az-names          = var.az-names


  public_subnet_id  = element(flatten([module.vpc.public_subnets]), var.instance_count % var.subnet_count)
  private_subnet_id = element(flatten([module.vpc.private_subnets]), var.instance_count % var.subnet_count)


  bastion_ssh_sg_id = aws_security_group.pub-sg.id
  ssh_from_bastion_sg_id    = aws_security_group.pri-sg.id
  web_access_from_nat_sg_id = aws_security_group.pri-sg.id
  key_name                  = var.key_name
}


# S3 BUCKET#
module "bucket" {
  name = "${lower(var.environment_tag)}-${var.bucket_name}"

  source = "./s3"
  tags = {
    BillingCode = var.billing_code_tag
    Environment = var.environment_tag
  }
}
