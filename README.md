# terraform-kube-cluster

The objective of this  terraform code in this git repository is create a completely new a environment in its own VPC on AWS with scripts ready to execute and deploy Kubernetes Cluster as well as an option of demo app.

This repository will configure following for you.
- VPC
- Security Groups
- IAM Role for EC2 instance
- Required Routing and Subnets
- EC2 Instance/ Bastion
- S3 Bucket
- Scripts to install Kube tools, cluster & demo application.
- Script to delete the demo app and kubernetes cluster.
- Scripts to execute terraform commands to make it easy for everyone.

Prerequisites:
1. You must have terraform v0.13 installed, not v0.11 or v0.12.

First of all you will have to set up local working location, pull repository and get it ready for execution.
1. ```cd``` # Go to your home directory.
2. ```mkdir terraform``` # Create a terraform working directory of your choice, if you don't have one.
3. ```cd terraform``` # Change to your terraform working directory.
4. ```git clone https://github.com/shahkamran/terraform-kube-cluster.git``` # pull git repository
5. ```cd terraform-kube-cluster``` # go to the repository local directory
6. ```chmod +x *.sh``` # make scripts executeable

You are required to have a Keypair in ~/keys/ directory and have its details added to couple of variables file.
1. Create a keypair.
```
ssh-keygen -f terraform-ec2-key
mkdir ~/keys/
mv terraform-ec2-key* ~/keys/
```
2.  ```vi variables.tf``` # Edit variables.tf file and add keypair name to variable as below.
```
variable "key_name" {
   default = "terraform-ec2-key"
 }
```
3. ```vi resources.tf``` # Edit resources.tf file and add public key full path to the line that reads something like below.
```
- public_key = "${file("~/keys/terraform-ec2-key.pub")}"
```

Finally you will have to do is set up terraform/ environment variables and configure credentials and other parameters.
1. ```mv ~/terraform.tfvars ~/terraform.tfvars.$$.old``` # Move any existing tfvars file to .old to avoid overwrite.
2. ```mv terraform.tfvars ~/terraform.tfvars``` # Move the downloaded terraform.tfvars to your home directory.
3. ```vi ~/terraform.tfvars``` # Add your credentials for AWS account, S3 Bucket unieque name, private key path and optional environment and billing code.
4. ```vi variables.tf``` # Make changes to your selected Region, Region AZs and add relevant AMI IDs.

Optional - If your home directory ```~/``` and path ```../../``` are not same, or in other words if you are not in /Users/name/terraform/terraform-kube-cluster/ directory then you will have to edit scripts for terraform.tfvars file location.
1. ```vi init.sh```
2. ```vi plan.sh```
3. ```vi apply.sh```
4. ```vi destroy.sh```

You are now ready to run your terraform code to deploy controller instance in AWS in your new VPC.
1. ```init.sh``` # Initialise terraform providers.
2. ```plan.sh``` # Create terraform plan.
3. ```apply.sh``` # Apply your plan, you will have to type "yes" to execute your plan which will create your controller Instance in AWS. The output from apply.sh will look like below.

```
Apply complete! Resources: 36 added, 0 changed, 0 destroyed.
Outputs:
aws_bastion_public_address =  (1.2.3.4)
aws_eip_public_address = ec2-1.2.3.4.eu-west-2.compute.amazonaws.com (1.2.3.4)
bucket_id = my-special-environment-terraform-2019-bucket-unique-aws-team-xyz
connect_to_bastion = <ssh -i ~/keys/terraform-ec2-key ec2-user@1.2.3.4>
```

You should now use output from connect_to_bastian output to log into your controller machine, such as;
```ssh -i ~/keys/terraform-ec2-key ec2-user@1.2.3.4```

Install Kubernetes cluster using following steps.
1. ```./install-tools.sh``` # This will install Kubectl and other tools required for Kubernetes cluster.
2. ```./install-cluster.sh``` # This will install Kubernetes cluster. You must wait for this to complete as it will take up to 10 minutes.
3. ```./check-cluster.sh``` # Keep running this until you can validate cluseter successfully set up.

Make sure you have cluster installed and successfully validated it.

Optionally, you can install some applications to try them out.
1. ```./install-app.sh``` # This will install Fleetman Angular app from dockerhub.
2. ```./install-monitoring.sh``` # This will set up Prometheus and Grafana for monitoring and statistics.
3. ```./delete-app.sh``` # Once finished this will delete app Kubernetes applications you have installed on this cluster.

Delete Kubernetes cluster - You must run this and ensure this is completed successfully before deleting AWS instance. The cluster has to be deleted properly otherwise it will re-create load balancers and instances automatically.
1. ```./delete-cluster.sh``` # You must let this complete otherwise you will have to manually clean up all of your AWS.

Make sure if you installed cluster, you must delete cluster before destroying your bastion instance using the terraform destroy.

Once you have confirmed that your Kubernetes cluster is deleted, there are no Load Balancers and no Kubernets worker instances you can run Terraform script to destroy your infrastructure.
1. ```./destroy.sh``` # Destroys AWS resources including the Instance and other items in new VPC created by Terraform above.
