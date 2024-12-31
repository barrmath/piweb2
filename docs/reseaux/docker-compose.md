# Docker-compose

On a appris à faire des conteneurs. Mais souvent une application web ou autre nécessite plusieurs conteneurs.
Par exemple :
- Une base de données
- Un serveur front-back
C'est dans ce cas que l'on utilise les orchestrateurs de conteneurs.

## Podman/Docker-compose

D'autres orchestrateurs existent comme [openshift](https://www.redhat.com/fr/technologies/cloud-computing/openshift){target="_blank"} ou [kubernetes](https://kubernetes.io/){target="_blank"}

Je vais prendre exemple sur ce projet : [openshift](https://www.redhat.com/fr/technologies/cloud-computing/openshift){target="_blank"} ou [kubernetes](https://kubernetes.io/){target="_blank"}

Pour installer docker-compose, installez le paquet avec votre gestionnaire de paquets préféré. Pour podman-compose allez plus [bas](#utilisation).

### docker-compose.yml

```yaml
version: "3.9"
volumes:
  data: 
services:
  mypgdb:
    image: docker.io/library/postgres:latest
    container_name: mypgdb
    restart: unless-stopped
    env_file:
      - django.env
    volumes:
      - data:/var/lib/postgresql/data
    networks:
      - network-benevalibre
  django:
    image: bene:latest
    container_name: django
    restart: unless-stopped
    env_file:
      - django.env
    networks:
      - network-benevalibre
    ports:
      - "5000:80"
networks:
  network-benevalibre: # Définition d'un réseau personnalisé
    driver: bridge # Type de réseau
```

Analysons un peu le code :

- volumes : permets de créer des volumes qu'on garde sur le disque même si le conteneur est arrêté. Ça permet par exemple de garder les documents de la base de données.
- services : on définie les conteneurs qui doivent tourner ensemble. On les nomme et on les définit.
    - image : emplacement de l'image docker builder (construite)
    - container_name: nom du conteneur
    - restart: condition de redémarage du conteneur
    - env_file : si vous utilisez un fichier avec des variables d'environnement
    - networks : definie les reseaux accessible au conteneneur (voir plus bas)
- network : détermine les reseaux entre les conteneurs
    - nom-du-réseaux
    - driver :  type de réseaux

Pour le type de réseaux en docker, ce sont les mêmes que pour les VM.
Plus d'information su la [documentation officielle](https://docs.docker.com/compose/how-tos/networking/){target="_blank"}

## Utilisation

!!! warning
    Pour Podman, installez le packet podman-compose et dans les dépendances optionnelles, vous trouverez souvent un paquet pour le dns rootless.

    Exemple : [aardvark-dns](https://github.com/containers/aardvark-dns){target="_blank"}

Il faut d'abord avoir les bonnes images disponibles. N'oubliez pas de construire les images avant avec la commande :

Version podman

```shell
podman build -f Nom_du_dockerfile -t bene
```

Version docker

```shell
docker build -f Nom_du_dockerfile -t bene .
```

Une fois les images construites, vous pouvez lancer les conteneurs avec la commande :

Version podman

```shell
 podman-compose up  -d
```

Version Docker

```shell
docker-compose up -d
```

Le '-d' permets de détacher podman-compose de la console.

SI vous voulez arretez les conteneurs :

Version podman

```shell
podman-compose down
```

Version docker

```shell
docker-compose down
```