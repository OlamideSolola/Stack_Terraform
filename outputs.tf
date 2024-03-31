#------------ output for subnet ids --------#
output "subnet_ids" {
  #  value = [for s in data.aws_subnet.stack_subnets : s.cidr_block]
  value = [for s in data.aws_subnet.stack_sub : s.id]
  # value = [for s in data.aws_subnet.stack_sub : s.availability_zone]
  #value = [for s in data.aws_subnet.stack_sub : element(split("-", s.availability_zone), 2)]
}

#------------ output for the load balancer dns --------#

output "alb_dns_name" {
  value       = aws_lb.clixx-lb.dns_name
  description = "The domain name of the load balancer"
}
