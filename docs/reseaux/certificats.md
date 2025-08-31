# Certificat et https

Les certificats vous permettent de sécuriser la connexion entre le client et le serveur en activant un cryptage entre eux.
Ainsi, les données échangées entre le serveur et le client ne peuvent pas être lues.

## DNS serveur et client

Mais avant un petit rappel sur les DNS :
![schema internet](autohebergement/fonctionnement_internet.png#only-light){width=600}
![schema internet](autohebergement/fonctionnement_internet_dark.png#only-dark){width=600}

1. Le client demande une IP lié à adresse internet aux serveurs DNS
1. Le serveur DNS envoie une adresse IPLe client demande au serveur, situé à l'adresse IP, la page internet
1. Le serveur envoie la page demandée
1. Le client affiche la page certificat : une affaire de confiance

Le but du certificat est de certifier que tout le monde est bien celui qu'il prétend. Pour ce faire, il faut un certificateur.
Le certificateur va vérifier que l'adresse du site pointe bien vers le bon serveur.
Il émet ensuite un certificat qui garantit que le DNS envoie bien vers le bon serveur.
Les certificateurs les plus connus sont
[https://letsencrypt.org/fr/](https://letsencrypt.org/fr/){target="_blank"} et
[https://www.cloudflare.com/fr-fr/](https://www.cloudflare.com/fr-fr/){target="_blank"}

Les certificats SSL contiennent les informations suivantes dans un seul fichier de données :

- Le nom de domaine pour lequel le certificat a été délivré.
- La personne, l'organisation ou l'appareil pour lequel il a été délivré.
- Quelle autorité de certification l'a délivré.
- La signature numérique de l'autorité de certification.
- Les sous-domaines associés.
- La date d'émission du certificat.
- La date d'expiration du certificat.
- La clé publique (la clé privée est gardée secrète).

Donc il faut maintenant rajouter des étapes pour la connexion SSL.
![schema internet](autohebergement/fonctionnement_internet.png#only-light){width=600}
![schema internet](autohebergement/fonctionnement_internet_dark.png#only-dark){width=600}

1. Le client demande une IP lié à adresse internet aux serveurs DNS.
1. Le serveur DNS envoie une adresse IP.
1. Le client demande au serveur, situé à l'adresse IP, le certificat.
1. Le serveur envoie son certificat.
1. Le client examine le certificat (date d'expiration, host qui correspond, certificateur approuvé,....).
1. Configuration entre le client et le serveur de la connexion sécurisée.
1. Le serveur envoie la page demandée.
1. Le client affiche la page.

## Certbot

Le plus simple : [certbot](https://certbot.eff.org/){target="_blank"}
Il peut vous générer un certificats letsencrypt et modifier votre serveur pour le https.
par exemple un serveur http avec nginx:

Dans votre fichier de configuration vous trouverez ça :

```nginx
[...]    
    server {
        listen       80;
        server_name  barrmath.ovh;
        location{
            [...]
        }
    }
```

**listen** : permet d'écouter sur le port http (port 80).
**server_name** : Le serveur à le même nom que votre site internet (host).
Le but de certbot seras de générer un certificat et de vous modifier votre serveur pour afficher le site en https
La manipulation du site fonctionne après avoir installé cerbot, il faut juste le lancer. L'option certonly permet de ne pas modifier nginx

```shell
sudo certbot --nginx 
sudo certbot certonly --nginx
```

Une fois votre certificat généré avec la première commande, vous pouvez tester votre site en https.
Certbot a modifié votre configuration pour écouter le port 80 (http) et rediriger vers le port 443 (https). Et il a configuré un serveur https.
Dans ce cas, votre site est accessible en https, mais il n'est plus disponible en https.

Ce site personnel n'a pas de secret à garder (pas de base de données, ni de compte, ...). Si le vôtre non plus, il pourrait être en http et en https.
Avec la deuxième commande, il suffit de créer un deuxième serveur dans la config de nginx.

```nginx
    server {
        listen       443 ssl;
        server_name  barrmath.ovh;

        ssl_certificate /etc/letsencrypt/live/barrmath.ovh/fullchain.pem; # managed by Certbot
        ssl_certificate_key /etc/letsencrypt/live/barrmath.ovh/privkey.pem; # managed by Certbot
        include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
        ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
        location / {
            [...]
        }
    }
```

Pour ma part, j'ai d'abord utilisé la première commande certbot puis modifier la configuration de nginx.

## Renouvellement

La commande

```shell
certbot renew -q
```

permet de renouveler le certificat. En effet, il expire tous les 90 jours.
Vous pouvez automatiser avec crontab. (crontab -e puis ajouter @monthly sudo certbot renew -q).

## Ressources

[https://letsencrypt.org/fr/](https://letsencrypt.org/fr/){target="_blank"}

[https://www.cloudflare.com/fr-fr/](https://www.cloudflare.com/fr-fr/){target="_blank"}

[Certbot](https://certbot.eff.org/){target="_blank"}
