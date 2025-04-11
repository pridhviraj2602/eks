#!/bin/bash
set -eux

# Update and install common packages
yum update -y
yum install -y docker
systemctl enable docker

# Pre-install common dependencies for both EKS nodes and Gitaly
mkdir -p /opt/gitaly
echo "Gitaly pre-install placeholder" > /opt/gitaly/README

echo "Universal AMI build complete."
