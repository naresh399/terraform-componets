provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "terraform" {
  ami = "${var.amis["us-east-1"]}"
  instance_type = "t2.micro"
  key_name = "deployer-key"
  security_groups = ["allow_ssh"]

  count = 2
  provisioner "local-exec" {
    command = "echo ${self.public_ip} >> /home/vagrant/ansible/hosts"
  }
}

resource "aws_key_pair" "deployer" {
  key_name = "deployer-key"
  public_key = "${var.key}"
}

resource "aws_security_group" "allow_ssh" {
  name = "allow_all"
  description = "allow inbound ssh traffic"

  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = ["73.106.182.227/32"]
  }
  tags {
    Name = "allow_all"
  }
}