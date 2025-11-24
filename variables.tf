provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  default = "us-east-1"
}
variable "request_bucket" {
  default = "eugene-unique-request-bucket"
}
variable "response_bucket" {
  default = "eugene-unique-response-bucket"
}