cluster_name = "dashdays-helmchart"
kubeconfig_bucket = "defenseunicorns-dashdays-bucket"
map_users = []
map_roles = [
  {
    rolearn = "arn:aws:iam::950698127059:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS"
    username = "unicorn"
    groups = ["system:masters"]
  },
]
needs_big_bang = true
