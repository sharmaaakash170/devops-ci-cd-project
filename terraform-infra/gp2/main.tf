provider "kubernetes" {
  host                   = var.cluster_endpoint
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  token                  = var.token
}

resource "kubernetes_storage_class" "gp2_new" {
  metadata {
    name = "gp2-new"
    annotations = {
      "storageclass.kubernetes.io/is-default-class" = "true"
    }
  }

  parameters = {
    type   = "gp2"
    fsType = "ext4"
  }

  storage_provisioner = "kubernetes.io/aws-ebs"

  reclaim_policy      = "Retain"
  volume_binding_mode = "WaitForFirstConsumer"

  lifecycle {
    prevent_destroy = false
    ignore_changes  = all
  }
}
