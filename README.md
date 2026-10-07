# Project Hestia

Project Hestia is the media-services platform within the COC homelab.

Hestia combines media serving, request management, library automation,
quality policy, subtitle management, trailer automation, and personalized
recommendations into a containerized Docker Compose platform.

Hestia currently runs on Project Atlas and is designed to migrate to
Atlas v2 without changing its logical role.

## Platform

| Service | Role |
|---|---|
| Jellyfin | Media server, playback, users and watch state |
| Seerr | Discovery and request management |
| Radarr | Movie automation |
| Sonarr | Television automation |
| Prowlarr | Search/indexer integration |
| qBittorrent | Download client |
| Bazarr | Subtitle automation |
| Recyclarr | Quality policy as code |
| Trailarr | Trailer automation |
| Vanguarr | Personalized recommendations |
| FlareSolverr | Supporting compatibility service |

## Core Flow

Movie requests:

    Seerr -> Radarr -> Prowlarr -> qBittorrent
                  -> import -> Jellyfin

TV requests:

    Seerr -> Sonarr -> Prowlarr -> qBittorrent
                  -> import -> Jellyfin

Supporting automation:

    Recyclarr -> Radarr / Sonarr quality policy
    Bazarr    -> subtitle policy
    Trailarr  -> trailers
    Vanguarr  -> personalized recommendations

## Design Principles

- Docker Compose deployment
- persistent configuration separated from bulk media
- shared filesystem paths between automation services
- Docker DNS for internal service communication
- API-driven integrations
- secrets excluded from Git
- configuration and policy as code where practical
- Jellyfin remains the source of truth for playback state
- migration-friendly design

## Storage

Default deployment paths:

    /opt/hestia/config
    /srv/hestia/data

They can be overridden with:

    HESTIA_CONFIG_ROOT
    HESTIA_DATA_ROOT

## Repository

    project-hestia/
    ├── compose/
    ├── config/
    ├── docs/
    ├── diagrams/
    └── scripts/

Production application databases, credentials, media, downloads,
transcode data and runtime state are intentionally excluded.

## Validation

Run:

    ./scripts/validate-repo.sh

## Status

The core movie and television automation pipelines are operational.

Quality policy, forced-subtitle automation, trailers and the
recommendation infrastructure have also been integrated.

Vanguarr personalization will be evaluated further after sufficient
genuine Jellyfin viewing history exists.

## Future

Hestia will migrate from Atlas v1 to Atlas v2 while retaining the same
logical role.

Future interfaces such as Oberon TV can consume Hestia/Jellyfin services
without replacing the backend media platform.

## License

No software license has been selected yet.
