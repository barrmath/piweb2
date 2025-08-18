---
date : 2025-08-18
categories :
    - nginx
    - autohebergement
    - mastodon
---

# media social/forum

J'ai envie de faire en sorte d'avoir un espace où l'on peut s'exprimer librement sans la crainte de se faire censurer.
Peu importe ses idées, ses envies, le sujet.

J'ai essayé Mastodon. Ça marche sur une petite machine en auto-hébergement.
Mais la limite de caractères et l'aspect twitter/X bof. (Mais ça reste un excellent réseau social, juste pas ce que je veux.)
Je pense passer sur discourse dans une semaine voir si celui là convient à l'auto hébergement.

Pour la mise en place de Mastodon, vous avez besoin de :

- d'un nom de domaine et du matériel pour de l'[auto hebergement](../../reseaux/autohebergement.md){target="_blank"}
- [certbot pour le https](../../reseaux/certificats.md){target="_blank"}
- [Nginx](../../reseaux/proxy.md){target="_blank"}
- [podman](../../reseaux/docker-compose.md){target="_blank"}
- Savoir utiliser un editeur de texte (nano, vi, emac)

Commencez par avoir un site hello world en https avec certbot et nginx. (un simple fichier html qui dit bonjour suffit.)

Une fois le https fait avec certbot, on attaque la partie modification pour Mastodon.

fichier /etc/nginx.conf ou fichier dans /etc/nginx/sites-enables ou etc/nginx/sites-available :
```yaml
server {
    server_name votre_nom_de_domaine.Pouet;
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    #ici normalement c'est certbot qui à tout écrit
    ssl_certificate /etc/letsencrypt/live/liens_vers_votre_certif.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/lien_vers_votre_certif_priv.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    location / {
    # ligne à modifier pour mastodon
    proxy_pass http://127.0.0.1:4080; # adresse localhost sur le port 4080 pour mastodon
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    }

}
```

!!!tips
        Modifiez le nom de domaine et le couple adresse IP/port en fonction de votre projet.

Le fichier podman-compose.yml :

```yaml
version: '3.8'

services:
  db:
    restart: always
    image: docker.io/postgres:latest
    shm_size: 256mb
    networks:
      - internal_network
    healthcheck:
      test: ['CMD', 'pg_isready', '-U', 'postgres']
    volumes:
      - ./postgres14:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: votre_mot_de_passe_postgres
      POSTGRES_DB: mastodon_production
      POSTGRES_USER: mastodon

  redis:
    restart: always
    image: docker.io/redis:latest
    networks:
      - internal_network
    healthcheck:
      test: ['CMD', 'redis-cli', 'ping']
    volumes:
      - ./redis:/data

  web:
    image: docker.io/tootsuite/mastodon:latest
    restart: always
    env_file: .env
    command: bash -c "rm -f /mastodon/tmp/pids/server.pid; bundle exec rails s -p 3000"
    networks:
      - external_network
      - internal_network
    ports:
      - "4080:3000"
    depends_on:
      - db
      - redis
    volumes:
      - ./public/system:/mastodon/public/system
    healthcheck:
      test: ['CMD-SHELL', 'wget -q --spider --proxy=off localhost:3000/health || exit 1']

  streaming:
    image: docker.io/tootsuite/mastodon:latest
    restart: always
    env_file: .env
    command: node ./streaming
    networks:
      - external_network
      - internal_network
    depends_on:
      - db
      - redis
    healthcheck:
      test: ['CMD-SHELL', 'wget -q --spider --proxy=off localhost:4000/api/v1/streaming/health || exit 1']

  sidekiq:
    image: docker.io/tootsuite/mastodon:latest
    restart: always
    env_file: .env
    command: bundle exec sidekiq
    depends_on:
      - db
      - redis
    networks:
      - external_network
      - internal_network
    volumes:
      - ./public/system:/mastodon/public/system
    healthcheck:
      test: ['CMD-SHELL', "ps aux | grep '[s]idekiq\ 6' || false"]
networks:
  external_network:
  internal_network:
    internal: true

```
!!!tips
        Changez le mot de passe, nom et user de la base de données et le port du serveur web si besoin.

Un gros fichier environnement doit être fourni:
fichier .env
```yaml
LOCAL_DOMAIN=votre_domaine
SINGLE_USER_MODE=false

DB_HOST=db
DB_USER=mastodon
DB_NAME=mastodon_production
DB_PASS=votre_mot_de_passe_postgres
DB_PORT=5432

SMTP_SERVER=smtp.mail.fr
SMTP_PORT=PortSmtp
SMTP_LOGIN=LoginMail
SMTP_PASSWORD=password_mail
SMTP_FROM_ADDRESS=adresse_mail
SMTP_DOMAIN=adresse_mail
SMTP_DELIVERY_METHOD=smtp
SMTP_AUTH=login
SMTP_ENABLE_STARTTLS_AUTO=true
SMTP_OPENSSL_VERIFY_MODE=none


CLOSED_REGISTRATIONS=false

REDIS_HOST=redis
REDIS_PORT=6379

SECRET_KEY_BASE=Clé_secrete
OTP_SECRET=Clé_secrete

PAPERCLIP_SECRET=Clé_secrete
ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY=Clé_secrete
ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT=Clé_secrete
ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY=Clé_secrete
```
!!!tips
        Pensez à recopier les valeurs de la db (mpd, nom ,etc) et mettre des clés secretes.
        La commande podman-compose run --rm web rails secret peut vous aider à générer des clés secretes.
        Sinon vous pouvez utilisez un generateur de cle : https://www.tirage-au-sort.net/generateur-clef-aleatoire

Vous pouvez maintenant démarrer Mastodon :

```bash
podman-compose up -d
```
Mettez en place le site et la base de données :

```bash
podman-compose run --rm --no-deps web rails db:setup
podman-compose run --rm --no-deps web rails assets:precompile
podman-compose run --rm web rails db:migrate
```

crée un compte user Dans votre Mastodon.

Maintenant vous donnez les droits admin/owner via la console ruby:

```bash
podman-compose run --rm web bin/tootctl accounts modify username --role Owner
```

Voilà vous n'avez plus qu'a faire venir des gens et faire de la modération/animation etc ...

Ajoutez un service systemd pour redemarrer Mastodon en cas de reboot serveur :

fichier /etc/systemd/system/mastodon.service
```yaml
[Unit]
Description=redemarre mastodon
After=network.target

[Service]
Type=oneshot
RemainAfterExit=true
ExecStart=/usr/bin/podman-compose --file Chemin_vers_votre_docker-compose.yml up -d
ExecStop=/usr/bin/podman-compose --file Chemin_vers_votre_docker-compose.yml down
User=votre_utilisateur_sur_le_serveur

[Install]
WantedBy=multi-user.target
```

!!!tips
        Modifiez le chemin d'accès et l'utilisateur
Une fois fait un sudo systemctl enable mastodon.service pour activer le redemarage des containeur en cas de coupure électrique ou reboot serveur.
