# Proxy

## Qu'est ce qu'un proxy?

Pour vulgariser, il s'agit d'un intermedaire entre 2 services, ou 2 ordinateurs.
Par exemple :

- Votre ordinateur passe par un proxy : le proxy peut par exemple empécher l'accès à certains sites
- En vous connectant à un proxy vous pouvez contourner les filtrages (un proxy est un intermédiaire, pensez aux pub de VPN sur youtube)
- Surveillez les communcations entre plusieurs apareils, et créer des logs en cas d'obligation

Mon VPN est un proxy alors ?
Vous vous connectez bien à un intermédaire pour pouvoir accéder à des sites web. Donc selon la définition, oui.
Le VPN (Virtual Private Network) est surtout le moyen de vous connecter á un proxy.
Par exemple vous pouvez un tunnel VPN avec votre [Freebox.](https://www.actusfree.fr/vpn-freebox/){target="_blank"}
Vous pouvez accéder à vos ordinateurs de manière sécuriser. Installez un proxy qui vous donne renvoie le site internet voulu.
Voila vous venez de créer un VPN comme dans la pub (sauf que vous pouvez pas changer de pays sauf si vous installer plein de freebox partout)
Dans le cas suivant je vais vous montrer comment utiliser un proxy en utilisant [nginx](https://nginx.org/en/){target="_blank"}
Donc maintenant si vous bien compris :

- Un VPN utilise un proxy.
- Un proxy est un intermédiaire pouvant surveiller vos communications
- Donc je dois avoir confiance dans mon fournisseur VPN, car il peut vous surveiller

Mes excuses pour cette petite disgression.

## nginx

NGINX Open Source2 ou NGINX (également orthographié Nginx ou nginx) est un logiciel libre de serveur Web (ou HTTP)
ainsi qu'un proxy inverse écrit par Igor Sysoev, dont le développement a débuté en 2002 pour les besoins d'un site russe
à très fort trafic (Rambler). Source [wikipedia](https://fr.wikipedia.org/wiki/NGINX){target="_blank"}

Nginx va servir d'intermediaire entre Gunicorn et Internet.

- Nginx va gerer les log de connection
- Nginx peut s'occuper de gerer le https
- Nginx peut aussi renvoyé les requetes http vers le https. (on parle de reverse proxy)

### Installation et Configuration

Sous linux installation par gestionnaire de paquets (apt-get install nginx), image docker
Sous windows et mac l installateur se trouve dans la session
[téléchargement du site nginx.org](https://nginx.org/en/download.html){target="_blank"}

La configuration se fait dans le fichier /etc/nginx/nginx.conf
Vous pouvez créer plusieurs fichiers pour ne pas tout mettre dans le fichier configuration.
Un petit tuto est disponible [ici.](https://www.malekal.com/nginx-comment-activer-un-site-avec-sites-enabled-ou-nginx-modsite/){target="_blank"}

Sinon pour faire simple :
Pour configurer un service nginx, il faut ajouter un service au fichier nginx.conf, par exemple :

```nginx
http { # nom du service
    include       mime.types;
    default_type  application/octet-stream;

    # configurer les logs les options du services ...
    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #gzip  on;

    server { #configurer le serveur
        listen       872; #port à écouter
        server_name  adresse.votresite; # nom du serveur (utile par exemple pour les certificats)

        #charset koi8-r;

        #access_log  logs/host.access.log  main;
        
        # pour indiquer à Flask qu'il se trouve derriere un proxy
        location / {
            proxy_pass http://localhost:3513;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Host $host;
            proxy_set_header X-Forwarded-Prefix /;
        }

        #error_page  404              /404.html; #si vous voulez configurer les pages d'erreurs

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {   
            root   /usr/share/nginx/html;
        }
    }
```

Pour un site statique, ou les fichiers statiques pour alléger le backend, il vous faut un utilisateur avec les droits d'accès aux fichiers, préciser le chemin web avec location et indiqué diverses options.

```nginx
user tux;
   server {
        server_name  barrmath.ovh ;
        location / {
                alias /home/tux/piweb2/site/;
                index index.html;
                try_files $uri $uri/ $uri.html =404;
        }
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   /usr/share/nginx/html;
        }
    }

```

!!! tips
    La fonction envsubst peut vous permettre de modifier vos fichier conf dans des containeurs de votre nginx.conf. Il suffit de faire un template.

exemple:

fichier nginx.template

```nginx
user root;
worker_processes                auto; # it will be determinate automatically by the number of core

error_log                       /var/log/nginx/error.log warn;
#pid                             /var/run/nginx/nginx.pid; # it permit you to use rc-service nginx reload|restart|stop|start

events {
    worker_connections          1024;
}

http {
    include                     /etc/nginx/mime.types;
    default_type                application/octet-stream;
    sendfile                    on;
    access_log                  /var/log/nginx/access.log;
    keepalive_timeout           3000;
    server {
        listen                  80;
        location ${BASE_URL}static/{
            alias /app/benevalibre/var/static/;
            # Optionnel : ne pas journaliser l'accès au fichier statisque
            access_log off;
        }
        location ${BASE_URL}media/ {
            alias /app/benevalibre/var/media;
            # Optionnel : ne pas journaliser l'accès aux media
            access_log off;
        }
        location ${BASE_URL}favicon.ico {
            alias /app/benevalibre/var/static/favicon/favicon.ico;
            # Optionnel : ne pas journaliser l'accès au favicon
            access_log off;
        }
        location ${BASE_URL}{
            proxy_set_header Host ${DOLLAR}http_host;
            proxy_set_header X-Forwarded-For ${DOLLAR}proxy_add_x_forwarded_for;
            proxy_redirect off;
            proxy_pass http://127.0.0.1:8000;
        }
        error_page              500 502 503 504  /50x.html;
        location /50x.html {
              root /var/lib/nginx/html;
        }
    }
}
```

```shell
export DOLLAR="$"
envsubst < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
```

!!! tips
    Le export dollar="$" permet de garder le $ nécessaire dans les proxy_set_header

### Nginx version aéré et routage

C'est bien beau, mais imaginer que vous avez besoin de plusieurs noms de domaines pour héberger plusieurs sites.
Votre nginx.conf va devenir assez vite un joli bordel.

Améliorons ça. Le but est de séparer les fichiers des différents sites/app web.

Nginx.conf :

```bash
user user;
worker_processes  1;
error_log  /var/log/nginx/error.log;
pid        /var/run/nginx.pid;
events {
        worker_connections  1024;
    }

http {
    include       /etc/nginx/mime.types;
    default_type application/octet-stream;
    access_log  /var/log/nginx/access.log;
    sendfile        on;
    #tcp_nopush     on;
    keepalive_timeout  5000;
    # envoi moins d'information sur le serveur
    server_tokens off;

    # active la compression des pages sauf pour les navigateurs pourris
    gzip  on;
    gzip_comp_level 6;
    gzip_proxied any;
    gzip_vary on;
    gzip_types  text/plain text/css application/x-javascript;
    gzip_disable "MSIE [1-6]\.(?!.*SV1)";

    include /etc/nginx/conf.d/*.conf; # pour séparer les configurations (Perso j'utilise pas)
    include /etc/nginx/sites-enabled/*; # pour ajouter des sites web
    }
```

Les fonction include vont inclure tous les fichiers présents dans les répertoires.
Par défaut, les nouvelles versions de Nginx incluent aussi un dossier /etc/nginx/sites-available/. Le but est de créer des [liens symboliques](https://www.hostinger.com/fr/tutoriels/comment-creer-un-lien-symbolique-sous-linux){target="_blank"} dans le dossier site enable pour activer ou non les sites internet.
Perso je travaille directement avec un fichier dans sites-enabled (et vu ma proportion à travailler en essai erreur, je fais une copie du fichier qui marche enfin dans sites-available)

Bref un exemple de fichier simple :

```bash
server {
    server_name pouetpouet;
    listen 443 ssl http2;
    listen [::]:443 ssl http2;
    ssl_certificate /etc/letsencrypt/live/pouetpouet/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/pouetouet/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;

    location / {
        alias /home/tux/shared/hello/;
        index index.html;
        }
    }
```

Et vous voyez certbot fait encore 50 % du boulot pour la certification en modifiant les fichiers de nginx.
Alors pour info le server_name permet de selectionner les host (adresse http/nom de domaine/sousdomaine). En fonction du nom de domaine entré dans le navigateur, on utilise tel ou tel bloc serveur.

Je pourrais encore plus simplifier le fichier nginx.conf en sortant les configs de base (Gzip,timeout,etc) dans un ou plusieurs fichiers dans /etc/nginx/config
Mais on est déjà pas mal.

### Alternative

Suite au [rachat de Nginx par F5 Network](https://www.lemagit.fr/actualites/252459426/Nginx-tombe-dans-le-giron-de-F5-Networks-pour-670-millions-de-dollars){target="_blank"}, certaines personnes ont proposé un fork de nginx.

- [freenginx](https://freenginx.org/){target="_blank"} un fork 100% libre de nginx sans entreprise lucrative.
- [angie](https://en.angie.software/){target="_blank"} un fork du créateur original sous tutel de Angie sofware Société russe

Vous pouvez utiliser d'autre service comme [Apache httpd](https://httpd.apache.org/){target="_blank"}
ou [microsoft ISS](https://learn.microsoft.com/fr-fr/iis/get-started/introduction-to-iis/iis-web-server-overview){target="_blank"}

## Ressources

[nginx](https://nginx.org/en/){target="_blank"}

[freenginx](https://freenginx.org/){target="_blank"}

[angie](https://en.angie.software/){target="_blank"}

[Apache httpd](https://httpd.apache.org/){target="_blank"}

[microsoft ISS](https://learn.microsoft.com/fr-fr/iis/get-started/introduction-to-iis/iis-web-server-overview){target="_blank"}
