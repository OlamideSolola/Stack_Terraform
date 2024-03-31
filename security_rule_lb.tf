#---------------- Creating inbound security rule for load balancer listener ----------------
resource "aws_security_group_rule" "hhtp-lb-inbound" {
    security_group_id = aws_security_group.Clixx_alb-sg.id
    description       = "Allow inbound hhtp traffic to loadbalancer"
    type              = "ingress" 
    from_port         = 80
    to_port           = 80
    protocol          = "tcp"
    cidr_blocks       = ["0.0.0.0/0"]

}


#---------------- Creating outbound security rule for load balancer listener ----------------
resource "aws_security_group_rule" "lb-outbound" {
    security_group_id = aws_security_group.Clixx_alb-sg.id
    description       = "Allow all outbound traffic"
    type              = "egress" 
    from_port         = 0
    to_port           = 0
    protocol          = -1
    cidr_blocks       = ["0.0.0.0/0"]

}