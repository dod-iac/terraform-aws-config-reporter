variable "tags" {
  type = object({
    Project     = string
    Environment = string
    Application = string
  })
  default = {
    Project     = "elmo"
    Environment = "dev"
    Application = "configreporter"
  }
}


locals {
  project       = var.tags.Project
  environment   = var.tags.Environment
  application   = var.tags.Application
  namingprexfix = "${local.project}-${local.environment}-${local.application}"
}

variable "kinesis_stream_arn" {
  type = string
}
variable "role_arn" {
  type = string
}
variable "use_default_config" {
  type        = bool
  default     = true
  description = "Determines if module deploys own aws config resource with good defaults or just the subscription to existing reporting"
}
