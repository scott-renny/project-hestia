# Hestia Architecture

## Purpose

Project Hestia provides the media-services layer of the COC environment.

Hestia is a logical platform rather than a dedicated physical system.
It currently runs on Atlas v1 and is designed to migrate to Atlas v2.

## Docker Network

Hestia services share the Docker network:

    hestia

Internal integrations use Docker DNS names where possible.

Examples:

    http://jellyfin:8096
    http://radarr:7878
    http://sonarr:8989
    http://prowlarr:9696
    http://seerr:5055

This keeps application integrations independent of Atlas's LAN address.

## Functional Layers

### Playback

Jellyfin provides media libraries, playback, household users, watch
history, resume state, metadata and API access.

### Requests

Seerr provides discovery and request management and connects requests
to Radarr and Sonarr.

### Library Automation

Radarr manages movies.

Sonarr manages television series and episodes.

### Search Integration

Prowlarr provides the shared search/indexer integration layer for
Radarr and Sonarr.

### Transfer

qBittorrent provides the download-client role.

### Policy

Recyclarr applies Hestia's quality profiles and custom-format policy.

### Subtitles

Bazarr manages subtitle requirements independently from the primary
library managers.

### Trailers

Trailarr manages trailers associated with library content.

### Recommendations

Vanguarr builds personalized recommendations using Jellyfin user and
library information and integrates with Seerr.

### Supporting Service

FlareSolverr is available where compatible integrations require it.

## Host Evolution

Current:

    Atlas v1
    └── Hestia
        ├── Docker services
        ├── application configuration
        └── external media storage

Future:

    Atlas v2
    └── Hestia
        ├── container/application tier
        ├── metadata tier
        ├── bulk media storage
        └── Intel Quick Sync acceleration

The underlying hardware can change without changing Hestia's logical
role.
