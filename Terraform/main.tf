provider "aws" {
  region = "eu-west-3"
}

data "aws_vpc" "cloudtasks" {
  filter {
    name   = "tag:Name"
    values = ["CloudTasks-VPC"]
  }
}

data "aws_subnet" "cloudtasks_subnet" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.cloudtasks.id]
  }
}

resource "aws_key_pair" "cloudtasks_key" {
  key_name   = "CloudTasks-key"
  public_key = file("~/.ssh/CloudTasks-key.pub")
}

resource "aws_security_group" "cloudtasks_sg" {
  name        = "cloudtasks-sg"
  description = "Allow SSH, HTTP and HTTPS"
  vpc_id      = data.aws_vpc.cloudtasks.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "cloudtasks_ec2" {
  ami                         = "ami-0746ed6b6c0683e67"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.cloudtasks_key.key_name
  subnet_id                   = data.aws_subnet.cloudtasks_subnet.id
  vpc_security_group_ids      = [aws_security_group.cloudtasks_sg.id]
  associate_public_ip_address = true

  tags = {
    Name = "CloudTasks-Instance"
  }
}
