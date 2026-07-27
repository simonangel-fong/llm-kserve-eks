# 06-eks.tf

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = local.prefix_name
  kubernetes_version = local.eks_version

  # ##############################
  # network
  # ##############################
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # ##############################
  # security
  # ##############################
  enable_cluster_creator_admin_permissions = true
  endpoint_private_access                  = true
  endpoint_public_access                   = true
  endpoint_public_access_cidrs             = ["0.0.0.0/0"]

  # ##############################
  # addons
  # ##############################
  addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
    eks-pod-identity-agent = {
      before_compute = true
    }
  }

  # ##############################
  # node group
  # ##############################
  eks_managed_node_groups = {
    # Default node group
    default = {
      ami_type       = local.eks_bootstrap_node_ami
      instance_types = [local.eks_bootstrap_node_type]

      min_size     = 2
      desired_size = 2
      max_size     = 4

      labels = {
        role = "bootstrap"
      }
    }
  }

  # ##############################
  # Karpenter
  # ##############################
  node_security_group_tags = {
    "karpenter.sh/discovery" = local.karpenter_discovery
  }
}
