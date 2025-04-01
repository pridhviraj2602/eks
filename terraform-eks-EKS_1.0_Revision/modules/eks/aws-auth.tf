module "aws-auth" {
  source  = "terraform-aws-modules/eks/aws//modules/aws-auth"
  version = "~> 20.0"

  manage_aws_auth_configmap = true

  aws_auth_roles = [
    {
      rolearn  = var.admin_iam_role
      username = "${var.admin_user_name}/*"
      groups   = ["system:masters"]
    },
    {
      rolearn  = var.cluster_iam_role
      username = "system:node{{SessionName}}"
      groups   = ["system:bootstrappers","system:nodes"]
    },
  ]


}