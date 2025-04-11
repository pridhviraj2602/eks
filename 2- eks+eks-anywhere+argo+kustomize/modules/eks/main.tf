##################################################
# IAM for EKS Cluster
##################################################
resource "aws_iam_role" "eks_cluster_role" {
  name               = "${var.cluster_name}-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role.json
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

##################################################
# IAM for Self-Managed Worker Nodes
##################################################
resource "aws_iam_role" "eks_node_role" {
  name               = "${var.cluster_name}-node-role"
  assume_role_policy = data.aws_iam_policy_document.eks_node_assume_role.json
}

resource "aws_iam_role_policy_attachment" "eks_node_policy_1" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_node_policy_2" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node_role.name
}

##################################################
# EKS Cluster (Control Plane)
##################################################
resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
  ]
}

data "aws_eks_cluster" "this" {
  name = aws_eks_cluster.this.name
}

data "aws_eks_cluster_auth" "this" {
  name = data.aws_eks_cluster.this.name
}

##################################################
# Node Instance Profile
##################################################
resource "aws_iam_instance_profile" "node_instance_profile" {
  name = "${var.cluster_name}-node-instance-profile"
  role = aws_iam_role.eks_node_role.name
}

##################################################
# Launch Template for Self-Managed Worker Nodes
##################################################
resource "aws_launch_template" "node_lt" {
  name_prefix   = "${var.cluster_name}-nodes-"
  image_id      = var.worker_ami_id
  instance_type = var.worker_instance_type
  vpc_security_group_ids = var.worker_security_group_ids

  user_data = base64encode(
    templatefile("${path.module}/userdata-eks.sh", {
      cluster_name = aws_eks_cluster.this.name
      region       = var.region
    })
  )

  iam_instance_profile {
    name = aws_iam_instance_profile.node_instance_profile.name
  }

  tags = var.tags
}

##################################################
# Auto Scaling Group for Self-Managed Nodes
##################################################
resource "aws_autoscaling_group" "nodes_asg" {
  name                = "${var.cluster_name}-node-asg"
  max_size            = var.node_asg_max_size
  min_size            = var.node_asg_min_size
  desired_capacity    = var.node_asg_desired_capacity
  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.node_lt.id
    version = "$Latest"
  }

  tags = [
    {
      key                 = "Name"
      value               = "${var.cluster_name}-node"
      propagate_at_launch = true
    },
    {
      key                 = "k8s.io/cluster/${aws_eks_cluster.this.name}"
      value               = "owned"
      propagate_at_launch = true
    }
  ]

  depends_on = [
    aws_eks_cluster.this
  ]
}

##################################################
# IAM Policy Documents
##################################################
data "aws_iam_policy_document" "eks_cluster_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "eks_node_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
