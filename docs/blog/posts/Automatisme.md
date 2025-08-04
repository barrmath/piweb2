---
date : 2025-07-28
categories :
    - automatisme
---

# Jenkins crown et systemd

Pour faire simple :
Dès que je veux faire un truc repetifs quelque part je le fous sur Jenkins.
Un seul outil pour tout faire.
Mise à jour du site internet => Jenkins via un appel par script
Mise à jours des PC => mise à jours via un trigger quotidien.

Et en plus, il fait le suivi en cas de soucis. J'aime bien cet outil.

Systemd me permet lui de gérer mes coupures électriques qui font redémarrer mon serveur. (un onduleur avec batterie, ça coûte cher)

Il suffit de rajouter un fichier dans le dossier /etc/systemd/system :

```bash
cd /etc/systemd/system
nano truc.service
```

Exemple jenkins.service :

```yaml
[Unit]
Description=redemarre jenkins
After=network.target

[Service]
Type=oneshot
RemainAfterExit=true
ExecStart=/usr/bin/podman-compose --file /home/foo/jenkins_docker/docker-compose.yml up -d
ExecStop=/usr/bin/podman-compose --file /home/foo/jenkins_docker/docker-compose.yml down
User=foo

[Install]
WantedBy=multi-user.target

```

Et zou, on redémarre le ou les containeurs au démarrage.
Bref une sorte de combo gagnant.