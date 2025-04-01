resource "aws_subnet" "nodegroup_subnets" {
  for_each = {
    for pair in flatten([
      for nodegroup, config in var.eks_nodegroups : [
        for subnet, subnet_config in config.subnets : {
          nodegroup = nodegroup
          subnet    = subnet
          config    = subnet_config
        }
        if subnet_config.existing_subnet_id == null
      ]
    ]) : "${pair.nodegroup}-${pair.subnet}" => pair.config
  }

  vpc_id            = var.eks_vpc_id
  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone
}

locals {
  nodegroup_subnets = {
    for nodegroup, config in var.eks_nodegroups : nodegroup => [
      for subnet, subnet_config in config.subnets : subnet_config.existing_subnet_id != null ? subnet_config.existing_subnet_id : try(aws_subnet.nodegroup_subnets["${nodegroup}-${subnet}"].id, null)
    ]
  }
}

module "eks_self-managed-node-group" {
    for_each = var.eks_nodegroups

    source  = "terraform-aws-modules/eks/aws//modules/self-managed-node-group"
    version = "20.33.1"

    subnet_ids = [for id in local.nodegroup_subnets[each.key] : id if id != null]
    user_data_template_path = templatefile("${path.module}/proxy-ec2-data.tftpl", {
        proxy_hostname = var.proxy_hostname,
        proxy_port = var.proxy_port,
        cluster_name = var.cluster_name,
        api_server_url = module.eks.cluster_endpoint,
        cluster_ca = module.eks.cluster_certificate_authority_data,
        cluster_service_cidr = var.cluster_service_cidr,
        no_proxy = var.no_proxy,
    }

    )
    cluster_name = var.cluster_name
    cluster_version = var.cluster_version
    cluster_endpoint = module.eks.cluster_endpoint
    cluster_auth_base64 = module.eks.cluster_certificate_authority_data
    vpc_security_group_ids = [
        module.eks.cluster_primary_security_group_id,
        module.eks.cluster_security_group_id,
    ]

    min_size = each.value.min_size
    max_size = each.value.max_size
    desired_size = each.value.desired_size
    instance_type = each.value.instance_type
    key_name = each.value.key_name
    name = each.value.node_group_name
    launch_template_description = "${each.value.node_group_name}'s launch template"
    launch_template_tags = {
        Name = "${each.value.node_group_name}-template"
        Terraform = true
    }
    cluster_service_cidr = module.eks.cluster_service_cidr
    create_iam_role_policy = false
    iam_role_arn = var.nodegroup_iam_role
    

    tags = each.value.tags
}