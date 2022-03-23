output "reporter_role_arn" {
  value       = var.use_default_config ? module.aws_config[0].aws_config_role_arn : ""
  description = "ARN of the role that the config reported uses. Add to receiver"
}
