---
date : 2025-08-31
categories :
    - debian
    - apt
---

# Trixie et apt manquant

Il arrive de Debian ne mets pas de source apt avec Trixie.
Si lorsque vous faites :

```bash
sudo apt update
```

Aucun dépôt n'apparaît, il y a de fortes chances que vos dépôts n'ont pas été configurés.
Par chance, Debian fournit un exemple de configuration :
/usr/share/doc/apt/examples/debian.sources

```yaml
## Debian distribution repository
##
## The following settings can be adjusted to configure which packages to use from Debian.
## Mirror your choices (except for URIs and Suites) in the security section below to
## ensure timely security updates.
##
## Types: Append deb-src to enable the fetching of source package.
## URIs: A URL to the repository (you may add multiple URLs)
## Suites: The following additional suites can be configured
##   <name>-updates   - Urgent bug fix updates produced after the final release of the
##                      distribution.
##   <name>-backports - software from this repository may not have been tested as
##                      extensively as that contained in the main release, although it includes
##                      newer versions of some applications which may provide useful features.
##                      Also, please note that software in backports WILL NOT receive any review
##                      or updates from the Debian security team.
## Components: Aside from main, the following components can be added to the list
##   contrib           - Free software that may require non-free software to run.
##   non-free-firmware - Firmware that is non-free
##   non-free          - Software that is not under a free license. There may be restrictions
##                       on use or modification.
##
## See the sources.list(5) manual page for further settings.
Types: deb
URIs: http://deb.debian.org/debian
Suites: trixie trixie-updates
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

## Debian security updates. Aside from URIs and Suites,
## this should mirror your choices in the previous section.
Types: deb
URIs: http://deb.debian.org/debian-security
Suites: trixie-security
Components: main contrib non-free non-free-firmware
Signed-By: /usr/share/keyrings/debian-archive-keyring.gpg

```

Vous pouvez utiliser ce fichier directement dans apt.

```bash
sudo cp /usr/share/doc/apt/examples/debian.sources /etc/apt/sources.list.d/debian.sources 
```

Puis vous pouvez faire vos mises à jour :

```bash
sudo apt update
sudo apt upgrade
```
