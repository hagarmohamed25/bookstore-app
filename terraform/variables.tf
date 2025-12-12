/*# terraform/variables.tf

variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "The EC2 instance type."
  type        = string
  default     = "t3.small"
}

variable "key_name" {
  description = "The name of the EC2 Key Pair to use for the instance."
  type        = string
  default     = "nexus-key"
}

variable "my_ip" {
  description = "My current public IP address for secure access."
  type        = string
}*/

variable "aws_region" {
  description = "The AWS region to deploy resources in."
  type        = string
  default     = "us-east-1"
}

variable "key_name" {
  description = "The name of the EC2 Key Pair to use for the instance."
  type        = string
  default     = "nexus-key"
}

variable "instance_type" {
  description = "The EC2 instance type."
  type        = string
  default     = "t3.small"
}

variable "aws_az" {
  description = "The availability zone to use."
  type        = string
  default     = "us-east-1a"
}