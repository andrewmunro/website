---
title: 'Homelab Server'
description: A containerized home server running on a ThinkCentre for development and hosting services.
publishDate: 'Jan 02 2024'
seo:
    image:
        src: '/homelab/homelab-server.png'
        alt: ThinkCentre homelab server with banana for scale
---

![Homelab Server](/homelab/homelab-server.png)

My personal homelab running on a compact Lenovo ThinkCentre M series tiny desktop. This server handles all my development work through VSCode remote sessions and hosts various containerized services and websites.

## Description

- **Development Environment:** Primary coding and development server I use, accessed via VSCode remote
- **Container Orchestration:** Full Kubernetes cluster managed with Rancher
- **Service Hosting:** I used to pay a fortune for digital ocean / aws VPS's. Now I can run multiple websites and applications as containerized services for free.
- **Low Power and Compact:** Takes up barely any space and uses very little power.
- **Always-On Infrastructure:** As long as my home fibre doesn't go down, the server is always on.

## Tech

- **Hardware:** Lenovo ThinkCentre M series tiny desktop
- **Container Platform:** [Kubernetes](https://kubernetes.io) for container orchestration and management
- **Management UI:** [Rancher](https://rancher.com) for simplified Kubernetes cluster management
- **Package Manager:** [Helm](https://helm.sh) for deploying and managing Kubernetes applications
- **Development:** VSCode Remote for seamless remote development experience
- **Network Security:** [Cloudflare](https://cloudflare.com) with cloudflared tunnels for secure endpoint access
- **Access Control:** [Cloudflare Zero Trust](https://www.cloudflare.com/zero-trust/) for identity-based security
- **Architecture:** Everything containerized for consistency and easy deployment

## Features

- **Remote Development:** Full VSCode development environment accessible from anywhere
- **Container-First:** All services and applications run as containers for isolation and portability
- **Kubernetes Native:** Production-grade orchestration for personal projects and services
- **Rancher Management:** Web-based UI for easy cluster management and monitoring
- **Helm Deployments:** Standardized application deployments with version control
- **Multi-Service Hosting:** Running various websites and applications simultaneously
- **Secure Access:** Cloudflare tunnels eliminate need for port forwarding while protecting all endpoints
- **Zero Trust Security:** Identity-based access control ensuring only authorized users can reach services

## Outcome and Future Improvements

The homelab has become an essential part of my development workflow, providing a central, consistent and powerful environment for all my projects that I can access from anywhere in the world. The containerized approach makes it easy to experiment with new technologies and deploy services reliably.

Future improvements could include:
- Move more stuff to IaC
	- I tend to be lazy and just manually deploy stuff via the rancher UI, then update via github actions.
- Backups
	- 🙈 Most stuff is backed up on git, but I should probably have a proper backup solution.