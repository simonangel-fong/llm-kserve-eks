# 02-locals.tf

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  # ##############################
  # Metadata
  # ##############################
  project     = "kserve"
  prefix_name = "${local.project}-${var.env}"

  # ##############################
  # Providers
  # ##############################
  aws_region = "us-east-1"
  default_tags = {
    Project   = local.project
    Env       = var.env
    ManagedBy = "Terraform"
  }

  # ##############################
  # Network
  # ##############################
  vpc_cidr = "10.0.0.0/16"
  vpc_azs  = slice(data.aws_availability_zones.available.names, 0, 2) # 2 AZs

  # ##############################
  # EKS
  # ##############################
  eks_version             = "1.36"
  eks_bootstrap_node_type = "t3.medium"
  eks_bootstrap_node_ami  = "AL2023_x86_64_STANDARD"

  # ##############################
  # Karpenter
  # ##############################
  karpenter_version   = "1.14.0"
  karpenter_discovery = local.prefix_name

  # ##############################
  # Argo CD
  # ##############################
  argocd_version   = "10.2.1"
  argocd_namespace = "argocd"
}
