# Générateur de site statique/docs

HTML et CSS c'est sympa, mais si vous voulez mettre à jour un site régulièrement, le html/CSS peut être un peu lourd sur la durée.

Heureusement, il existe des générateurs plus ou moins évolué et dédié a diverses taches ou style de site.

Ce site ressemble de plus en plus à une sorte de documentation personnel. Je me suis tourné vers Mkdocs puis Mkdocs Material puis Zensical pour ce site.


## Mkdocs

Mkdocs est utilisé par un certain nombre de documentation en ligne.Source: wikipedia : [https://en.wikipedia.org/wiki/MkDocs](https://en.wikipedia.org/wiki/MkDocs){target = "blank"}

Il permet de faire un blog, une documentation en ligne et il pouvait se moddé avec l'ajout de modification.
Il y a un petit conflit en ce moment entre Mkdocs et le mod Materials.

Pour installer Mkdocs, il suffit d'utiliser pip.

```bash
pip install mkdocs
```

### Mkdocs-material

Mkdocs-Material était un style de Mkdocs, qui est devenue assez gros, (gestion de blog, outils pour avoir un style sombre et clair, ...)
Les auteurs de Mkdocs ont décidé de changer les règles des mod de Mkdocs, ce qui a amener à la création de Zensical.

### Arborescence et mkdocs.yaml

L'arborescence se décompose comme ça :

```
.
├── docs
│   ├── about.md
│   ├── blog
│   ├── data
│   ├── favicon
│   ├── index.md
│   ├── logo
│   ├── programmation
│   └── reseaux
├── overrides
│   └── 404.html
└── mkdocs.yml
```
Un dossier docs avec votre documentation (en markdown) et d' éventuels sous-dossiers.

Le dossier Overrides vous permet de personnaliser vos pages (par exemple ici avec la fameuse 404).


Voici un exemple de fichier mkdocs-materials (encore compatible avec Zensical)

```yaml
site_name: "Piweb : Site autohébergé sur un Raspberry pi"
repo_url: https://github.com/barrmath
nav: # menu en mode manuel. vous pouvez enlevé ça si vous voulez un menu par ordre alphabetique
  - Présentation: index.md
  - Réseaux:
    - reseaux/reseaux_intro.md
    - Auto-hébergement : reseaux/autohebergement.md
    - Forum : reseaux/forum.md
    - Monitoring : reseaux/monitoring.md
    - Gunicorn : reseaux/gunicorn.md
    - Proxy : reseaux/proxy.md
    - Certificat : reseaux/certificats.md
    - Firewall : reseaux/firewall.md
    - Podman/Docker : reseaux/podman.md
    - Docker Compose : reseaux/docker-compose.md
    - Jenkins : reseaux/jenkins.md
    - Acces bureau à distance : reseaux/hoptodesk.md
    - DNS local : reseaux/DNS_local.md
  - Programmation:
    - programmation/programmation_intro.md
    - Git : programmation/git.md
    - HTML/CSS : programmation/htmlcss.md
    - Python : programmation/python.md
    - Flask : programmation/flask.md
    - Jinja : programmation/jinja.md
    - Django : programmation/django.md
  - Data :
    - data/data_intro.md
    - Libre-Office : data/libre-office.md
    - SQL : data/sql.md
    - Pandas : data/pandas.md
    - Graphique : data/graphique.md
    - Dashboards: data/dashboards.md
    - ETL : data/etl.md
    - Exemple d'utilisation ETL et dashboards avec des données de la FAO : data/etl_dashboards.md
  - A propos de moi: about.md
  - FORUM : https://forum.barrmath.ovh
  - Blog : blog/index.md
plugins: # ici vous pouvez mettre vos plugins
  - blog:
      blog_toc: true
      post_readtime_words_per_minute: 250
  - search
theme: # ici les options des themes 
  name: material
  custom_dir: overrides
  language: fr
  favicon: favicon/favicon.ico
  logo: logo/logo.png
  # police d'ecriture False pour utiliser la police par default du navigateur
  font: false
  palette:
    # Palette toggle for automatic mode
    - media: "(prefers-color-scheme)"
      toggle:
        icon: material/brightness-auto
        name: passer en mode clair
    # Palette toggle for light mode
    - media: "(prefers-color-scheme: light)"
      scheme: default
      primary: teal
      accent: red
      toggle:
        icon: material/brightness-7
        name: Passer en mode sombre

    # Palette toggle for dark mode
    - media: "(prefers-color-scheme: dark)"
      scheme: slate
      primary: teal
      accent: amber
      toggle:
        icon: material/brightness-4
        name: passer en mode par default du système
  features : # ici les petites modifications et ajouts 
    - navigation.header
    - navigation.tabs
    - navigation.tabs.sticky
    - navigation.sections
    - navigation.expand
    - toc.integrate
    - header.autohide
    - navigation.instant
    - search.suggest
    - search.highlight
    - search.share
    - content.code.copy
markdown_extensions: #pour des extensions du langage markdown
  - tables
  - admonition
  - attr_list
  - md_in_html
  - pymdownx.blocks.caption
  - pymdownx.highlight:
      anchor_linenums: true
      line_spans: __span
      pygments_lang_class: true
  - pymdownx.inlinehilite
  - pymdownx.snippets
  - pymdownx.superfences

```

### serveur de dev

Pour lancer le serveur de développement, il suffit de taper :

```bash
mkdocs serve
```

puis d aller sur localhost port 8000

[http://localhost:8000/](http://localhost:8000/){target = "blank"}

### compilation du site et config nginx

Pour construire, il suffit de taper :

```bash
mkdocs build --use-directory-urls
```

Pour la configuration de nginx, il vous suffit de pointer vers la page que vous souhaiter voir apparaître en premier.
Rajouter dans votre nginx.conf (ou dans un autre fichier voir la doc sur nginx)

```
server {
    server_name pouetpouet;
    listen 443 ssl;
    listen [::]:443 ssl;
    http2 on;
    ssl_certificate /etc/letsencrypt/live/pouetpouet/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/pouetouet/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    location / {
        alias /chemin/vers/le/site/construit/;
        index index.html;
    }
}
```

## zensical

Pour installer Zensical, il suffit d'utiliser pip.

```bash
pip install zensical
```

### exemple arborescence et zensical.toml
L'arborescence se décompose comme ça :

```
.
├── docs
│   ├── about.md
│   ├── blog
│   ├── data
│   ├── favicon
│   ├── index.md
│   ├── logo
│   ├── programmation
│   └── reseaux
├── overrides
│   └── 404.html
└── zensical;toml
```

La configuration et l'arborescence sont similaire à mkdocs.

Un dossier docs avec votre documentation (en markdown) et d' éventuels sous-dossiers.

Le dossier Overrides vous permet de personnaliser vos pages (par exemple ici avec la fameuse 404).


Voici un exemple de fichier zensical.toml 

```python
[project] # par rapport à mkdocs vous placer ici les options de construction et les metadata ici
site_name = "Piweb : Site autohébergé sur un Raspberry pi"
site_url = "https://www.barrmath.ovh"
site_description = "site perso, podman, docker, ETL, Data, admin"
site_author = "Barrmath"
docs_dir = "docs"
use_directory_urls = true
nav = [ # ici le menu en mode manuel. 
  {"Présentation" = "index.md"},
  {"Réseaux" = [
    "reseaux/reseaux_intro.md",
    {"Auto-hébergement" = "reseaux/autohebergement.md"},
    {"Forum" = "reseaux/forum.md"},
    {"Monitoring" = "reseaux/monitoring.md"},
    {"Gunicorn" = "reseaux/gunicorn.md"},
    {"Proxy" = "reseaux/proxy.md"},
    {"Certificat" = "reseaux/certificats.md"},
    {"Firewall" = "reseaux/firewall.md"},
    {"Podman/Docker" = "reseaux/podman.md"},
    {"Docker Compose" = "reseaux/docker-compose.md"},
    {"Jenkins" = "reseaux/jenkins.md"},
    {"Acces bureau à distance" = "reseaux/hoptodesk.md"},
    {"DNS local" = "reseaux/DNS_local.md"}
      ]},
  {"Programmation" = [
    "programmation/programmation_intro.md",
    {"Git" = "programmation/git.md"},
    {"HTML/CSS" = "programmation/htmlcss.md"},
    {"Générateur de site statique/doc" = "programmation/mkdocs.md"},
    {"Python" = "programmation/python.md"},
    {"Flask" = "programmation/flask.md"},
    {"Jinja" = "programmation/jinja.md"},
    {"Django" = "programmation/django.md"}
    ]},
    {Data =[
    "data/data_intro.md",
    {"Libre-Office" = "data/libre-office.md"},
    {"SQL" = "data/sql.md"},
    {"Pandas" = "data/pandas.md"},
    {"Graphique" = "data/graphique.md"},
    {"Dashboards" = "data/dashboards.md"},
    {"ETL" = "data/etl.md"},
    {"Exemple d'utilisation ETL et dashboards avec des données de la FAO" = "data/etl_dashboards.md"}
    ]},
    {"A propos de moi" = "about.md"},
    {"FORUM" = "https://forum.barrmath.ovh"},
    #{"Blog" = "blog/index.md"}
      ]

[project.theme] # les options de theme
variant = "classic"
custom_dir = "overrides"
font = false
language = "fr"
logo= "logo/logo.png"
favicon = "favicon/favicon.ico"
features = [
    "navigation.instant",
    "navigation.tracking",
    "navigation.tabs",
    "navigation.tabs.sticky",
    "navigation.sections",
    "navigation.expand",
    "header.autohide",
    "content.code.copy",
    "search.share",
    "toc.integrate"
]
[[project.theme.palette]]
media = "(prefers-color-scheme: light)"
scheme = "default"
toggle.icon = "lucide/sun"
toggle.name = "passer en mode sombre"

[[project.theme.palette]]
media = "(prefers-color-scheme: dark)"
scheme = "slate"
primary = "teal"
accent = "amber"
toggle.icon = "lucide/moon"
toggle.name = "passer en mode clair"
```

### serveur de dev 


Pour lancer le serveur de développement, il suffit de taper :

```bash
zensical serve
```

puis d aller sur localhost port 8000

[http://localhost:8000/](http://localhost:8000/){target = "blank"}

### compilation du site et config nginx

Pour construire, il suffit de taper :

```bash
zensical build
```

Les options de construction sont directement à mettre dans le fichier zensical.toml

Pour la configuration de nginx, il vous suffit de pointer vers la page que vous souhaiter voir apparaître en premier.
Rajouter dans votre nginx.conf (ou dans un autre fichier voir la doc sur nginx)

```
server {
    server_name pouetpouet;
    listen 443 ssl;
    listen [::]:443 ssl;
    http2 on;
    ssl_certificate /etc/letsencrypt/live/pouetpouet/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/pouetouet/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    location / {
        alias /chemin/vers/le/site/construit/;
        index index.html;
    }
}
```
