region = "us-east-2"
cluster_name = "dashdays-uiux"
kubeconfig_bucket = "defenseunicorns-dashdays-bucket"
map_users = []
map_roles = [
  {
    rolearn = "arn:aws:iam::950698127059:role/unicorn-dash-days-eks-user"
    username = "unicorn"
    groups = ["system:masters"]
  },
]
needs_big_bang = true
