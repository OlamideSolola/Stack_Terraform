data "template_file" "bootstrap_clixx" {
  template = file(format("%s/scripts/bootstrap_clixx.tpl", path.module))
  vars={
    GIT_REPO="https://github.com/stackitgit/CliXX_Retail_Repository.git",
    MOUNT_POINT ="/var/www/html"
    file_system_id=aws_efs_file_system.web-app-efs.id
    region = var.AWS_REGION
    DB_NAME=var.DB_NAME
    DB_USER=var.DB_USER
    DB_PASSWORD=var.DB_PASSWORD
    DB_EMAIL=var.DB_EMAIL
    DB_HOST=var.DB_HOST
    LB_DNS=aws_lb.clixx-lb.dns_name
    EBS-vol1=var.EBS-vol1
    EBS-vol2=var.EBS-vol2
    EBS-vol3=var.EBS-vol3
    EBS-vol4=var.EBS-vol4
    EBS-vol-backup=var.EBS-vol-backup
    New_RDS_INSTANCE=split(":", aws_db_instance.clixx_database.endpoint)[0]
  }
}
