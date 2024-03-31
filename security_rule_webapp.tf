#---------------- Creating security rules for incoming traffic to web application servers ----------------

resource "aws_security_group_rule" "ssh" {
  security_group_id = aws_security_group.stack-clixx-sg.id
  description = "Allow SSH traffic to the server"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "http" {
  security_group_id = aws_security_group.stack-clixx-sg.id
  description = "Allow HTTP traffic to the server"
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "mysql" {
  security_group_id = aws_security_group.stack-clixx-sg.id
  description = "Allow mysql connection to the server"
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 3306
  to_port           = 3306
  cidr_blocks       = ["0.0.0.0/0"]
}

#---------------Creating security rules for outgoing traffic from clixx app server --------------

resource "aws_security_group_rule" "All-traffic" {
  security_group_id = aws_security_group.stack-clixx-sg.id
  description = "Allow all outbound traffic from the server"
  type              = "egress"
  protocol          = -1 
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}