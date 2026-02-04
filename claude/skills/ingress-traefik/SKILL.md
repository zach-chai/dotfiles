---
name: onboard-ingress-traefik
description: This skill should be used when the user asks to "onboard to ingress traefik", "add ingress traefik", "add ingress", "setup reverse proxy", or wants to connect a Docker service to the Traefik ingress network for HTTPS access.
---

# Onboard Service to Traefik

Add this service to the Traefik reverse proxy at ingress-apps network.

## Requirements

1. Find the docker-compose.yml in this repo
2. Identify the main service that needs external access
3. Ask for the subdomain (e.g., `myapp` for `myapp.lima.red`)
4. Ask for the container port if not obvious from the compose file

## Changes to make

Add the external network definition:

```yaml
networks:
  ingress-apps:
    external: true
```

Add the network to the service:

```yaml
services:
  <service>:
    networks:
      - ingress-apps
```

Add Traefik labels to the service (replace ROUTERNAME with a unique identifier):

```yaml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.ROUTERNAME.rule=Host(`SUBDOMAIN.lima.red`)"
  - "traefik.http.routers.ROUTERNAME.entrypoints=websecure"
  - "traefik.http.routers.ROUTERNAME.tls.certresolver=letsencrypt"
  - "traefik.http.services.ROUTERNAME.loadbalancer.server.port=PORT"
```

## After changes

Remind the user to:
1. Create a DNS A record for `SUBDOMAIN.lima.red` pointing to their server IP
2. Run `docker compose up -d` to start/restart the service
