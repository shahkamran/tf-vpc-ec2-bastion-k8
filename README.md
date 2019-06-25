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

Apply complete! Resources: 36 added, 0 changed, 0 destroyed.

Outputs:

aws_bastion_public_address =  (1.2.3.4)
aws_eip_public_address = ec2-1.2.3.4.eu-west-2.compute.amazonaws.com (1.2.3.4)
bucket_id = my-special-environment-terraform-2019-bucket-unique-aws-team-xyz
connect_to_bastion = <ssh -i ~/keys/terraform-ec2-key ec2-user@1.2.3.4>

Using above output you can simply execute result string in connect_to_bastian

* ./destory.sh


* Once up and running you will have to connect to bastian host using the command output provided after you apply terraform.
* You will now have several scripts to carr out following from within your home directory;
        
* Install Kube tools (install-tools.sh )
* Create Cluster (install-cluster.sh)
* Check Cluster (check-cluster.sh)
* Install Sample Docker App (install-app.sh )
* Delete App (delete-app.sh)
* Delete Cluster (delete-cluster.sh )

Make sure if you installed cluster, you must delete cluster before destroying your bastion instance using the terraform destroy.
