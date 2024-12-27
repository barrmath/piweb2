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