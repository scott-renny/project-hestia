# Hestia Roadmap

Hestia follows the COC completion-first model:

    NOW -> NEXT -> LATER -> REJECT

## NOW

Maintain and document the working platform:

- Jellyfin playback and library management
- Seerr discovery and requests
- Radarr movie automation
- Sonarr television automation
- Prowlarr integration
- qBittorrent transfer layer
- Recyclarr quality policy
- Bazarr forced-subtitle policy
- Trailarr trailer automation
- Vanguarr recommendation infrastructure
- Git-based infrastructure documentation

Continue accumulating genuine Jellyfin viewing history before judging
Vanguarr personalization.

## NEXT

Operational improvements:

- validate Vanguarr personalization with real viewing history
- validate recommendation views in Jellyfin
- use Vanguarr decision dry-runs before any automatic requests
- integrate Unpackerr
- integrate Cleanuparr conservatively
- add n8n health monitoring
- add useful failure notifications
- improve household account experience
- maintain repository validation CI
- evaluate image version pinning and verified service health checks

## LATER

Infrastructure evolution:

- migrate Hestia to Atlas v2
- use Intel Quick Sync acceleration
- evaluate one controlled media optimization platform
- evaluate Jellyfin-aware library lifecycle management
- integrate Hestia with Oberon TV
- expand dashboards and telemetry
- automate safe repository synchronization

## REJECT / NOT CURRENTLY REQUIRED

Hestia does not currently require:

- a dedicated physical Hestia server
- a Usenet stack
- music automation
- book or audiobook automation
- duplicate quality-policy platforms
- unnecessary standalone hardware

Services should be added because they solve an operational requirement,
not simply because they can be installed.
