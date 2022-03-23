<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
# AWS Config Reporter

## Description

For the reporting of aws config findings to an external system

## Usage

Use with centralized report receiver for provisioned reporting role and stream

Resources:

* [Article Example](https://article.example.com)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_config"></a> [aws\_config](#module\_aws\_config) | trussworks/config/aws | ~> 4.5 |
| <a name="module_logs"></a> [logs](#module\_logs) | trussworks/logs/aws | >11.0.0 |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_event_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_rule) | resource |
| [aws_cloudwatch_event_target.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_event_target) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kinesis_stream_arn"></a> [kinesis\_stream\_arn](#input\_kinesis\_stream\_arn) | n/a | `string` | n/a | yes |
| <a name="input_role_arn"></a> [role\_arn](#input\_role\_arn) | n/a | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | <pre>object({<br>    Project     = string<br>    Environment = string<br>    Application = string<br>  })</pre> | <pre>{<br>  "Application": "configreporter",<br>  "Environment": "dev",<br>  "Project": "elmo"<br>}</pre> | no |
| <a name="input_use_default_config"></a> [use\_default\_config](#input\_use\_default\_config) | Determines if module deploys own aws config resource with good defaults or just the subscription to existing reporting | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_reporter_role_arn"></a> [reporter\_role\_arn](#output\_reporter\_role\_arn) | ARN of the role that the config reported uses. Add to receiver |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
