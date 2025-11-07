locals {
  environment = terraform.workspace
  common_tags = {
    Project = "roboshop"
    Production = terraform.workspace
    Terraform = true
  }
  ec2_tags = merge(local.common_tags, { Name = "workspace-${local.environment}-${var.project}" })
  sg_tags = merge(local.common_tags, { Name = "sg-${local.environment}-${var.project}" })
  dns_record = "workspace-${local.environment}-${var.project}"
  sg_name = "${local.environment}-${var.project}-sg"
}