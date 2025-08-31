# Mise en place du forum (en autohebergement)

Vous avez un site web et vous voulez ouvrir un forum pour permettre de faire des discussions entre passionnées ?
Je vous présente Flarum : [https://flarum.org/](https://flarum.org/){target="_blank"}

Alors le but est d'avoir une image Docker et un docker-compose qui les lances.

## Dockerfile

Flarum ne fournit pas d'image. On va devoir en créer une.

dockerfile:

```yaml
FROM debian:latest


# Mise à jour et installation des dépendances
RUN apt update && apt upgrade -y
RUN apt install -y nginx php8.4 php8.4-fpm php8.4-xml php8.4-mysql php8.4-gd composer curl openssl zip gettext-base

# Installation de Flarum dans /flarum
WORKDIR /flarum
RUN composer create-project flarum/flarum:^1.8.0 .
RUN composer require flarum/extension-manager:"*"
RUN composer require flarum-lang/french
RUN composer require fof/upload "*"
RUN composer require fof/nightmode:"*"
# Configuration de PHP-FPM pour PHP 8.4
RUN echo "[www]" > /etc/php/8.4/fpm/pool.d/www.conf && \
    echo "user =  www-data" >> /etc/php/8.4/fpm/pool.d/www.conf && \
    echo "group =  www-data" >> /etc/php/8.4/fpm/pool.d/www.conf && \
    echo "listen = 9000" >> /etc/php/8.4/fpm/pool.d/www.conf && \
    echo "pm = dynamic" >> /etc/php/8.4/fpm/pool.d/www.conf && \
    echo "pm.max_children = 5" >> /etc/php/8.4/fpm/pool.d/www.conf && \
    echo "pm.start_servers = 2" >> /etc/php/8.4/fpm/pool.d/www.conf && \
    echo "pm.min_spare_servers = 1" >> /etc/php/8.4/fpm/pool.d/www.conf && \
    echo "pm.max_spare_servers = 3" >> /etc/php/8.4/fpm/pool.d/www.conf && \
    echo "php_admin_value[error_log] = /var/log/php-fpm/error.log" >> /etc/php/8.4/fpm/pool.d/www.conf && \
    echo "php_admin_flag[log_errors] = on" >> /etc/php/8.4/fpm/pool.d/www.conf
# Configuration de Nginx pour Flarum
COPY default.conf.template /etc/nginx/sites-available/default.template
COPY config.sh config.sh
COPY config.php.template config.php.template

EXPOSE 80
CMD sh config.sh
```

Dans cette image, vous avez nginx, php et flarum. Elle a besoin de 3 fichiers : un fichier config.sh un fichier config.php.template qui contient la config de Flarum et default.conf.template pour nginx.

config.sh:

```bash
export DOLLAR="$" #permet de tricher avec pour envsubt
rm /etc/nginx/sites-enabled/default
envsubst < /etc/nginx/sites-available/default.template > /etc/nginx/sites-enabled/default.conf
#envsubst < ./config.php.template > ./config.php # à decommenter après la config
service php8.4-fpm start && nginx -g "daemon off;"
```

default.conf.template:

```yaml
server {
    listen 80;
    server_name ${DOMAIN} ;
    root /flarum/public;  # Chemin vers le dossier public de Flarum
    index index.php;

    location / {
        try_files ${DOLLAR}uri ${DOLLAR}uri/ /index.php?${DOLLAR}query_string;
    }

    location ~\.php${DOLLAR} {
        fastcgi_split_path_info ^(.+\.php)(/.+)${DOLLAR};
        fastcgi_pass 127.0.0.1:9000;
        fastcgi_index index.php;
        include /etc/nginx/fastcgi_params;
        fastcgi_param SCRIPT_FILENAME ${DOLLAR}document_root${DOLLAR}fastcgi_script_name;
        fastcgi_param PATH_INFO ${DOLLAR}fastcgi_path_info;
    }

    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)${DOLLAR} {
        expires max;
        log_not_found off;
    }
}
```

config.php.template :

```php
<?php return array (
  'debug' => false,
  'database' => 
  array (
    'driver' => 'mysql',
    'host' => '${DBHOST}',
    'port' => 3306,
    'database' => '${MYSQL_DATABASE}',
    'username' => '${MYSQL_USER}',
    'password' => '${MYSQL_PASSWORD}',
    'charset' => 'utf8mb4',
    'collation' => 'utf8mb4_unicode_ci',
    'prefix' => '',
    'strict' => false,
    'engine' => 'InnoDB',
    'prefix_indexes' => true,
  ),
  'url' => '${PROTOCOL}${DOMAIN}',
  'paths' => 
  array (
    'api' => 'api',
    'admin' => 'admin',
  ),
  'headers' => 
  array (
    'poweredByHeader' => true,
    'referrerPolicy' => 'same-origin',
  ),
);
```

## docker-compose

On va faire un fichier docker compose pour avoir une base de données mariaDB avec le forum.

docker-compose.yml :

```yaml
services:
  flarum:
    image: flarum
    container_name: flarum
    restart: unless-stopped
    env_file:
      - .env
    volumes:
      - ./flarum-assets:/flarum/assets
      - ./flarum-extensions:/flarum/extensions
      - ./flarum-public-assets:/flarum/public/assets
    ports:
      - "8080:80"
    depends_on:
      - flarum-db

  flarum-db:
    image: docker.io/mariadb
    container_name: flarum-db
    restart: unless-stopped
    env_file:
      - .env
    volumes:
      - ./flarum-db:/var/lib/mysql
```

Les variables d'environnement

.env:

```bash
MYSQL_ROOT_PASSWORD=mot_de_passe_super_compliqué_admin
MYSQL_DATABASE=flarum
MYSQL_PASSWORD=ot_de_passe_super_compliqué_user
MYSQL_USER=flarum
DBHOST=flarum-db
DOMAIN=localhost:8080
PROTOCOL=http://
```

Pensez à changer les mots de passe, mysql_user le protocol et le domaine.

Premiere exexcution :

```bash
podman build -t flarum .
podman-compose -up -d
```

Configurer le forum (Admin base de données etc.) via l'adresse (par défaut [http://localhost:8080](http://localhost:8080){target="_blank"})
Votre adresse du forum dans votre cas.

!!!warning
        Quelquefois, il faut faire un chmod 775 dans le dossier des volumes sur votre serveur.

Enlevé le commentaire dans config.sh

```bash
export DOLLAR="$" #permet de tricher avec pour envsubt
rm /etc/nginx/sites-enabled/default
envsubst < /etc/nginx/sites-available/default.template > /etc/nginx/sites-enabled/default.conf
envsubst < ./config.php.template > ./config.php # à decommenter après la config
service php8.4-fpm start && nginx -g "daemon off;"
```

Reconstruire l'image puis éteindre et relancer le forum :

```zsh
podman build -t flarum .
podman-compose down
podman-compose up -d
```

Faire un service systemd, en cas de redémarrage forcé du serveur :

etc/systemd/system/flarum.service :

```systemd
[Unit]
Description=redemarre Flarum
After=network.target

[Service]
Type=oneshot
RemainAfterExit=true
ExecStart=/usr/bin/podman-compose --file /home/tux/flarum/docker-compose.yml up -d
ExecStop=/usr/bin/podman-compose --file /home/tux/flarum/docker-compose.yml down
User=tux

[Install]
WantedBy=multi-user.target
```

puis activez le service :

```zsh
sudo systemctl enable flarum.service
```
