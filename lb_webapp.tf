#-------------- Creating loadbalancer for web applications ---------------
resource "aws_lb" "clixx-lb" {
  name                = "ClixxLB"
  load_balancer_type  = "application"
  subnets             = aws_subnet.public_subnets[*].id
  security_groups     = [aws_security_group.Clixx_alb-sg.id]
}


#-------------- Creating loadbalancer listener for web applications ---------------
resource "aws_lb_listener" "http" {
  load_balancer_arn   = aws_lb.clixx-lb.arn
  port                = 80
  protocol            = "HTTP"
  default_action {
    type              = "fixed-response"
    fixed_response {
      content_type    = "text/plain"
      message_body    = "404: page not found"
      status_code     = 404
    }
  }
}


#-------------- Creating loadbalancer listener rule ---------------
resource "aws_lb_listener_rule" "lb_listner_rule" {
  listener_arn       = aws_lb_listener.http.arn
  priority           = 100
  condition {
    path_pattern {
      values         = [ "*" ]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ClixxTFTG.arn
  }
}
