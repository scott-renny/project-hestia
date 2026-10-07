# Hestia Recommendation Architecture

## Purpose

Hestia includes a personalized recommendation layer so discovery can
eventually reflect individual household viewing preferences rather than
only generic popularity.

## Recommendation Engine

Vanguarr provides the current recommendation layer.

Its Hestia integrations include:

    Jellyfin
    Vanguarr
    Seerr
    TMDb

Jellyfin remains the source of truth for users, media and playback
history.

## Personalization

Each Jellyfin user can have an independent recommendation profile.

Useful signals can include:

- watched titles
- viewing history
- genres
- franchises
- recency
- repeat viewing
- title preferences

Recommendation quality depends on genuine user history.

## Current State

The Vanguarr infrastructure and integrations are configured.

The current Hestia library does not yet contain enough genuine viewing
history to meaningfully evaluate personalized recommendation quality.

This is a data-availability limitation rather than an infrastructure
failure.

## Validation Sequence

The preferred validation process is:

    Accumulate genuine Jellyfin viewing history
        |
        v
    Run Vanguarr library synchronization
        |
        v
    Build or refresh user profile
        |
        v
    Generate suggestions
        |
        v
    Review recommendation quality
        |
        v
    Run decision dry-run
        |
        v
    Consider controlled request automation

Automatic request generation should not be enabled simply because the
integration is technically functional.

## Jellyfin Integration

The Vanguarr Jellyfin plugin can expose recommendation views inside
Jellyfin.

These recommendation views should remain distinguishable from
Jellyfin's native similarity features.

## Future Frontends

Oberon TV should eventually consume the established Hestia/Jellyfin
recommendation and playback ecosystem rather than creating a separate
recommendation database.
