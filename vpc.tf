#-------------Creating the VPC-------------
resource "aws_vpc" "clixx-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "clixx-App VPC"
  }
}

#--------------Creating the public subnet-----------
resource "aws_subnet" "public_subnets" {
 count             = length(var.public_subnet_cidrs)
 vpc_id            = aws_vpc.clixx-vpc.id
 cidr_block        = element(var.public_subnet_cidrs, count.index)
 availability_zone = element(var.availability_zones, count.index)
 map_public_ip_on_launch = true
 
 tags = {
   Name = "Clixx Public Subnet ${count.index + 1}"
 }
}
 
 #-------------Creating the private subnet-----------
resource "aws_subnet" "private_subnets" {
 count             = length(var.private_subnet_cidrs)
 vpc_id            = aws_vpc.clixx-vpc.id
 cidr_block        = element(var.private_subnet_cidrs, count.index)
 availability_zone = element(var.availability_zones, count.index)
 
 tags = {
   Name = "Clixx Private Subnet ${count.index + 1}"
 }
}


#---------------Creating internet gateway----------------
resource "aws_internet_gateway" "gw" {
 vpc_id = aws_vpc.clixx-vpc.id
 
 tags = {
   Name = "clixx VPC IG"
 }
}

#-------------Creating Elastic IP------------------
resource "aws_eip" "nat_eip" {
  count = length(var.private_subnet_cidrs)
  domain = "vpc"
  tags = {
    "Name" = "ClixxNATGatewayEIP"
  }
}


#-------------Creating a NAT Gateway-----------------
resource "aws_nat_gateway" "nat_gw" {
  count = length(var.public_subnet_cidrs)
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id = aws_subnet.public_subnets[count.index].id
}


#-------------Creating a route table for the public subnets-----------
resource "aws_route_table" "Pub_sub_rt" {
  vpc_id = aws_vpc.clixx-vpc.id
  count = length(var.public_subnet_cidrs)

  route{
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

tags = {
  "Name" = "pub rt ${count.index + 1} "
}
}

#-------------Creating a route table for the private subnets-----------
resource "aws_route_table" "priv_sub_rt" {
  vpc_id = aws_vpc.clixx-vpc.id
  count = length(var.private_subnet_cidrs)

}

#-----------Directing traffic from priv subnet to the NAT gateway--------
resource "aws_route" "priv_internet_access" {
  route_table_id = aws_route_table.priv_sub_rt[count.index].id
  count = length(var.private_subnet_cidrs)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
}


#----------------Associating route table ---------------------
resource "aws_route_table_association" "public_subnet_asso" {
 count = length(var.public_subnet_cidrs)
 subnet_id      = aws_subnet.public_subnets[count.index].id
 route_table_id = aws_route_table.Pub_sub_rt[count.index].id
}


resource "aws_route_table_association" "private_subnet_asso" {
  count = length(var.private_subnet_cidrs)
  subnet_id = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.priv_sub_rt[count.index].id
}


resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.domain_name.id
  name = "www.clixx"
  type = "CNAME"
  ttl = "300"
  records = [aws_lb.clixx-lb.dns_name]
}
