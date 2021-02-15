data "aws_ami" "centos8" {
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS 8*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  # CentOS (https://centos.org/download/aws-images/)
  owners = ["125523088429"]
}

data "aws_ami" "windows_server_2012" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Windows_Server-2012-RTM-English-64Bit-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  # AWS Marketplace
  owners = ["amazon"]
}

data "aws_ami" "red_hat_76" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-7.6_HVM-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  # Red Hat (https://access.redhat.com/articles/2962171)
  owners = ["309956199498"]
}

resource "aws_instance" "app" {
  ami                    = data.aws_ami.windows_server_2012.id
  instance_type          = var.app_instance_type
  vpc_security_group_ids = [aws_security_group.app.id]
  subnet_id              = element(module.vpc.private_subnets, 0)
  iam_instance_profile   = aws_iam_instance_profile.profile.name
  key_name               = var.ec2_app_keypair

  root_block_device {
    volume_type = "gp2"
    volume_size = "80"
    encrypted   = true
  }

  tags = { "Name" : "app" }
}

resource "aws_instance" "db" {
  ami                    = data.aws_ami.red_hat_76.id
  instance_type          = var.db_instance_type
  vpc_security_group_ids = [aws_security_group.db.id]
  subnet_id              = element(module.vpc.private_subnets, 0)
  iam_instance_profile   = aws_iam_instance_profile.profile.name
  key_name               = var.ec2_db_keypair

  root_block_device {
    volume_type = "gp2"
    volume_size = "80"
    encrypted   = true
  }

  tags = { "Name" : "db" }
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.centos8.id
  instance_type          = var.bastion_instance_type
  vpc_security_group_ids = [aws_security_group.bastion.id]
  subnet_id              = element(module.vpc.public_subnets, 0)
  iam_instance_profile   = aws_iam_instance_profile.profile.name
  key_name               = var.ec2_bastion_keypair
  user_data              = <<-EOT
													Content-Type: multipart/mixed; boundary="//"
													MIME-Version: 1.0
													--//
													Content-Type: text/cloud-config; charset="us-ascii"
													MIME-Version: 1.0
													Content-Transfer-Encoding: 7bit
													Content-Disposition: attachment; filename="cloud-config.txt"
													#cloud-config
													output : { all : '| tee -a /var/log/cloud-init-output.log' }
													cloud_final_modules:
													- [scripts-user, always]
													--//
													Content-Type: text/x-shellscript; charset="us-ascii"
													MIME-Version: 1.0
													Content-Transfer-Encoding: 7bit
													Content-Disposition: attachment; filename="userdata.txt"
													#!/bin/bash
													dnf update -y
													# forward RDP
													dnf install iptables -y
													iptables -t nat -A POSTROUTING -j MASQUERADE
													iptables -t nat -A PREROUTING -p tcp --dport 3389 -j DNAT --to-destination ${aws_instance.app.private_ip}:3389
													# harden instance by disabling unneeded services
													systemctl stop rpcbind.socket
													systemctl disable rpcbind.socket
													systemctl stop rpcbind
													systemctl disable rpcbind
													# harden ssh
													cat 'Ciphers aes128-ctr,aes192-ctr,aes256-ctr' | sudo tee -a /etc/ssh/sshd_config
													cat 'Protocol 2' | sudo tee -a /etc/ssh/sshd_config
													sed -i 's/X11Forwarding yes/X11Forwarding no/g' /etc/ssh/sshd_config
													sed -i 's/#HostbasedAuthentication no/HostbasedAuthentication no/g' /etc/ssh/sshd_config
													sed -i 's/#IgnoreRhosts yes/IgnoreRhosts yes/g' /etc/ssh/sshd_config
													sed -i 's/#PermitRootLogin yes/PermitRootLogin no/g' /etc/ssh/sshd_config
													chown root:root /etc/ssh/sshd_config
													chmod 600 /etc/ssh/sshd_config
													systemctl restart sshd
													# ignore icmp and broadcast requests
													echo 'net.ipv4.ip_forward=1' | tee -a /etc/sysctl.conf
													echo 'net.ipv4.icmp_ignore_bogus_error_responses=1' | sudo tee -a /etc/sysctl.conf
													sysctl -p
													--//
                  EOT

  root_block_device {
    volume_type = "gp2"
    volume_size = "80"
    encrypted   = true
  }

  depends_on = [aws_instance.app, aws_instance.db]
  tags       = { "Name" : "bastion" }
}

resource "aws_iam_instance_profile" "profile" {
  name = "SSM-ROLE"
  role = aws_iam_role.instances.name
}

resource "aws_iam_role" "instances" {
  name = "instances"
  path = "/"

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

data "aws_iam_policy" "ssm_managed_instance" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.instances.name
  policy_arn = data.aws_iam_policy.ssm_managed_instance.arn
}
