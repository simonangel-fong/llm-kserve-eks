# 05-vpc.tf

data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.0"

  name = "${local.prefix_name}-vpc"
  cidr = local.vpc_cidr
  azs  = local.vpc_azs

  # cidr /20
  private_subnets = [for i, _ in local.vpc_azs : cidrsubnet(local.vpc_cidr, 4, i)]
  public_subnets  = [for i, _ in local.vpc_azs : cidrsubnet(local.vpc_cidr, 4, i + 8)]

  enable_dns_hostnames = true
  enable_dns_support   = true

  enable_nat_gateway = true
  single_nat_gateway = true

  # public subnet tag: ELB
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  # private subnet tag: ELB; karpenter
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
    # Karpenter launches nodes into subnets carrying this tag.
    "karpenter.sh/discovery" = local.karpenter_discovery
  }
}
