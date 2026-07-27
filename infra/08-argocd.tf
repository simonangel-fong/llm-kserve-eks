# 08-argocd.tf

# ##############################
# Argo CD
# ##############################
resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = local.argocd_namespace
  create_namespace = true

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = local.argocd_version

  wait    = true
  timeout = 900

  values = [
    yamlencode({
      global = {
        nodeSelector = {
          role = "bootstrap"
        }
      }

      configs = {
        params = {
          "server.insecure" = true
        }
      }
    })
  ]
}
