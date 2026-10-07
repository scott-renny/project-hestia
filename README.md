<div align="center">

# 🏠 Project Hestia

### Self-Hosted Media Automation & Delivery Platform

**A containerized media platform engineered for automated request handling,  
library management, quality policy, enrichment, playback, and personalization.**

![Linux](https://img.shields.io/badge/Linux-Ubuntu_24.04-E95420?logo=ubuntu&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?logo=docker&logoColor=white)
![Jellyfin](https://img.shields.io/badge/Jellyfin-Media_Platform-00A4DC?logo=jellyfin&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-Version_Control-181717?logo=github&logoColor=white)
![Status](https://img.shields.io/badge/Status-Operational-success)
![License](https://img.shields.io/badge/License-Not_Yet_Selected-lightgrey)

</div>

---

## Overview

**Project Hestia** is the media-services platform within the COC homelab.

Rather than operating as a collection of independent applications, Hestia
integrates media serving, request management, library automation, quality
policy, subtitle management, trailer automation, and personalized
recommendations into a unified Docker Compose platform.

The project is designed around reproducibility, service isolation,
persistent storage, API-driven integration, configuration management, and
safe migration between hosts.

Hestia currently runs on **Project Atlas v1** and is designed to migrate to
**Atlas v2** without changing its logical role or application architecture.

---

## Engineering Highlights

- **Containerized service architecture** using Docker Compose
- **Internal service discovery** through Docker DNS
- **Persistent configuration separated from bulk media storage**
- **Shared filesystem architecture** for reliable cross-service imports
- **API-driven integration** between media and automation services
- **Quality policy as code** using Recyclarr
- **Automated subtitle and trailer enrichment**
- **Personalized recommendation infrastructure**
- **Hardware-acceleration support** for Jellyfin
- **Environment-based host path configuration**
- **Secrets and runtime state excluded from version control**
- **Repository validation tooling** for configuration and credential checks
- **Migration-friendly design** for the future Atlas v2 platform

---

## Architecture

```mermaid
flowchart TD
    U[Household User] --> S[Seerr<br/>Discovery & Requests]

    S --> R[Radarr<br/>Movies]
    S --> SO[Sonarr<br/>TV & Series]

    R --> P[Prowlarr<br/>Search Integration]
    SO --> P

    P --> Q[qBittorrent<br/>Acquisition]

    Q --> R
    Q --> SO

    R --> M[(Movie Library)]
    SO --> T[(TV Library)]

    M --> J[Jellyfin<br/>Media Platform]
    T --> J

    B[Bazarr<br/>Subtitle Automation] --> R
    B --> SO

    RC[Recyclarr<br/>Quality Policy as Code] --> R
    RC --> SO

    TR[Trailarr<br/>Trailer Automation] --> R
    TR --> SO

    J --> V[Vanguarr<br/>Personalized Recommendations]
    V --> J

    J --> U
