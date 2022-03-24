/**
 * # AWS Config Reporter
 *
 * ## Description
 *
 * For the reporting of aws config findings to an external system
 *
 * ## Usage
 *
 * Use with centralized report receiver for provisioned reporting role and stream
 *
 * Resources:
 *
 * * [Article Example](https://article.example.com)
TODO

 ```hcl

 module "example" {
    source = "dod-iac/example/aws"

    tags = {
      Project     = var.project
      Application = var.application
      Environment = var.environment
      Automation  = "Terraform"
    }
  }
 ```
 *
 * ## Testing
 *
 * Run all terratest tests using the `terratest` script.  If using `aws-vault`, you could use `aws-vault exec $AWS_PROFILE -- terratest`.  The `AWS_DEFAULT_REGION` environment variable is required by the tests.  Use `TT_SKIP_DESTROY=1` to not destroy the infrastructure created during the tests.  Use `TT_VERBOSE=1` to log all tests as they are run.  Use `TT_TIMEOUT` to set the timeout for the tests, with the value being in the Go format, e.g., 15m.  The go test command can be executed directly, too.
 *
 * ## Terraform Version
 *
 * Terraform 0.13. Pin module version to ~> 1.0.0 . Submit pull-requests to master branch.
 *
 * Terraform 0.11 and 0.12 are not supported.
 *
 * ## License
 *
 * This project constitutes a work of the United States Government and is not subject to domestic copyright protection under 17 USC § 105.  However, because the project utilizes code licensed from contributors and other third parties, it therefore is licensed under the MIT License.  See LICENSE file for more information.
 *
 * ## Developer Setup
 *
 * This template is configured to use aws-vault, direnv, go, pre-commit, terraform-docs, and tfenv.  If using Homebrew on macOS, you can install the dependencies using the following code.
 *
 * ```shell
 * brew install aws-vault direnv go pre-commit terraform-docs tfenv
 * pre-commit install --install-hooks
 * ```
 *
 * If using `direnv`, add a `.envrc.local` that sets the default AWS region, e.g., `export AWS_DEFAULT_REGION=us-west-2`.
 *
 * If using `tfenv`, then add a `.terraform-version` to the project root dir, with the version you would like to use.
 *
 *
 */

module "aws_config" {
  count   = var.use_default_config ? 1 : 0
  source  = "trussworks/config/aws"
  version = "~> 4.5"

  config_name        = "aws-config"
  config_logs_bucket = module.logs.aws_logs_bucket

  check_mfa_enabled_for_iam_console_access = true
  check_rds_snapshots_public_prohibited    = true
  check_rds_public_access                  = true
  check_restricted_ssh                     = true
  check_required_tags                      = true
  check_rds_storage_encrypted              = true
  check_iam_root_access_key                = true
  check_iam_password_policy                = true
  check_ec2_encrypted_volumes              = true
  required_tags                            = { "tag1Key" : "Project", "tag2Key" : "Application", "tag3Key" : "Environment" }
}

module "logs" {
  source             = "trussworks/logs/aws"
  s3_bucket_name     = format("%s-aws-logs", local.namingprexfix)
  allow_config       = true
  config_logs_prefix = "config"
  force_destroy      = true
  version            = ">=11.0.0"
}



resource "aws_cloudwatch_event_rule" "this" {
  name        = "report-config-updates"
  description = "Report all aws config updates"

  event_pattern = <<EOF
{
  "source": ["aws.config"],
  "detail-type": ["Config Rules Compliance Change"]
}
EOF
}

resource "aws_cloudwatch_event_target" "this" {
  rule     = aws_cloudwatch_event_rule.this.name
  arn      = var.kinesis_stream_arn
  role_arn = var.role_arn
}
