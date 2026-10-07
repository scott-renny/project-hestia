# Hestia Operations

## Production and Repository Separation

The live deployment currently resides at:

    /opt/hestia/compose

The Git repository resides at:

    /opt/hestia/repo

Repository development therefore does not directly modify the running
Hestia platform.

## Check Containers

From the production deployment:

    cd /opt/hestia/compose
    docker compose ps

## View Logs

All Hestia services:

    docker compose logs --tail=100

A single service:

    docker compose logs --tail=100 jellyfin

Follow logs:

    docker compose logs -f jellyfin

## Restart a Service

Example:

    docker compose restart jellyfin

## Repository Validation

Before committing infrastructure changes:

    cd /opt/hestia/repo
    ./scripts/validate-repo.sh

## Production Change Rule

Repository changes should be validated before equivalent changes are
applied to the live deployment.

Production application databases, API credentials and runtime state
must not be copied into Git.

## Troubleshooting Model

Troubleshooting should proceed from the dependency closest to the
failure.

For a request pipeline:

    Request layer
        ->
    Radarr / Sonarr
        ->
    Prowlarr
        ->
    Download client
        ->
    Import
        ->
    Filesystem
        ->
    Jellyfin

Container logs and application APIs should be used to identify the
specific failing layer rather than restarting the entire stack.
