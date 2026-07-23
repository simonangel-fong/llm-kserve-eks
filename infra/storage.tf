# storage.tf

resource "kubernetes_storage_class_v1" "gp3_encrypted" {
  metadata {
    name = "gp3-encrypted"

    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  storage_provisioner    = "ebs.csi.aws.com"
  reclaim_policy         = "Delete"
  volume_binding_mode    = "WaitForFirstConsumer"
  allow_volume_expansion = true

  parameters = {
    type      = "gp3"
    encrypted = "true"
    kmsKeyId  = aws_kms_key.platform.arn
    fsType    = "ext4"
  }

  depends_on = [aws_eks_addon.ebs_csi]
}
