# Hestia Deployment

## Requirements

Hestia requires:

- Linux
- Docker Engine
- Docker Compose v2
- Bash, Git and Python 3 for repository validation
- persistent configuration storage
- bulk media/data storage
- appropriate filesystem permissions

The supplied Compose file maps `/dev/dri` into Jellyfin and Trailarr.
The device must exist for this definition to start. A host without a GPU needs
a reviewed local variant removing both mappings and Jellyfin GPU groups.
Hardware acceleration requires separate application configuration.

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
      config --quiet

## Prepare external storage and policy

Create configuration directories for every persistent service and the data
layout in [STORAGE.md](STORAGE.md). Assign ownership to the configured account;
avoid world-writable permissions. Verify mounted filesystems are present before startup.
Use `id -u`, `id -g`, `getent group video`, `getent group render` and `ls -l /dev/dri`
to inspect the host. IDs in the example are illustrative.

Copy `config/recyclarr/recyclarr.yml` to the Recyclarr directory under your
`HESTIA_CONFIG_ROOT`. Copy `secrets.example.yml` alongside it as `secrets.yml`,
then replace the placeholders locally and restrict its permissions. Ensure the
container UID can read it. Create the `Hestia 1080p` quality profiles in Radarr
and Sonarr before synchronizing; this repository supplies selected custom formats,
not a complete quality profile definition.

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

## First-run verification

Configure authentication before granting household access. In Radarr and Sonarr,
use the shared `/data/media/movies` and `/data/media/tv` root folders and the
qBittorrent endpoint `http://qbittorrent:8080`. Configure download categories and
paths under `/data/downloads/torrents`. Configure Prowlarr application sync,
Seerr library-manager connections, and enrichment integrations with Docker DNS.
Jellyfin library folders use `/media/movies` and `/media/tv`.

Check `docker compose --env-file .env -f compose/compose.yaml ps`, then test an
authorized sample request through download, import and playback. Verify subtitles,
trailers and acceleration independently. Container startup and static validation
do not confirm API credentials, permissions, GPU access or application health.

The existing production Compose directory is separate from the repository.
Do not run a second stack against its fixed container names. Review and promote
repository changes into the existing deployment using [OPERATIONS.md](OPERATIONS.md).
