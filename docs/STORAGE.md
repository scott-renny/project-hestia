# Hestia Storage Architecture

## Configuration

Persistent application configuration defaults to:

    /opt/hestia/config

This contains application state for services such as Jellyfin, Radarr,
Sonarr, Prowlarr, Seerr, Bazarr, Trailarr and Vanguarr.

Production application state is not stored in this Git repository.

## Bulk Data

Bulk data defaults to:

    /srv/hestia/data

Current structure:

    /srv/hestia/data/
    ├── downloads/
    │   └── torrents/
    │       ├── movies/
    │       └── tv/
    ├── media/
    │   ├── movies/
    │   └── tv/
    └── transcode/

## Shared Data Path

Automation services use a common host data root and see it inside their
containers as:

    /data

Examples:

    /data/downloads/torrents/movies
    /data/downloads/torrents/tv
    /data/media/movies
    /data/media/tv

Consistent filesystem paths simplify imports and filesystem-efficient
operations.

## Jellyfin

Jellyfin receives media-oriented mounts:

    /media
    /transcode

It does not require the complete automation workspace.

## Portability

The repository supports:

    HESTIA_CONFIG_ROOT
    HESTIA_DATA_ROOT

This allows storage to move without rewriting the Compose definition.
