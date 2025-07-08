###########################
# IAM ROLE FOR EKS CLUSTER
###########################

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

# Attaching the EKS-Cluster policies to the terraform-eks-cluster role.

resource "aws_iam_role_policy_attachment" "cluster_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  ])
  policy_arn = each.value
  role       = aws_iam_role.iam_role.name
}

###########################
# SECURITY GROUP
###########################

resource "aws_security_group" "eks_sg" {
  name        = "${var.cluster_name}-eks-sg"
  description = "Security group for EKS control plane"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow communication from worker nodes"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.public_access_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-eks-sg"
  }
}

###########################
# EKS CLUSTER
###########################

resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.iam_role.arn
  version  = var.k8s_version

  vpc_config {
    subnet_ids              = var.subnet_ids
    security_group_ids      = [aws_security_group.eks_sg.id]
    public_access_cidrs     = var.public_access_cidrs
    endpoint_public_access  = var.endpoint_public_access
    endpoint_private_access = var.endpoint_private_access
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.service_ipv4_cidr
    ip_family         = "ipv4"
  }

  enabled_cluster_log_types = var.enable_log_types

  dynamic "encryption_config" {
    for_each = var.kms_key_arn != "" ? [true] : []
    content {
      provider {
        key_arn = var.kms_key_arn
      }
      resources = var.encryption_resources
    }
  }
  depends_on = [
    aws_iam_role_policy_attachment.cluster_policies
  ]
}

###########################
# IAM ROLE FOR NODE GROUP
###########################

resource "aws_iam_role" "example" {
  name = "eks-node-group-example"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "node_role_policy_attachments" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ])
  policy_arn = each.key
  role       = aws_iam_role.example.name
}


###########################
# EKS NODE GROUP
###########################

resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "eks-nodegroup-example"
  node_role_arn   = aws_iam_role.example.arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_role_policy_attachments
  ]
  lifecycle {
    ignore_changes = [
      scaling_config[0].desired_size,

    ]

  }
}