resource "aws_iam_role" "iam_role" {
  name               = var.eks_role
  path               = "/"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}


# Attaching the EKS-Cluster policies to the terraformekscluster role.

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  count      = length(var.policy_arn)
  policy_arn = var.policy_arn[count.index]
  role       = aws_iam_role.iam_role.name
}

resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.iam_role.arn

  vpc_config {
    subnet_ids              = var.subnet_ids
    security_group_ids      = var.security_group_ids
    public_access_cidrs     = var.public_access_cidrs
    endpoint_public_access  = var.endpoint_public_access
    endpoint_private_access = var.endpoint_private_access
  }
  depends_on = [
    aws_iam_role_policy_attachment.policy_attachment
  ]

  enabled_cluster_log_types = var.enable_log_types

  dynamic "encryption_config" {
    for_each = length(keys(var.arn)) == 0 ? [] : [true]
    content {
      provider {
        key_arn = data.aws_kms_key.key_arn.id
      }
      resources = var.encryption_resources
    }
  }

  # tags    = var.tags
  # version = var.k8s_version


}


data "aws_kms_key" "key_arn" {
  key_id = var.arn
}