# Create variables for anything you think might be used.
# Ensure all vars have defaults where possible

variable "namespace" {
  description = "The namespace to install into."
  type        = string
  default     = "default"
}
