# Hestia architecture

Hestia is a logical media platform hosted on Atlas v1. Atlas v2 migration is a
future deployment change, not a second implementation in this repository.

## Service relationships

See the [README diagram](../README.md#architecture) and its editable
[Mermaid source](assets/architecture.mmd). Keep both synchronized when changing topology.
Seerr sends approved requests to Radarr or Sonarr. Those managers search via
Prowlarr and send transfers directly to qBittorrent. Prowlarr can use FlareSolverr
for compatible indexers. Recyclarr targets the managers' APIs; Bazarr and Trailarr
combine API integrations with filesystem access. Vanguarr integrates with
Jellyfin and Seerr through deployment configuration.

Compose declares containers, not these API relationships. API keys, indexers,
download categories, root folders, authentication and schedules are runtime state.
There are no declared `depends_on` relationships or repository-defined health checks.
Startup does not establish application readiness. Image-provided health checks,
if present, are determined by the deployed image version.

## Network and access boundary

All eleven services join the Compose-managed default bridge named `hestia`.
Service names provide DNS endpoints such as `http://radarr:7878` and
`http://sonarr:8989`. There is no per-service network segmentation and no
`internal: true` isolation; outbound access supports upstream integrations.
Fixed container names and the fixed network name make parallel deployments on
one host unsuitable without explicit changes.

Published ports are listed in the README and bind to all host interfaces.
FlareSolverr and Recyclarr have no host port mappings. No reverse proxy, TLS,
VPN or firewall is declared here. The broader host access layer must protect
administration interfaces. [Docker networking reference](https://docs.docker.com/compose/how-tos/networking/).

## Configuration and persistence boundary

`HESTIA_CONFIG_ROOT` supplies individual service state mounts. Most use `/config`;
Seerr uses `/app/config` and Vanguarr uses `/data`. FlareSolverr has no persistent mount.
Recyclarr's tracked YAML is a template to copy into its external configuration root;
Compose does not mount or copy the repository's `config/` directory automatically.

`HESTIA_DATA_ROOT` supplies shared `/data` to qBittorrent, Radarr, Sonarr, Bazarr
and Trailarr. Jellyfin receives only the media and transcode subdirectories, with
the existing writable mount behavior retained. See [storage](STORAGE.md).
Recyclarr synchronizes selected custom formats into the `Hestia 1080p` profiles;
its YAML does not provision an entire application configuration.

## Portability and host dependencies

Storage roots, user/group IDs and time zone are configurable. Jellyfin and
Trailarr both map `/dev/dri`; Jellyfin adds host video/render group IDs. Hardware,
ownership and application acceleration settings require checks on the new host.
Preserve runtime state and consistent container paths during migration. Image tags
are mostly mutable, so record deployed image digests before an upgrade or move.
