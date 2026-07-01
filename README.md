<p align="center">
  <img src="docs/assets/namelessBadge.png" alt="nameless" width="520">
</p>

<h1 align="center">nameless</h1>

<p align="center">
  <b>Unofficial Telegram iOS client with a custom nameless interface.</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/platform-iOS-black?style=for-the-badge&logo=apple" alt="iOS">
  <img src="https://img.shields.io/badge/language-Swift-black?style=for-the-badge&logo=swift" alt="Swift">
  <img src="https://img.shields.io/badge/client-nameless-black?style=for-the-badge" alt="nameless">
  <img src="https://img.shields.io/badge/status-active%20development-black?style=for-the-badge" alt="Active development">
</p>

<p align="center">
  <img src="docs/assets/nameless.png" alt="nameless app icon" width="180">
</p>

## About

`nameless` is a custom Telegram iOS client focused on a dark visual style, rounded controls, glass-like UI surfaces, privacy controls, and a separate nameless settings hub.

The project is based on upstream iOS client code and keeps upstream components under their original licenses. The `nameless` name, logo, badge, visual identity, and custom nameless modifications are protected project assets.

## Features

- `nameless` settings entry with a custom rounded logo.
- Separate nameless settings hub with sections for appearance, ghost mode, functions, about, and Liquid Glass.
- Settings search inside the nameless settings screen.
- Hidden legacy feature screens behind a long press on Telegram features.
- About links for the nameless channel, developer, and Stiven VPN opened inside the client.
- Liquid Glass settings toggles for messages, settings, profile, gifts, inline buttons, and glass tinting.
- Video background setting for chats: choose, replace, remove, enable, and disable a muted looping video.
- Round icon-only profile buttons setting.
- nameless official developer profile badge and verification footer.
- Single nameless app icon and nameless Pro badge in visible selectors.
- nameless storage keys for migrated modules and feature toggles.
- Integrated nameless feature modules for ghost mode, local premium, chat export, fake location, chat password, double bottom, voice tools, and supporters.

## Current Status

Implemented in this repository:

- Branding strings and visible settings labels moved toward `nameless`.
- The nameless app/settings icon is connected from the black character logo.
- Visible app icon and badge pickers now use only nameless artwork.
- Round profile buttons hide text labels visually and keep accessibility labels.
- The configured nameless owner account shows developer status and official nameless verification text.
- Chat video background is wired through `AVQueuePlayer` and `AVPlayerLooper`.
- Liquid Glass controls and settings keys are present; full app-wide visual coverage is still being expanded.

## Links

- Channel: [t.me/hanmeta](https://t.me/hanmeta)
- Developer: [t.me/kreadwrite](https://t.me/kreadwrite)
- Stiven VPN: [t.me/stivenvpnbot](https://t.me/stivenvpnbot)

## Rights

Copyright (c) 2026 nameless.

The `nameless` brand, logo, badge, screenshots, custom UI design, custom modules, and project-specific modifications may not be copied, sold, rebranded, or redistributed as another project without written permission from the project owner.

Telegram, upstream iOS client code, and third-party dependencies remain the property of their respective owners and are governed by their original licenses. This project is unofficial and is not affiliated with Telegram.
