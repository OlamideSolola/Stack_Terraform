#---------- Data Source for AMI ---------
data "aws_ami" "stack_ami" {
  owners      = ["self"]
  name_regex  = "^ami-stack-.*"
  most_recent = true
  filter {
    name      = "name"
    values    = ["ami-stack-*"]
  }
}

#------------ Data source for subnet ----------
data "aws_subnets" "stack_sub" {
  filter {
    name      = "vpc-id"
    values    = [var.default_vpc_id]
  }
}

data "aws_subnet" "stack_sub" {
  for_each   = toset(data.aws_subnets.stack_sub.ids)
  id         = each.value
}


#-------------Data source of Snapshot-----------------------------------
data "aws_db_snapshot" "my_clixx_snapshot" {
  db_instance_identifier = "wordpressdbclixx"
  most_recent = true
  }

  #--------------Data Source to get the domaine name----------------------
data "aws_route53_zone" "domain_name" {
  name = "stack-olamide-solola.com"
}