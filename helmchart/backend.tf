terraform {
  required_version = ">= 0.13.1"

  backend "s3" {
    region         = "us-east-1"
    bucket         = "defenseunicorns-dashdays-bucket"
    key            = "helmchart/terraform.tfstate"
    dynamodb_table = "defenseunicorns-dashdays-bucket-lock"
    encrypt        = "true"
  }
}
