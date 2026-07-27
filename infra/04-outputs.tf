# 04-outputs.tf

# ##############################
# EKS
# ##############################
output "cluster_name" {
  description = "EKS cluster name."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "Kubernetes API server endpoint."
  value       = module.eks.cluster_endpoint
}

output "configure_kubectl" {
  description = "Command to write this cluster into your kubeconfig."
  value       = "aws eks update-kubeconfig --region ${local.aws_region} --name ${module.eks.cluster_name}"
}

# ##############################
# Karpenter
# ##############################
output "karpenter_node_iam_role_name" {
  description = "IAM role assumed by Karpenter-launched nodes."
  value       = module.karpenter.node_iam_role_name
}

output "karpenter_discovery_tag" {
  description = "Value of the karpenter.sh/discovery tag on subnets and security groups."
  value       = local.karpenter_discovery
}

output "karpenter_queue_name" {
  description = "SQS queue Karpenter watches for interruption notices."
  value       = module.karpenter.queue_name
}

# ##############################
# Argo CD
# ##############################
output "argocd_initial_admin_password" {
  description = "Command to read the generated admin password."
  value       = "kubectl -n ${local.argocd_namespace} get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
}

output "argocd_port_forward" {
  description = "Command to reach the Argo CD UI at http://localhost:8080."
  value       = "kubectl -n ${local.argocd_namespace} port-forward svc/argocd-server 8080:80"
}
