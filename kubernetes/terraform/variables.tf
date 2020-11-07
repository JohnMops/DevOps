variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    {
      userarn  = "arn:aws:iam::535518648590:user/evgenibi"
      username = "john"
      groups   = ["system:masters"]
    },
  ]
}

variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))

  default = [
    //{
    //  rolearn  = "arn:aws:iam::861419891964:role/terraform-role"
    //  username = "terraform"
    //  groups   = ["system:masters"]
    //},
  ]
}