variable "AWS_ACCESS_KEY" {}
variable "AWS_SECRET_KEY" {}
variable "AWS_REGION" {}


variable "environment" {
  default = "dev"
}

variable "default_vpc_id" {
  default = "vpc-04a893eb7c0d6beeb"
}

variable "system" {
  default = "Retail Reporting"
}

variable "subsystem" {
  default = "CliXX"
}

variable "availability_zone" {
  default = "us-east-1a"
}

variable "subnets_cidrs" {
  type = list(string)
  default = [
    "172.31.80.0/20"
  ]
}

variable "instance_type" {
  default = "t2.micro"
}

variable "PATH_TO_PRIVATE_KEY" {
  default = "my_key"
}

variable "PATH_TO_PUBLIC_KEY" {
  default = "my_key.pub"
}

variable "OwnerEmail" {
  default = "olamide.solola@gmail.com"
}

variable "AMIS" {
  type = map(string)
  default = {
    us-east-1 = "ami-stack-1.0"
    us-west-2 = "ami-06b94666"
    eu-west-1 = "ami-844e0bf7"
  }
}


variable "subnet_ids" {
  type = list(string)
  default = [ 
    "subnet-00cddad788c906586",
    "subnet-0afad0cb4550c7f21",
    "subnet-0b3bad804a1e1eb2f",
    "subnet-09c9647f120dfbacc",
    "subnet-0b981b46b5150151c",
    "subnet-0f2c576dbf88d4664" 
    ]
}

variable "subnet_id" {
  default = "subnet-00cddad788c906586"
}

variable "stack_controls" {
  type = map(string)
  default = {
    ec2_create = "Y"
    rds_create = "N"
    wp_create  = "N"
  }
}

variable "EC2_Components" {
  type = map(string)
  default = {
    volume_type           = "gp2"
    volume_size           = 30
    delete_on_termination = true
    encrypted             = "true"
    instance_type         = "t2.micro"
  }
}

variable "MOUNT_POINT" {
  default = "/var/www/html"
}

variable "ASG_launch_Components" {
  type = map(string)
  default = {
    volume_type           = "gp2"
    volume_size           = 30
    delete_on_termination = true
    encrypted             = "true"
    instance_type         = "t2.micro"
  }
}

variable "ASG_Components" {
  type = map(string)
  default = {
    min_size           = 1
    max_size           = 3
    delete_on_termination = true
    encrypted             = "true"
    instance_type         = "t2.micro"
  }
}

variable "DB_NAME" {}

variable "DB_USER" {}

variable "DB_PASSWORD" {}

variable "DB_EMAIL" {}

variable "DB_HOST" {}

variable "EBS-vol1" {
  default = "/dev/sdg"
}

variable "EBS-vol2" {
  default = "/dev/sdh"
}

variable "EBS-vol3" {
  default = "/dev/sdi"
}

variable "EBS-vol4" {
  default = "/dev/sdj"
}

variable "EBS-vol-backup" {
  default = "/dev/sdk"
}
variable "public_subnet_cidrs" {
 type        = list(string)
 description = "Public Subnet CIDR values"
 default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
 
variable "private_subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values"
 default     = ["10.0.4.0/24", "10.0.5.0/24"]
}

variable "availability_zones" {
 type        = list(string)
 description = "Availability Zones"
 default     = ["us-east-1a", "us-east-1b"]
}

variable "ingress_rules" {
    type = list(object({
        type              = string
        description       = string
        from_port         = number
        to_port           = number
        protocol          = string
        cidr_blocks       = list(string)
    }))

  default = [
    {
      type              = "ingress"
      description       = "SSH"
      from_port         = 22
      to_port           = 22
      protocol          = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
    },
    {
      type              = "ingress"
      description       = "NFS"
      from_port         = 2049
      to_port           = 2049
      protocol          = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
    },
    {
      type              = "ingress"
      description       = "HTTP"
      from_port         = 80
      to_port           = 80
      protocol          = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
    },
    {
      type              = "ingress"
      description       = "MYSQL_Aurora"
      from_port         = 3306
      to_port           = 3306
      protocol          = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
    }
    ,
    {
      type              = "ingress"
      description       = "HTTPS"
      from_port         = 443
      to_port           = 443
      protocol          = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
    },
    {
      type              = "ingress"
      description       = "MS SQL"
      from_port         = 1433
      to_port           = 1433
      protocol          = "tcp"
      cidr_blocks       = ["0.0.0.0/0"]
    },
    {
      type              = "egress"
      description       = "All traffic"
      protocol          = -1 
      from_port         = 0
      to_port           = 0
      cidr_blocks       = ["0.0.0.0/0"]
    }

  ]
}