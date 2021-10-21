provider "aws" {
  region = var.region
}

module "eks_cluster" {
  source = "git::https://github.com/defenseunicorns/aws-eks?ref=feature/module-updates-2"
  kubernetes_version = "1.21"
  cluster_name = var.cluster_name
  map_users = var.map_users
  map_roles = var.map_roles
  write_kubeconfig = false
}

#module "big_bang" {
#  source = "git::https://repo1.dso.mil/platform-one/big-bang/terraform-modules/big-bang-terraform-launcher.git?ref=tags/v0.3.0"
#  big_bang_manifest_file = "bigbang/start.yaml"
#  kube_conf_file = "${path.module}/kubeconfig.yaml"
#  registry_credentials = var.registry1_credentials
#}
