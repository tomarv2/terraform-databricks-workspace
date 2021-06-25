module "vpc" {
  source = "git::git@github.com:tomarv2/terraform-aws-vpc.git?ref=v0.0.2"

  aws_region = var.aws_region
  # -----------------------------------------
  # Do not change the teamid, prjid once set.
  teamid = var.teamid
  prjid  = "${var.prjid}-${local.suffix}"
}

module "iam_role" {
  source = "git::git@github.com:tomarv2/terraform-aws-iam-role.git//modules/iam_role_external?ref=v0.0.4"

  count = var.existing_role_name == null ? 1 : 0

  assume_role_policy = data.databricks_aws_assume_role_policy.this.json
  external_id        = var.databricks_account_id
  # -----------------------------------------
  # Do not change the teamid, prjid once set.
  teamid = var.teamid
  prjid  = "${var.prjid}-${local.suffix}"

  providers = {
    aws = aws.iam-management
  }
}

module "iam_policies" {
  source = "git::git@github.com:tomarv2/terraform-aws-iam-policies.git?ref=v0.0.4"

  count = var.existing_role_name == null ? 1 : 0

  role_name     = join("", module.iam_role.*.iam_role_name)
  policy        = data.databricks_aws_crossaccount_policy.cross_account_iam_policy.json
  inline_policy = true
  # -----------------------------------------
  # Do not change the teamid, prjid once set.
  teamid = var.teamid
  prjid  = "${var.prjid}-${local.suffix}"

  providers = {
    aws = aws.iam-management
  }
}

module "s3" {
  source = "git::git@github.com:tomarv2/terraform-aws-s3.git?ref=v0.0.3"

  aws_region = var.aws_region
  # -----------------------------------------
  # Do not change the teamid, prjid once set.
  teamid = var.teamid
  prjid  = "${var.prjid}-${local.suffix}"
}
