# Hestia Security

## Repository Boundary

The Hestia repository contains infrastructure definitions,
documentation and sanitized configuration.

It intentionally excludes production state.

## Never Commit

The following must remain outside Git:

- `.env`
- passwords
- API keys
- access tokens
- private keys
- production `secrets.yml`
- application databases
- application runtime state
- media files
- downloads
- transcode files
- runtime logs

## Internal Networking

Service-to-service communication should use the private Hestia Docker
network where practical.

Docker DNS names are preferred over hard-coded LAN addresses.

Examples:

    jellyfin
    radarr
    sonarr
    prowlarr
    seerr

## External Access

Publishing a Docker port does not mean that the service should be
directly exposed to the public Internet.

Remote-access and reverse-proxy controls are part of the wider Atlas
and COC infrastructure rather than the portable Hestia definition.

## Secret Handling

Secrets should be represented in Git only through placeholders,
environment-variable references or example files.

If a real secret is accidentally committed, removing the file from the
latest revision is insufficient. The credential should be considered
exposed and rotated.

## Validation

Before a commit:

    ./scripts/validate-repo.sh

Validation is a guardrail and does not replace review of the proposed
Git changes.

## Exposure and image trust

The `hestia` bridge allows all services to communicate and reach upstream services.
It is not a firewall or a segmented trust boundary. Existing port mappings listen
on all interfaces. Restrict administration access at the deployment layer and
verify Docker-aware firewall rules from another machine. Remote proxy/TLS controls
are external to this repository; do not assume they are installed by Compose.

No privileged containers or Docker socket mounts are declared. GPU device access,
writable shared media and application API credentials still grant meaningful access.
Retain least-privilege filesystem ownership and use separate application accounts
and API keys where supported. Logs and backups can contain credentials and user history.

Mutable image tags can change on pull. Record deployed digests, review upstream
changes and test upgrades. Image vulnerability scanning and runtime exposure tests
are separate from repository validation.

## Validation scope and incident response

The validator scans tracked and new non-ignored publication files, including docs
and examples. It rejects forbidden state paths, common credential signatures,
literal configuration credentials and private/shared address literals. It reports
locations without printing matched content. Ignored local deployment files are
outside the publication boundary. Pattern checks cannot detect every secret;
review the full staged diff and use an independent secret scanner before publishing.

If credentials enter Git, revoke/rotate them first, assess logs and access, then
coordinate history cleanup where needed. Deleting the latest file does not revoke
the credential or remove earlier copies. CI runs with read-only repository permissions
and no deployment secrets; it does not deploy the stack.
