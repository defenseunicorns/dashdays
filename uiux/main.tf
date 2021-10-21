

module "eks_cluster" {
  source = "git::https://github.com/defenseunicorns/aws-eks?ref=feature/module-updates-2"
  kubernetes_version = "1.21"
  cluster_name = var.cluster_name
  map_users = var.map_users
}

resource "local_file" "kubeconfig" {
  content = module.eks_cluster.kubectl_config
  filename = "${path.module}/kubeconfig.yaml"
}

resource "aws_s3_bucket_object" "kubeconfig" {
  bucket = var.kubeconfig_bucket
  key = "kubeconfigs/${var.cluster_name}.yaml"
  source = "${path.module}/kubeconfig.yaml"
}

module "big_bang" {
  source = "git::https://repo1.dso.mil/platform-one/big-bang/terraform-modules/big-bang-terraform-launcher.git?ref=tags/v0.3.0"
  count = var.needs_big_bang ? 1 : 0
  kube_conf_file = "${path.module}/kubeconfig.yaml"
  registry_credentials = var.registry1_credentials
}
