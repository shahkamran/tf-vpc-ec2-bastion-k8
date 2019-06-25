
Flow the keypair-readme.txt to generate a keypair.

Move terraform.tfvars to a ../terraform.tfvars and add all necessary details such as keys and paths.

Use;
./init.sh to initialize
./plan.sh to plan
./apply.sh to implement
./destroy.sh to destroy


#To connect to private host via bastion host use following SSH command
ssh -i ~/keys/terraform-ec2-key -o ProxyCommand="ssh -i ~/keys/terraform-ec2-key ec2-user@35.177.13.190 nc %h %p" ec2-user@10.1.5.18
