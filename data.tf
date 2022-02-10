data "aws_caller_identity" "current" {
}

data "aws_eks_cluster" "cluster" {
    name = var.cluster_name
}

locals {
    oidc       = trim(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://")
    account-id = data.aws_caller_identity.current.account_id
  }

data "aws_iam_policy_document" "this" {
    dynamic "statement" {
        for_each = var.enabled_sts_services
        iterator = enabled_sts_services
        content {
            sid = "GrantSTS${upper(enabled_sts_services.value)}"
            actions = ["sts:AssumeRole"]
            principals {
                type        = "Service"
                identifiers = ["${enabled_sts_services.value}.amazonaws.com"]
            }
            effect = "Allow"
        }
    }
    statement {
        sid = "GrantK8sSAAccessToAWS"
        actions = ["sts:AssumeRoleWithWebIdentity"]
        principals {
            type        = "Federated"
            identifiers = ["arn:aws:iam::${local.account-id}:oidc-provider/${local.oidc}"]
        }
        effect = "Allow"    
        condition {
            test = "StringEquals"
            variable = "${local.oidc}:sub"
            values = [
                "system:serviceaccount:${var.kubernetes_namespace}:${var.service_account_name}"
            ]
        }
   }
 }
