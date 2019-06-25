ssh-keygen -f terraform-ec2-key

mkdir ~/keys/
mv terraform-ec2-key* ~/keys/

Edit resourcex.tf to add full path to keys
public_key = "${file("~/keys/terraform-ec2-key.pub")}"

Also edit variables.tf to change key key_name
default = "terraform-ec2-key"
