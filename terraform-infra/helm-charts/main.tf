provider "helm" {
  kubernetes {
    config_path = "C:/Users/Lenovo/.kube/config"
  }
}

resource "helm_release" "flask_app" {
  name       = var.app_name
  namespace  = var.namespace
  chart      = var.chart_path
  values     = [file(var.values_file)]

  create_namespace = true
  # atomic           = true
  cleanup_on_fail  = true
}
