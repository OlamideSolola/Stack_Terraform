locals {
  ServerPrefix = ""
}


#-----------------Creating the clixx Application Server ----------------
resource "aws_instance" "clixx-server" {
  count = var.stack_controls["ec2_create"] == "Y" ? 1 : 0
  ami                     = data.aws_ami.stack_ami.id
  instance_type           = var.EC2_Components["instance_type"]
  vpc_security_group_ids  = [aws_security_group.stack-clixx-sg.id]
  user_data               = data.template_file.bootstrap_clixx.rendered
  key_name                = aws_key_pair.Stack_KP.key_name
  subnet_id               = aws_subnet.public_subnets[count.index].id
 root_block_device {
    volume_type           = var.EC2_Components["volume_type"]
    volume_size           = var.EC2_Components["volume_size"]
    delete_on_termination = var.EC2_Components["delete_on_termination"]
    encrypted = var.EC2_Components["encrypted"] 
  }
  tags = {
   Name  = "${local.ServerPrefix != "" ? local.ServerPrefix : "Clixx_Application_Server_"}${count.index}"
   Environment = var.environment
   OwnerEmail = var.OwnerEmail
}
}


#--------------------Creating the RDS Snapshot------------------------------
resource "aws_db_instance" "clixx_database" {
  identifier = "wordpressdbclixx"
  instance_class = "db.m6gd.large"
  snapshot_identifier = data.aws_db_snapshot.my_clixx_snapshot.id
  db_subnet_group_name = aws_db_subnet_group.clixx_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.Clixx_RDS-sg.id]
  skip_final_snapshot = true
}

#-----------------Creating a subnet group-------------------------------
resource "aws_db_subnet_group" "clixx_db_subnet_group" {
  name = "clixx_db_subnet_group"
  subnet_ids =  aws_subnet.private_subnets[*].id 
}