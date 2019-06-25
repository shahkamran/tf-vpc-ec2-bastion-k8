#
#

resource "aws_iam_role" "AllowEC2KubeAccess" {
  name = "AllowEC2KubeAccess"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ec2-attach-1" {
  role       = aws_iam_role.AllowEC2KubeAccess.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}
resource "aws_iam_role_policy_attachment" "ec2-attach-2" {
  role       = aws_iam_role.AllowEC2KubeAccess.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
}
resource "aws_iam_role_policy_attachment" "ec2-attach-3" {
  role       = aws_iam_role.AllowEC2KubeAccess.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
resource "aws_iam_role_policy_attachment" "ec2-attach-4" {
  role       = aws_iam_role.AllowEC2KubeAccess.name
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
}
resource "aws_iam_role_policy_attachment" "ec2-attach-5" {
  role       = aws_iam_role.AllowEC2KubeAccess.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
}

resource "aws_iam_instance_profile" "bastion_profile" {
  name  = "bastion_profile"
  role = "AllowEC2KubeAccess"

  depends_on = ["aws_iam_role.AllowEC2KubeAccess"]

}
resource "aws_instance" "bastion" {
  ami           = var.ami
  instance_type = var.instance_type
  iam_instance_profile  = aws_iam_instance_profile.bastion_profile.name
//  iam_instance_profile = aws_iam_instance_profile.bastion_profile.name}
  tags = {
    Name = "my-Bastion-Server"
    changes = "4"
    }

  subnet_id                   = var.public_subnet_id
  // subnet_id                   = var.public_subnets[count.index]
  associate_public_ip_address = true
  vpc_security_group_ids      = [var.bastion_ssh_sg_id]
//  user_data                   = file("./instances/userdata-bastion.sh")
  key_name                    = var.key_name

  depends_on = ["aws_iam_instance_profile.bastion_profile"]

}

resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  vpc      = true
  tags = {
    Name = "my-Bastion-Eip"
  }
}

resource "null_resource" "connect_bastion" {
  connection {
    host        = "${aws_eip.bastion.public_ip}"
    user        = "ec2-user"
    private_key = file("~/keys/terraform-ec2-key")

//    private_key = "${file(var.private_key)}"
  }
  triggers = {
    cluster_instance_ids = "${join(",", aws_instance.bastion.*.id,)}"
  }
  provisioner "file" {
    source      = "~/my-terraform/mine/instances/scripts/"
    destination = "/home/ec2-user"
  }

  provisioner "remote-exec" {
    inline = [
      "echo \"a\\\"baby\" > a.txt",
    ]
  }


provisioner "file" {
  content = <<EOF
  export REGION=${var.region}
  export NAME=${var.cluster_name}
  export KOPS_STATE_STORE=s3://${var.bucket_id}

  EOF
    destination = "/home/ec2-user/.bash_profile"
}

provisioner "file" {
  content = <<EOF
  kops delete cluster --name ${var.cluster_name} --yes
  EOF
    destination = "/home/ec2-user/delete-cluster.sh"
}

provisioner "file" {
  content = <<EOF
  export REGION=${var.region}
  export NAME=${var.cluster_name}
  export KOPS_STATE_STORE=s3://${var.bucket_id}
  #sudo yum -y update >> remote-exec-output.txt
  curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
  chmod +x ./kops
  sudo mv ./kops /usr/local/bin/
  curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
  chmod +x ./kubectl
  sudo mv ./kubectl /usr/local/bin/kubectl
  pip install awscli >> remote-exec-output.txt

  EOF
    destination = "/home/ec2-user/install-tools.sh"
}

provisioner "file" {
  content = <<EOF
  kops create cluster --zones ${var.az-names} ${var.cluster_name}
  ssh-keygen -P ${var.cluster_name} -b 2048 -t rsa -f ~/.ssh/id_rsa
  kops create secret --name ${var.cluster_name} sshpublickey admin -i ~/.ssh/id_rsa.pub
  kops get ig --name ${var.cluster_name} >> remote-exec-output.txt
  kops update cluster ${var.cluster_name} --yes >> remote-exec-output.txt
  kops validate cluster ${var.cluster_name} >> remote-exec-output.txt

  EOF
    destination = "/home/ec2-user/install-cluster.sh"
}

provisioner "file" {
  content = <<EOF
  kops validate cluster

  EOF
    destination = "/home/ec2-user/check-cluster.sh"
}

provisioner "file" {
  content = <<EOF
  kubectl apply -f /home/ec2-user/scripts/services.yaml -f /home/ec2-user/scripts/workloads.yaml -f /home/ec2-user/scripts/storage-aws.yaml -f /home/ec2-user/scripts/mongo-stack.yaml -f /home/ec2-user/scripts/fluentd-config.yaml -f /home/ec2-user/scripts/elastic-stack.yaml

  EOF
    destination = "/home/ec2-user/install-app.sh"
}

provisioner "file" {
  content = <<EOF
  kubectl delete all -all

  EOF
    destination = "/home/ec2-user/delete-app.sh"
}

provisioner "remote-exec" {
  inline = [
    "chmod +x /home/ec2-user/*.sh",
  ]
}

/*
  provisioner "remote-exec" {
    inline = [
      "export REGION=${var.region}",
      "echo \"export REGION=${var.region}\" >> /home/ec2-user/.bash_profile",
      "export NAME=${var.cluster_name}",
      "echo \"export NAME=${var.cluster_name}\" >> /home/ec2-user/.bash_profile",
      "export KOPS_STATE_STORE=s3://${var.bucket_id}",
      "echo \"export KOPS_STATE_STORE=s3://${var.bucket_id}\" >> /home/ec2-user/.bash_profile",
      "sudo yum -y update >> remote-exec-output.txt",
      "curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '\"' -f 4)/kops-linux-amd64  >> remote-exec-output.txt",
      "chmod +x ./kops",
      "sudo mv ./kops /usr/local/bin/",
      "curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl  >> remote-exec-output.txt",
      "chmod +x ./kubectl",
      "sudo mv ./kubectl /usr/local/bin/kubectl",
      "pip install awscli >> remote-exec-output.txt",
      "kops create cluster --zones ${var.az-names} ${var.cluster_name} >> remote-exec-output.txt",
      "ssh-keygen -P ${var.cluster_name} -b 2048 -t rsa -f ~/.ssh/id_rsa >> remote-exec-output.txt",
      "kops create secret --name ${var.cluster_name} sshpublickey admin -i ~/.ssh/id_rsa.pub >> remote-exec-output.txt",
      "kops get ig --name ${var.cluster_name} >> remote-exec-output.txt",
      "kops update cluster ${var.cluster_name} --yes >> remote-exec-output.txt",
      "kops validate cluster ${var.cluster_name} >> remote-exec-output.txt",
      "echo \"kubectl delete all --all\" >> deletecluster.sh",
      "echo \"kops delete cluster --name ${var.cluster_name} --yes\" >> deletecluster.sh",
      "chmod +x deletecluster.sh",
      "echo \"kubectl apply -f /home/ec2-user/scripts/services.yaml -f /home/ec2-user/scripts/workloads.yaml -f /home/ec2-user/scripts/storage-aws.yaml -f /home/ec2-user/scripts/mongo-stack.yaml -f /home/ec2-user/scripts/fluentd-config.yaml -f /home/ec2-user/scripts/elastic-stack.yaml >> create-fleetman.sh\" ",
      "chmod +x create-fleetman.sh",
      "echo \"All done\" >> remote-exec-output.txt",
  ]
  }
*/

  depends_on = ["aws_eip.bastion", "aws_instance.bastion"]
}
