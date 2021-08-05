provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region = var.region
}

resource "aws_vpc" "vpc-nginx" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "IG-nginx" {
  vpc_id = aws_vpc.vpc-nginx.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.vpc-nginx.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.IG-nginx.id
}

resource "aws_subnet" "subnet-nginx" {
  vpc_id                  = aws_vpc.vpc-nginx.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "SG-http-elb" {
  name        = "nginx-elb"
  description = "security group for http access"
  vpc_id      = aws_vpc.vpc-nginx.id

  ingress {
    from_port   = 80
    to_port     = 80
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

resource "aws_security_group" "SG-ssh-http-nginx" {
  name        = "ssh-http-nginx"
  description = "security group for nginx instance"
  vpc_id      = aws_vpc.vpc-nginx.id

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
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "elb-nginx" {
  name = "elb-for-nginx"

  subnets         = [aws_subnet.subnet-nginx.id]
  security_groups = [aws_security_group.SG-http-elb.id]
  instances       = [aws_instance.nginx.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }
}

resource "aws_key_pair" "nginx-ssh-key" {
  key_name   = "nginx-ssh-key-1"
  public_key = file(var.public_key_path)
}


data "aws_ami" "amazon-linux-2" {
  owners = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

data "template_file" "user_data" {
template = file("userdata.sh")
}

resource "aws_instance" "nginx" {
  instance_type = "t2.micro"
  ami = data.aws_ami.amazon-linux-2.id
  key_name = aws_key_pair.nginx-ssh-key.id
  vpc_security_group_ids = [aws_security_group.SG-ssh-http-nginx.id]
  subnet_id = aws_subnet.subnet-nginx.id
  user_data = data.template_file.user_data.rendered
}