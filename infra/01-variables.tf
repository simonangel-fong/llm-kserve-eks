# 01-variables.tf

variable "env" {
  description = "Deployment environment. Used to namespace resource names and tags."
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "stg", "prod"], var.env)
    error_message = "env must be one of: dev, stg, prod."
  }
}
