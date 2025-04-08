provider "kubernetes" {
  config_path = "C:/Users/Lenovo/.kube/config"
}    

resource "kubernetes_service" "jenkins_lb" {
  metadata {
    name      = "jenkins-lb"
    namespace = "default"

    labels = {
      app = "jenkins"
    }
  }

  spec {
    selector = {
      app = "jenkins"
    }

    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}
