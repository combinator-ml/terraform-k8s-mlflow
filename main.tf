terraform {
  required_providers {
    k8s = {
      version = ">= 0.8.0"
      source  = "banzaicloud/k8s"
    }
    kubernetes = {
      version = "= 1.13.3"
    }
  }
  required_version = ">= 0.12"
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
}

provider "k8s" {
  config_path    = "~/kube/config"
}

provider "helm" {
  kubernetes {
   config_path    = "~/.kube/config"
 }
}

resource "kubernetes_namespace" "ns" {
  metadata {
    name = "mlflow"
  }
}

module "mlflow" {
  source  = "terraform-module/release/helm"
  repository = "./helm-mlflow"
  namespace  = kubernetes_namespace.ns.metadata.0.name

  app = {
    chart      = "mlflow"
    version    = "1.0.1"
    name       = "mlflow"
    force_update  = true
    wait          = false
    recreate_pods = false
    deploy        = 1
  }

  values = [
    file("conf/mlflow_values.yaml")
  ]

  set = [
    {
      name  = "prometheus.expose"
      value = true
    }
  ]
}

module "minio" {
  source  = "terraform-module/release/helm"
  repository = "https://helm.min.io/"
  namespace  = kubernetes_namespace.ns.metadata.0.name

  app = {
    chart      = "minio"
    version    = "8.0.9"
    name       = "minio"
    force_update  = true
    wait          = false
    recreate_pods = false
    deploy        = 1
  }

  values = [
    file("conf/minio_values.yaml")
  ]

  set = [
    {
      name  = "accessKey"
      value = "minio"
    },{
      name  = "secretKey"
      value = "minio123"
    },{
      name  = "generate-name"
      value = "minio/minio"
    },{
      name  = "service.port"
      value = 9000
    }
  ]
}

module "mysql" {
  source  = "terraform-module/release/helm"
  repository = "https://charts.bitnami.com/bitnami"
  namespace  = kubernetes_namespace.ns.metadata.0.name

  app = {
    chart      = "mysql"
    version    = "8.0.0"
    name       = "mysql"
    force_update  = true
    wait          = false
    recreate_pods = false
    deploy        = 1
  }

  values = [
    file("conf/mysql_values.yaml")
  ]

}

resource "kubernetes_secret" "mysql_password" {
  metadata {
    name      = "mlflow-mysql"
    namespace = kubernetes_namespace.ns.metadata.0.name
  }
  data = {
    password = "mysql123"
  }
}

resource "kubernetes_service" "mlflow_external" {
  metadata {
    name      = "mlflow-external"
    namespace = kubernetes_namespace.ns.metadata.0.name
  }
  spec {
    selector = {
      "app.kubernetes.io/instance" = "mlflow"
      "app.kubernetes.io/name" = "mlflow"
    }
    type = "NodePort"
    port {
      node_port   = 30600
      port        = 80
      target_port = 80
    }
  }
}

resource "kubernetes_service" "minio_external" {
  metadata {
    name      = "minio-external"
    namespace = kubernetes_namespace.ns.metadata.0.name
  }
  spec {
    selector = {
      "app" = "minio"
      "release" = "minio"
    }
    type = "NodePort"
    port {
      node_port   = 30650
      port        = 9000
      target_port = 9000
    }
  }
}
