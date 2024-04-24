#!/bin/bash
# Install Docker
curl -fsSL https://get.docker.com | sh
groupadd docker
usermod -aG docker ubuntu
newgrp docker
# Install monitoring stack
docker compose -f /home/ubuntu/server-dc.yml up -d