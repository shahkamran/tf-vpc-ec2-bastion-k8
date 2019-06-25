# terraform-kube-cluster
Create a new Kubernetes cluster using Terraform

This repository will configure folloing for you.
* VPC
* Security Groups
* IAM Role for EC2 instance
* Required Routing and Subnets
* EC2 Instance/ Bastion
* S3 Bucket
* Scripts to install Kube tools, cluster, application and delete them all.

Steps to use this repository.

* git clone https://github.com/shahkamran/terraform-kube-cluster.git
* cd terraform-kube-cluster
* chmod +x *.sh

* mv ~/terraform.tfvars ~/terraform.tfvars.old
* mv terraform.tfvars ~/terraform.tfvars
* Modify ~/terraform.tfvars to add your account credentials.
* Modify variables.tf to change Region, Region AZs, and AMI IDs.

* Create a keypair and add details in variables.tf file
* ssh-keygen -f terraform-ec2-key
* mkdir ~/keys/
* mv terraform-ec2-key* ~/keys/
* Modify resourcex.tf to add full path to keys, such as
- public_key = "${file("~/keys/terraform-ec2-key.pub")}"

Also edit variables.tf to change key key_name
default = "terraform-ec2-key"
Kamrans-MacBook-Air:terraform-kube-cluster kamran$ 


Change path in shell scripts pointing to absolute path for terraform.tfvars e.g. /Users/me/terraform.tfvars including init.sh, plans.sh apply.sh and destroy.sh.

Now you can initialise, play, apply and destroy your infrastructure.
* ./init.sh
* ./plan.sh
* ./apply.sh
* ./destory.sh


* Once up and running you will have to connect to bastian host using the command output provided after you apply terraform.
* You will now have several scripts to carr out following from within your home directory;
* Install Kube tools.
* Create Cluster
* Check Cluster
* Install App
* Delete App
* Delete Cluster
