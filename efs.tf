#---------------------Creating an elastic file system ------------------
resource "aws_efs_file_system" "web-app-efs" {
  creation_token  = "web-app-efs"
  tags            = {
    Name          = "TF-EFS"
  }
}


#------------------Creating an efs mount target---------------
resource "aws_efs_mount_target" "efs-mount" {
  count = length(var.public_subnet_cidrs)
  file_system_id  = aws_efs_file_system.web-app-efs.id
  subnet_id       = aws_subnet.public_subnets[count.index].id
  security_groups = [aws_security_group.stack-clixx-sg.id ]
}

