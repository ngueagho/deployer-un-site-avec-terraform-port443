terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
}

# Configure the AWS Provider
provider "aws" {
  access_key= "AKIATFGZ234CNNY3FCGG"
  secret_key= "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"
  region = "eu-west-3"
}

resource "aws_route53_record" "robertorouteresord" {
  zone_id = "Z01521282WUA78DJNWS3N"
  name    = "roberto.itengineeringpro.fr"
  type    = "A"
  ttl     = 300
  records = ["149.100.159.199"]
}

resource "kubernetes_deployment" "robertoimagine" {
  metadata {
    name = "roberto-deployment"
    namespace = "roberto"
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "roberto-app"
      }
    }

    template {
      metadata {
        labels = {
          app = "roberto-app"
        }
      }

      spec {
        container {
          name  = "roberto-container"
          image = "robertolandry/myportfolio-https-port443:latest"
          port {
            container_port = 443
          }
        }
        node_name ="master"
      }
    }
  }
}

resource "kubernetes_service" "robertomyservice" {
  metadata {
    name = "robertomyservice"
    namespace = "roberto"
  }

  spec {
    selector = {
      app = "roberto-app"
    }

    port {
      protocol = "TCP"
      node_port = 30333
      port     = 443
      target_port = 443
    }

    type = "NodePort"
  }
}

resource "kubernetes_ingress_v1" "robertoingress" {

    metadata {
      name = "robertoingress"
      namespace = "roberto"

      annotations = {
        
        "nginx.ingress.kubernetes.io/rewrite-target" = "/$1"
        "kubernetes.io/ingress.class" = "nginx"
      }
    }
    spec {
      ingress_class_name = "nginx"
      rule {
        host = "roberto.itengineeringpro.fr"
        http {
         path {
          path = "/(.*)"
           backend {
             service {
               name = kubernetes_service.robertomyservice.metadata[0].name
               port {
                 number = 443
               }
             }
           }
         }
        }
      }
    }
  }
