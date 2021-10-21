variable "cluster_name" {
  type = string
}
variable "map_users" {
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
}
variable "kubeconfig_bucket" {
  type = string
}
variable "needs_big_bang" {
  type = bool
}
variable "registry1_credentials" {
  type = list(object({
    registry = string
    username = string
    password = string
  }))
}