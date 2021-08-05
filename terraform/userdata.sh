#!/bin/bash -v
sudo yum install -y amazon-linux-extras
sudo amazon-linux-extras enable nginx1
sudo yum clean metadata && sudo yum install -y nginx
sudo systemctl start nginx