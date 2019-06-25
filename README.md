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
* ./init.sh
* ./plan.sh
* ./apply.sh
* ./destory.sh

