output "address" {
  value = aws_elb.elb-nginx.dns_name
}