#-------------- Creating Security Group for Clixx Application ---------------
resource "aws_security_group" "stack-clixx-sg" {
  vpc_id      = aws_vpc.clixx-vpc.id
  name        = "Stack-Clixx-WebDMZ"
  description = "Stack IT Security Group For CliXX System"
}


#--------------- Creating security group for EFS -----------------
resource "aws_security_group" "Clixx_EFS-security-group" {
  vpc_id      = aws_vpc.clixx-vpc.id
  name        = "Clixx-efs-sg"
  description = "security group for efs"
}


#--------------- Creating Security Group for load balancer listener ----------
resource "aws_security_group" "Clixx_alb-sg" {
  name        = "Clixx_LB_SG"
  description = "Security Group for Load Balancer"
  vpc_id      = aws_vpc.clixx-vpc.id
}

#-------Creating new security group ----------------
resource "aws_security_group" "Clixx_RDS-sg" {
  name        = "Clixx_RDS-sg"
  description = "Security Group for the database"
  vpc_id      = aws_vpc.clixx-vpc.id

}