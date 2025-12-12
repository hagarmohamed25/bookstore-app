/*# terraform/backend.tf

terraform {
  backend "s3" {
    bucket = "my-unique-terraform-state-bucket" # Replace with your bucket name
    key    = "nexus-project/terraform.tfstate"   # A path within the bucket
    region = "us-east-1"                         # Your AWS region
  }
}

# It's better to manage the bucket itself with Terraform
# to enforce best practices like versioning and lifecycle rules.
resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-unique-terraform-state-bucket" # Must be the same name as in the backend block
}

# Enable versioning to protect your state file
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Add a lifecycle policy to automatically delete old versions
resource "aws_s3_bucket_lifecycle_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    id     = "terraform_state_cleanup"
    status = "Enabled"

    noncurrent_version_expiration {
      # Keep only the 10 most recent non-current versions
      noncurrent_days = 30 # Deletes versions older than 30 days
      # Alternatively, you could use newer_max_noncurrent_versions to keep a set number
    }
  }
}*/