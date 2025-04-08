provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "flask_app" {
  name       = var.app_name
  namespace  = var.namespace
  chart      = var.chart_path
  values     = [file(var.values_file)]

  wait       = false 
  timeout    = 600  
  create_namespace = true
  # atomic           = true
  cleanup_on_fail  = true
}
