#-------------- Creating launch template for autoscaling group ---------------
resource "aws_launch_configuration" "WebApp-ASG-LC" {
  image_id                = data.aws_ami.stack_ami.id
  instance_type           = var.ASG_launch_Components["instance_type"]
  security_groups         = [aws_security_group.stack-clixx-sg.id]
  user_data               = data.template_file.bootstrap_clixx.rendered
  lifecycle {create_before_destroy= true}

}

#-------------- Creating autoscaling group ---------------
resource "aws_autoscaling_group" "WebApp-ASG" {
  launch_configuration   = aws_launch_configuration.WebApp-ASG-LC.name
  vpc_zone_identifier    = aws_subnet.public_subnets[*].id
 target_group_arns       = [aws_lb_target_group.ClixxTFTG.arn]
  health_check_type      = "EC2"
  health_check_grace_period = 60
  min_size               = var.ASG_Components["min_size"]
  max_size               = var.ASG_Components["max_size"]

  tag {
    key                  = "Name"
    value                = "Clixx-TF-ASG"
    propagate_at_launch  = true
  }
}


