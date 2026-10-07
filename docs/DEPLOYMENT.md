# Hestia Deployment

## Requirements

Hestia requires:

- Linux
- Docker Engine
- Docker Compose
- persistent configuration storage
- bulk media/data storage
- appropriate filesystem permissions

Jellyfin hardware acceleration is optional but recommended.

## Environment

Create the deployment environment from the supplied example:

    cp .env.example .env

The default storage locations are:

    HESTIA_CONFIG_ROOT=/opt/hestia/config
    HESTIA_DATA_ROOT=/srv/hestia/data

These can be changed for another deployment without modifying the
Compose file.

## User and Group IDs

The deployment uses numeric user and group IDs:

    PUID=1000
    PGID=1000

These values must match the intended account on the deployment host.

## Jellyfin GPU Groups

Determine the host GPU group IDs:

    getent group video
    getent group render

Set the corresponding values in `.env`:

    VIDEO_GID=
    RENDER_GID=

These values are host-specific and must be checked again when Hestia
moves to different hardware.

## Recyclarr Secrets

The repository includes:

    config/recyclarr/secrets.example.yml

Production API keys belong in a separate `secrets.yml` that must never
be committed to Git.

## Validate

Before deployment:

    ./scripts/validate-repo.sh

The rendered Compose definition can also be inspected with:

    docker compose \
      --env-file .env \
      -f compose/compose.yaml \
      config

## Start

Start the stack with:

    docker compose \
      --env-file .env \
      -f compose/compose.yaml \
      up -d

## Application Configuration

Application-specific API keys, accounts and credentials should be
configured through protected deployment configuration or the individual
applications.

Production databases and credentials do not belong in this repository.
