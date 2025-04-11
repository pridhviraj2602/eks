#!/bin/bash
set -ex

# Start Docker
systemctl start docker

echo "Configuring Gitaly instance..."
# Place any additional Gitaly initialization or configuration here.
