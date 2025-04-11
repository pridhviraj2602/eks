variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where Gitaly instances will run"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "universal_ami_id" {
  description = "AMI ID for Gitaly (Universal AMI built by Packer)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for Gitaly"
  type        = string
  default     = "t3.medium"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
  default     = ""
}

variable "gitaly_count" {
  description = "Number of Gitaly instances"
  type        = number
  default     = 3
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}

resource "aws_security_group" "gitaly_sg" {
  name   = "gitaly-sg"
  vpc_id = var.vpc_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, { Name = "gitaly-sg" })
}

resource "aws_instance" "gitaly" {
  count         = var.gitaly_count
  ami           = var.universal_ami_id
  instance_type = var.instance_type
  subnet_id     = element(var.subnet_ids, count.index % length(var.subnet_ids))
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.gitaly_sg.id]

  user_data = base64encode(
    templatefile("${path.module}/userdata-gitaly.sh", {})
  )

  tags = merge(var.tags, { Name = "gitaly-${count.index}" })
}

output "gitaly_instance_ids" {
  description = "IDs of Gitaly EC2 instances"
  value       = aws_instance.gitaly[*].id
}

output "gitaly_instance_public_ips" {
  description = "Public IPs of Gitaly EC2 instances"
  value       = aws_instance.gitaly[*].public_ip
}
