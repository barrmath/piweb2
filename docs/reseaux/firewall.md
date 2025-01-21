# Firewall

## Rappel adresse IP et port


Vulgarisons.
Une adresse IP est une adresse pour reconnaître un ordinateur.
Les ports sont comme des portes. Une adresse IPV4 est souvent protégée par un Nat, qui a souvent un pare-feu.
Une adresse IPV6 n'est pas souvent protègée par un NAT, il faut donc la protéger avant de l'exposé.

Pour plus de détail :

- [adresse IP4](https://web.maths.unsw.edu.au/~lafaye/CCM/internet/ip.htm){"target=_blank"}
- [adresse IP6](https://www.ionos.fr/digitalguide/serveur/know-how/quels-sont-les-avantages-de-ipv6/){"target=_blank"}
- [port](https://web.maths.unsw.edu.au/~lafaye/CCM/internet/port.htm){target="blank"}

## Principe

Prenons votre adresse postale : 3 rue bidule 99999 Vilage-sur-mer, c'est votre adresse IP.
Et tout ce qui peut faire entrer ou sortir des trucs de votre maison est un port. 

Votre porte d'entrée est donc un port. Vous contrôlez qui rentre chez vous ou non. La nuit, vous fermez la porte, car vous voulez que personne n'entre la nuit.

Votre entrée d'air (au-dessus de vos fenêtres). Vous ne contrôlez pas son trafic. (en général). Car ces entrées doivent rester ouvertes.

Un firewall permet de contrôler ce qui rentre ou sort de votre ordinateur.

## Logiciel/matériel

Un firewall peut-être installé comme un logiciel ([pfense](https://www.pfsense.org/){"target=_blank"},
 [iptable](https://fr.wikipedia.org/wiki/Iptables){"target=_blank"}, 
 [ufw](https://wiki.ubuntu.com/UncomplicatedFirewall?action=show&redirect=UbuntuFirewall){"target=_blank"}) ou
 comme un matériel (inclus dans un [routeur par exemple](https://www.fs.com/fr/blog/network-switch-vs-network-router-vs-network-firewall-8403.html){target="_blank"})

Les pare-feu ou firewalls en général fonctionnent en mode fermé par défaut.

!!! warning
    Vérifiez bien que vous ayez au moins ouvert votre port pour votre ssh.

## Les régles

Il faut un peu réfléchir à votre projet, ou à votre serveur. Pour le firewall, il faut :

- Lister les ports utilisés par vos applications (et ne pas oublier votre ssh)
- Quels protocoles sont utilisés par les ports. (ipv4, ipv6)
- Quels ordinateurs peuvent appeler les ports (sur un serveur web, tout le monde doit pouvoir demander des pages web, le ssh on filtre)

N'hésitez pas à documenter votre réseau. Ça peut servir pour un futur dépannage. Voici divers outils pour faire cela :

- [extension libre-office](https://extensions.libreoffice.org/en/extensions/show/vrt-network-equipment){target="_blank"}
- [draw.io](https://www.draw.io/){target="_blank"}
- [Nmap](https://nmap.org/){target="_blank"}

## Exemple ufw

Un peu de pratique.

### Installation

Par le gestionnaire de paquets, c'est un firewall pour Linux.

```shell
sudo apt install ufw
```

```shell
ufw version
ufw help
```
Affiche la version et l'aide.

### Mettre en place les régles

```shell
sudo ufw allow 850
```
Ouvre le port 850

```shell
sudo ufw allow 25/tcp
```
Ouvre le port 25 en tcp uniquement


```shell
sudo ufw allow out 2685/udp
```
Ouvre le port 2685 en sortie et en udp uniquement.

```shell
sudo ufw insert 1 deny from [ip]
```
Bloquez une IP sur tous les ports. Le **insert 1** met cette règle en premier. Obligatoire pour faire passer les deny en priorité.

```shell
sudo ufw allow from 15.15.15.15 to any port 22
```
Autoriser le port 22 uniquement à 15.15.15.15

### Verifier les régles

```shell
sudo ufw status
```
Affiche les règles. Un petit (V6) apparait pour les règles ipV6. Sans indication, c'est une règle IPV4.

```shell
sudo ufw status numbered
```
Affiche les règles avec un numéro.

### Enlevez des régles

```shell
sudo ufw delete allow 80
```
Supprime la règle qui ouvre le port 80.

```shell
sudo ifw delete 8
```
Suprimme la règle numéro 8 (afficher sur status numbered)


### Démarrer le pare-feu

!!!warning
    Vous n'avez pas oublié ssh hein ?


```shell
sudo ufw enable
```
Démarre le pare-feu. Un message vous prevenant que cela risque de bloquer ssh apparait. Dite oui (enfin yes).


### Éteindre le pare-feu

```shell
sudo ufw disable
```
Éteint le pare-feu.

!!!tips
    Si vous avez oublié le ssh, (on vous avez prévenu non ?)
    Débrouillez-vous pour accéder au fichier /etc/ufw/ufw.conf. Changer ENABLE=yes par ENABLED=no et redémarrer le serveur.

## Le pare-feu windows

Les Windows possèdent aussi leurs pare-feu inclus :

[doc pare feu microsoft](https://support.microsoft.com/fr-fr/windows/activer-ou-d%C3%A9sactiver-le-pare-feu-de-microsoft-defender-ec0844f7-aebd-0583-67fe-601ecf5d774f){target="_blank"}

## Conclusion

Vous avez maintenant une protection minimale pour votre serveur.

La cybersécurité évolue de plus en plus. Formez-vous et essayez de rester informé.

## Ressource

[adresse IP4](https://web.maths.unsw.edu.au/~lafaye/CCM/internet/ip.htm){"target=_blank"}

[adresse IP6](https://www.ionos.fr/digitalguide/serveur/know-how/quels-sont-les-avantages-de-ipv6/){"target=_blank"}

[port](https://web.maths.unsw.edu.au/~lafaye/CCM/internet/port.htm){target="blank"}

[pfense](https://www.pfsense.org/){"target=_blank"}

[iptable](https://fr.wikipedia.org/wiki/Iptables){"target=_blank"}

[Doc ufw](https://wiki.ubuntu.com/UncomplicatedFirewall?action=show&redirect=UbuntuFirewall){"target=_blank"}

[routeur par exemple](https://www.fs.com/fr/blog/network-switch-vs-network-router-vs-network-firewall-8403.html){target="_blank"}

[extension libre-office](https://extensions.libreoffice.org/en/extensions/show/vrt-network-equipment){target="_blank"}

[draw.io](https://www.draw.io/){target="_blank"}

[Nmap](https://nmap.org/){target="_blank"}

[doc pare feu microsoft](https://support.microsoft.com/fr-fr/windows/activer-ou-d%C3%A9sactiver-le-pare-feu-de-microsoft-defender-ec0844f7-aebd-0583-67fe-601ecf5d774f){target="_blank"}