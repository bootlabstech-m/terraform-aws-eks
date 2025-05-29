terraform {
  required_version = ">= 0.13"
  backend "s3" {}
} 

provider "aws" {
  assume_role { 
  role_arn  = var.role_arn
 } 
 region   = var.region
}