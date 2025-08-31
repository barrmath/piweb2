---
date : 2025-08-09
categories :
    - nginx
---

# Passage en www

Je vais avoir besoin de sous-domaine pour différents services donc je modifie la configuration de nginx.
Je passe d'un gros fichier à :

- un fichier /etc/nginx.conf pour la configuration générale
- un fichier proxy.conf pour la config du proxy
- un fichier par sous domaine.

Et on fait ça avec la commande include.
