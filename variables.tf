variable "region" {
  type    = string
}

variable "eks_role" {
  type        = string
  description = "Enter unique name for EKS role"
}

variable "policy_arn" {
  type        = list(string)
  description = "List of policies to be attached to eks-role."
}

variable "cluster_name" {
  type        = string
  description = "Name of the cluster. Must be between 1-100 characters in length. Must begin with an alphanumeric character, and must only contain alphanumerics."
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs. Must be in at least two different availability zones. Amazon EKS creates cross-account elastic network interfaces in these subnets to allow communication between your worker nodes and the Kubernetes control plane."
}

variable "security_group_ids" {
  type        = list(string)
  description = "(Optional) List of security group IDs for the cross-account elastic network interfaces that Amazon EKS creates to use to allow communication between your worker nodes and the Kubernetes control plane."

}

variable "public_access_cidrs" {
  type        = list(string)
  description = "(Optional) List of CIDR blocks. Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled. EKS defaults this to a list with 0.0.0.0/0. Terraform will only perform drift detection of its value when present in a configuration."
}

variable "endpoint_public_access" {
  type        = bool
  description = "(Optional) Whether the Amazon EKS public API server endpoint is enabled. Default is true."
}

variable "endpoint_private_access" {
  type        = bool
  description = "(Optional) Whether the Amazon EKS private API server endpoint is enabled. Default is false."
}
variable "enable_log_types" {
  type        = list(string)
  description = "Optional) List of the desired control plane logging to enable."
}
variable "k8s_version" {
  type        = string
  description = "Desired Kubernetes master version. If you do not specify a value, the latest available version at resource creation is used and no upgrades will occur except those automatically triggered by EKS. The value must be configured and increased to upgrade the version when desired. Downgrades are not supported by EKS."
}

variable "encryption_resources" {
  type    = list(string)
}

variable "kms_key_arn" {
  type        = string
  description = "(Required) ARN of the Key Management Service (KMS) customer master key (CMK). The CMK must be symmetric, created in the same region as the cluster, and if the CMK was created in a different account, the user must have access to the CMK."
}
variable "role_arn" {
  description = " The ARN of the IAM role"
  type = string
}
variable "ip_family" {
  description = "IP family"
  type = string
}
variable "service_ipv4_cidr" {
  description = "Service IP CIDR"
  type = string
}


 