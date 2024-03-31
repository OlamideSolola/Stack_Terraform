#---------------------- Creating EBS Volume -------------------------
resource "aws_ebs_volume" "clixx-ebs-vol1" {
  availability_zone = var.availability_zone
  size = 20

  tags = {
    "name" = "Vol1"
  }
}

resource "aws_ebs_volume" "clixx-ebs-vol2" {
  availability_zone = var.availability_zone
  size = 20

  tags = {
    "name" = "Vol2"
  }
}

resource "aws_ebs_volume" "clixx-ebs-vol3" {
  availability_zone = var.availability_zone
  size = 20

  tags = {
    "name" = "Vol3"
  }
}

resource "aws_ebs_volume" "clixx-ebs-vol4" {
  availability_zone = var.availability_zone
  size = 20

  tags = {
    "name" = "Vol4"
  }
}

resource "aws_ebs_volume" "clixx-ebs-vol-backup" {
  availability_zone = var.availability_zone
  size = 20

  tags = {
    "name" = "Vol-backup"
  }
}


#------------------------Attaching the EBS volume ----------------------
resource "aws_volume_attachment" "clixx-vol1-mount" {
  device_name = "/dev/sdb"
  instance_id = aws_instance.clixx-server[0].id
  volume_id = aws_ebs_volume.clixx-ebs-vol1.id
}

resource "aws_volume_attachment" "clixx-vol2-mount" {
  device_name = "/dev/sdc"
  instance_id = aws_instance.clixx-server[0].id
  volume_id = aws_ebs_volume.clixx-ebs-vol2.id
}

resource "aws_volume_attachment" "clixx-vol3-mount" {
  device_name = "/dev/sdd"
  instance_id = aws_instance.clixx-server[0].id
  volume_id = aws_ebs_volume.clixx-ebs-vol3.id
}

resource "aws_volume_attachment" "clixx-vol4-mount" {
  device_name = "/dev/sde"
  instance_id = aws_instance.clixx-server[0].id
  volume_id = aws_ebs_volume.clixx-ebs-vol4.id
}


resource "aws_volume_attachment" "clixx-vol-backup-mount" {
  device_name = "/dev/sdf"
  instance_id = aws_instance.clixx-server[0].id
  volume_id = aws_ebs_volume.clixx-ebs-vol-backup.id
}
