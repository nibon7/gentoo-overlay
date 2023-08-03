# Gentoo Overlay

[![pkgcheck](https://github.com/nibon7/gentoo-overlay/actions/workflows/ci.yml/badge.svg)](https://github.com/nibon7/gentoo-overlay/actions/workflows/ci.yml)

## Usage

Manually add this to `/etc/portage/repos.conf/nibon7.conf`

```
[nibon7]
location = /var/db/repos/nibon7
sync-type = git
sync-uri = https://github.com/nibon7/gentoo-overlay.git
auto-sync = yes
```
