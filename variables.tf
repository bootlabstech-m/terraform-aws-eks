variable "region" {
  type    = string
  default = "the region where you want to deploy the eks"
}

variable "role_arn" {
  type = string
  description = "ARN of the IAM role"
}

variable "eks_role" {
  type        = string
  description = "Enter unique name for EKS role"
}

variable "cluster_name" {
  type        = string
  description = "Name of the cluster. Must be between 1-100 characters in length. Must begin with an alphanumeric character, and must only contain alphanumerics."
}

variable "vpc_id" {
  type = string
}
variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs. Must be in at least two different availability zones. Amazon EKS creates cross-account elastic network interfaces in these subnets to allow communication between your worker nodes and the Kubernetes control plane."
}

variable "node_group_desired_size" {
  type        = number
  default     = 1
  description = "Desired number of worker nodes in the EKS node group."
}

variable "node_group_max_size" {
  type        = number
  default     = 2
  description = "Maximum number of worker nodes in the EKS node group."
}

variable "node_group_min_size" {
  type        = number
  default     = 1
  description = "Minimum number of worker nodes in the EKS node group."
}


variable "public_access_cidrs" {
  type        = list(string)
  description = "(Optional) List of CIDR blocks. Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled. EKS defaults this to a list with 0.0.0.0/0. Terraform will only perform drift detection of its value when present in a configuration."
  default     = ["0.0.0.0/0"] # 0.0.0.0/0 or 10.0.0.0/16 vpc cidr
}

variable "endpoint_public_access" {
  type        = bool
  description = "(Optional) Whether the Amazon EKS public API server endpoint is enabled. Default is true."
  default = true
}

variable "endpoint_private_access" {
  type        = bool
  description = "(Optional) Whether the Amazon EKS private API server endpoint is enabled. Default is false."
  default = true
}

variable "service_ipv4_cidr" {
  type = string
  description = "provide the cidr range"
  default = ""
}

variable "enable_log_types" {
  type        = list(string)
  description = "List of the desired control plane logging to enable."
}

variable "k8s_version" {
  type        = string
  description = "The k8s version"
}

variable "encryption_resources" {
  type = list(string)
  description = "list of resources you want to encrypt"
}

variable "kms_key_arn" {
  type        = string
  default = ""
  description = "(Required) ARN of the Key Management Service (KMS) customer master key (CMK). The CMK must be symmetric, created in the same region as the cluster, and if the CMK was created in a different account, the user must have access to the CMK."
}

