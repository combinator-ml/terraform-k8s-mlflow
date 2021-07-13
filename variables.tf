variable "name_prefix" {
  description = "Prefix to be used when naming the different components."
  type        = string
  default     = "combinator"
}

variable "namespace" {
  description = "The namespace to install into."
  type        = string
  default     = "mlflow"
}
