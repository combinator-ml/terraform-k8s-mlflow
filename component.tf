# Try to avoid hard coding any variables. They should be vars or locals.

resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.namespace
  }
}
