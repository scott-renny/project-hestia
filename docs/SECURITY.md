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
