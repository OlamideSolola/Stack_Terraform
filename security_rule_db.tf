#---------------- Creating inbound security rule for the database ----------------
resource "aws_security_group_rule" "RDS-inbound" {
    security_group_id        = aws_security_group.Clixx_RDS-sg.id
    description              = "Allows inbound traffic from the public subnet"
    type                     ="ingress"
    from_port                = 80
    to_port                  = 80
    protocol                 = "tcp"
    cidr_blocks       = var.public_subnet_cidrs
}


resource "aws_security_group_rule" "RDS-inbound_SSH" {
    security_group_id        = aws_security_group.Clixx_RDS-sg.id
    description              = "Allows inbound traffic for SSH"
    type                     ="ingress"
    from_port                = 22
    to_port                  = 22
    protocol                 = "tcp"
    cidr_blocks       = var.public_subnet_cidrs
}

resource "aws_security_group_rule" "RDS-inbound_HTTPS" {
    security_group_id        = aws_security_group.Clixx_RDS-sg.id
    description              = "Allows inbound traffic from the public subnet"
    type                     ="ingress"
    from_port                = 443
    to_port                  = 443
    protocol                 = "tcp"
    cidr_blocks       = var.public_subnet_cidrs
}


resource "aws_security_group_rule" "RDS-inbound_MSQL" {
    security_group_id        = aws_security_group.Clixx_RDS-sg.id
    description              = "Allows inbound traffic from the public subnet"
    type                     ="ingress"
    from_port                = 3306
    to_port                  = 3306
    protocol                 = "tcp"
    cidr_blocks       = var.public_subnet_cidrs
}

resource "aws_security_group_rule" "RDS-inbound_NFS" {
    security_group_id        = aws_security_group.Clixx_RDS-sg.id
    description              = "Allows inbound traffic from the public subnet"
    type                     ="ingress"
    from_port                = -1
    to_port                  = -1
    protocol                 = "icmp"
    cidr_blocks       = var.public_subnet_cidrs
}





#--------------Creating outbound security rule for the database ---------------------
resource "aws_security_group_rule" "RDS-outbound" {
  security_group_id          = aws_security_group.Clixx_RDS-sg.id
  description                = "Allows all outbound traffic"
  type                       = "egress"
  from_port                  = 0
  to_port                    = 0
  protocol                   = -1
  cidr_blocks                = [ "0.0.0.0/0" ]

}