# Hestia Media Flow

## Movie Pipeline

The normal movie workflow is:

    User
      |
      v
    Seerr
      |
      v
    Radarr
      |
      v
    Prowlarr search results
      |
      v
    Radarr submits download
      |
      v
    qBittorrent
      |
      v
    Radarr import
      |
      v
    Movie library
      |
      v
    Jellyfin

## Television Pipeline

The normal television workflow is:

    User
      |
      v
    Seerr
      |
      v
    Sonarr
      |
      v
    Prowlarr search results
      |
      v
    Sonarr submits download
      |
      v
    qBittorrent
      |
      v
    Sonarr import
      |
      v
    TV library
      |
      v
    Jellyfin

## Quality Policy

Recyclarr synchronizes the tracked custom-format selections and scores into existing
`Hestia 1080p` profiles in
Radarr and Sonarr.

This separates quality-policy management from individual application
configuration.

## Subtitle Flow

Bazarr monitors imported media for the configured subtitle policy.

Hestia currently targets English Forced subtitles where appropriate
rather than automatically acquiring full English subtitles for every
title.

## Trailer Flow

Trailarr manages trailers associated with Hestia media.

This provides trailer assets independently from the core movie and TV
import pipelines.

## Recommendation Flow

Vanguarr consumes Jellyfin library and user information to build
personalized recommendation profiles.

Recommendation quality should improve as genuine playback history
accumulates.

## Playback State

Jellyfin remains the source of truth for:

- watched state
- resume position
- household users
- playback history

Future frontends should consume this state rather than maintaining an
independent playback-state database.
