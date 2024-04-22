#!/bin/bash
# Install Docker
curl -fsSL https://get.docker.com | sh
groupadd docker
usermod -aG docker ubuntu
newgrp docker
# Install monitoring tool (Prometheus, Grafana)