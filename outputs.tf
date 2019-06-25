##################################################################################
# OUTPUT
##################################################################################
#output "aws_elb_public_dns" {
#    value = "${aws_elb.web.dns_name}"
#}

output "bucket_id" {
  value = module.bucket.bucket_id
}


output "aws_bastion_public_address" {
  value = "${module.instances.bastion_dns} (${module.instances.bastion_ip})"
}

//output "aws_bastion_public_dns" {
//  value = module.instances.bastion_dns
//}

//output "aws_private_ip" {
//  value = module.instances.private_ip
//}

//output "aws_private_address" {
//  value = "${module.instances.private_dns} (${module.instances.private_ip})"
//}
//output "connect_to_private" {
//  value = "<ssh -i ~/keys/terraform-ec2-key -o ProxyCommand=\"ssh -i ~/keys/terraform-ec2-key ec2-user@${module.instances.eip_ip}  nc %h %p\" ec2-user@${module.instances.private_ip}>"
//}



//output "aws_eip_public_dns" {
//  value = module.instances.eip_dns
//}

output "aws_eip_public_address" {
  value = "${module.instances.eip_dns} (${module.instances.eip_ip})"
}

output "connect_to_bastion" {
  value = "<ssh -i ~/keys/terraform-ec2-key ec2-user@${module.instances.eip_ip}>"
}

#
#output "encrypted_secret" {
#  value = module.iam-user.encrypted_secret
#}
#
#output "access_key_id" {
#  value = module.iam-user.access_key_id
#}


#output "access_key_secret" {
#  value = "${module.iam-user.access_key_secret}"
#}
#
#ssh -i ~/keys/terraform-ec2-key -o ProxyCommand="ssh -i ~/keys/terraform-ec2-key ec2-user@35.177.13.190 nc %h %p" ec2-user@10.1.5.18
#
#output "bastian_public_ip_address" {
#    value = "${aws_instance.bastion.public_ip}"
#}
