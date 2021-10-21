module "terraform_state_backend" {
  source = "cloudposse/tfstate-backend/aws"
  version = "0.37.0"
  namespace = "defenseunicorns"
  stage = "dashdays"
  name = "bucket"
  terraform_backend_config_file_path = "."
  terraform_backend_config_file_name = "backend.tf"
  force_destroy = true
}