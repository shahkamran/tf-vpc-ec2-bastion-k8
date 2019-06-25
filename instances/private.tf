#
#
#
/*
resource "aws_instance" "private_subnet_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  tags = {
    Name = "my-Private-Server"
  }
  subnet_id = var.private_subnet_id
  vpc_security_group_ids = [
    var.ssh_from_bastion_sg_id,
    var.web_access_from_nat_sg_id,
  ]

//  user_data                   = file("./instances/userdata-bastion.sh")

  key_name = var.key_name

/*
  provisioner "file" {
    source      = "../kscripts/*"
    destination = "/home/ec2-user/"
  }
*/

/*
  provisioner "remote-exec" {
    inline = [
      "export NAME=${var.cluster_name}",
      "export KOPS_STATE_STORE=s3://${var.bucket_id}",
      "yum -y update",
      "curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '\\\"' -f 4)/kops-linux-amd64",
      "chmod +x ./kops",
      "sudo mv ./kops /usr/local/bin/",
      "curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl",
      "chmod +x ./kubectl",
      "sudo mv ./kubectl /usr/local/bin/kubectl",
      "pip install awscli",
      "kops create cluster --node-size=t2.medium --zones ${var.azs} ${var.cluster_name}",
      "ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa",
      "kops create secret --name ${var.cluster_name} sshpublickey admin -i ~/.ssh/id_rsa.pub",
      "kops get ig --name ${var.cluster_name}",
      "kops update cluster ${var.cluster_name} --yes",
      "kops validate cluster",
  ]
  }
*/
/*
}
*/
