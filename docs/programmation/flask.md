# Flask

[Flask](https://flask.palletsprojects.com/en/3.0.x/){target="_blank"} est un module python pour le web.
Il fait office de back-end (un peu comme [PHP](https://www.php.net/manual/fr/intro-whatis.php){target="_blank"}.
Flask est un framework très modulaire. Pas de gestion de Base de données (possible avec [SQLalchemy](https://www.sqlalchemy.org/){target="blank"}).
Si vous voulez des options, il faut en général installer un autre module.
Il a une approche opposée à Django qui est clé en main.
Les principaux avantages de Flask sont sa simplicité, et sa légèreté.
Le principal défaut, il faut rechercher un module à chaque option ce qui alourdit le framework.
Il existe d'autres modules pour faire du web, par exemple :

- [Django](https://www.djangoproject.com/){target="_blank"}
- [fastAPI](https://fastapi.tiangolo.com/){target="_blank"}

Un petit descriptif pour chaque framework:

## Description rapide des autres frameworks

### Django

Django est un framework très complets (Base de données intégrée, divers outils d'administrations).
Mais si vous n'avez pas besoin de tous ces services, il risque d'être un peu lourd.

### FastAPI

Très ressemblant à Flask, il apporte des ajouts qui peuvent intéresser les développeurs.
Un article les comparants se trouve [ici](https://www.pythoniste.fr/python/fastapi/les-differences-entre-les-frameworks-flask-et-fastapi/){target="_blank"}.

## Installation de l'environnement

```shell
pip install flask
```

Il faudra peut être faire d'autres installations par la suite. Mais le simple flask suffit pour commencer.

## Utilisation

Il y a deux utilisations type. Une première où vous créer une application.
La deuxième ou vous créer une fonction qui fabrique l'application. (create factory).
Les deux méthodes possèdent des qualités et des défauts. Globalement créer une app est plus simple qu'une fonction créatrice.
La version create factory vous permet de créer plusieurs instances de votre application pour faire des tests et d'autres choses.
Plus d'information [ici](https://flask.palletsprojects.com/en/3.0.x/patterns/appfactories/){target="_blank"}.

### Arborescence

On peut tout mettre dans un seul fichier avec Flask.
Mais disons simplement que c'est rapidement le bordel avec une application un peu trop grosse.
Je conseille donc de faire au minimum une arborescence.
Mon application est architecturée comme cela :

```shell
├── README.md                        # Un fichier readme qui décris l'application et la mise en œuvre.
├── requirements. txt                # Un fichier qui liste les paquets python nécessaires
├── run.py                           # Le fichier de lancement de l'application
└── web_app                          # Le dossier qui contient l'application
    ├── __init__.py                  # Le fichier init pour créer un module python
    ├── static                       # Le dossier static pour les fichiers statiques (CSS, images, ...)
    ├── templates                    # Le dossier templates pour les templates html
    └── views.py                     # Le fichier qui vous permet de configurer les routes
```

Commençons par le fichier de lancement

### run.py

Le fichier de lancement d'une application flask

```python
from web_app import create_app

if __name__ == "__main__":
    # après verification, Gunicorn ne passe pas par la et se mets par defaut en debug=false
    app = create_app()
    app.run(debug=True, host="0.0.0.0", port=5000)
```

On importe du module la fonction créatrice.

`if __name__ == "__main__"`:  permet d'exécuter les lignes indexées en dessous que si le fichier est exécuté par python.

Ainsi, vous pouvez activer le debug mode dans ce fichier run,
mais si vous utilisez un serveur de production, le mode debug ne seras pas actif. Vous pouvez tester, on n'est jamais trop sûr.

`app = create_app()` : On crée un l'objet app.

`app.run(debug=True, host="0.0.0.0", port=5000` :
on lance un serveur de DEVELOPPEMENT sur l'adresse local 0.0.0.0 et sur le port 5000 avec le mode debug.

Ce fichier va servir à 2 choses :

- Lancer un serveur de DEVELOPPEMENT. (le serveur de flask n'est pas à utiliser en production, il faut utiliser un serveur de production)
- Donner des informations aux serveurs de production.

## __init__.py

On va modifier ce fichier pour créer la fonction créatrice.

```python
from flask import Flask


def create_app():
    app = Flask(__name__, static_folder="static")

    #app.config.from_object("config")

    # routage des pages web

    with app.app_context():
        import web_app.views

    return app
```

Vous pouvez ajouter un fichier config.py pour configurer une base de données, des clés d'accès à des services ...
Attention, protéger bien vos clés et mots de passe. Pensez variables d'environnements,
et utiliser le gitignore si vous avez un fichier avec des secrets.

### views.py

Il définit les routes utilisées par l'application.

```python
# import bibliothèque flask et création application flask
from flask import render_template, request, current_app, send_from_directory

app = current_app
... ... ... ...

@app.route("/robots.txt")
def static_from_root():
    return send_from_directory(app.static_folder, request.path[1:])

@app.route("/", methods=["GET", "POST"])
@app.route("/index/", methods=["GET", "POST"])
def Accueil():
    return render_template("index.html",liste_categorie=liste_categorie,categorie=liste_categorie[0])
```

On crée l'application et on définit les routes ici.
Vous avez un premier exemple avec le fichier [robots.txt](https://robots-txt.com/){target="_blank"}.
Vous en avez un deuxième avec la page index.
Vous définissez une ou plusieurs route avec @app.route (c'est un décorateur en python).
En dessous, vous définissez une fonction qui va retourner la page html.

### template, static et jinja2

Flask est fourni avec le front-end jinja2. Vous pouvez utiliser un autre front-end comme React ou Angular.
On peut créer des pages html dans le dossier template et faire les routes avec views.
Mais imaginons que j'ai plein de code qui se répète dans toutes les pages html.
Par exemple, le fameux doctype et autre : pour éviter de tout recopier sur chaque page, autant écrire une base
et demander à flask/jinja d'étendre la page html.
Exemple de fichier de base :

```html
<pre><!DOCTYPE html>
<html lang="fr">
    <head>
    <meta charset="utf-8">
    {% block content }{% endblock %}
    </head>
</html>
```

Fichier qui utilise la base :

```html
{% extends 'base.html' %}

{% block content %}
contenu de la page
{% endblock %}
```

Et voilà plus besoin de recopier le docktype partout. Vous pouvez bien sûr ajouter d'autre block
    que content comme footer ou autre en fonction de votre projet.
Et on peut encore aller plus loin.
Par exemple dans ma page base/html :

```html
<div class="topnav">
    {% for cat in liste_categorie %}
    <a class="{{ 'active' if categorie == cat }}" href={{ url_for(cat)}}>{{ cat }} </a>
    {% endfor %}
</div>
```

La topbar est créée à partir d'une liste, et d'une catégorie envoyée par flask. Rappelez-vous de la fonction :

```python
return render_template("index.html",liste_categorie=liste_categorie,categorie=liste_categorie[0])
```

## Pour aller plus loin SQL alchemy, login

Besoin d'une base de données : [https://www.sqlalchemy.org/](https://www.sqlalchemy.org/){target="_blank"}
Je conseille d'utiliser des variables d'environnement et un fichier config.py.
La base de données va, par exemple, servir à gérer des comptes qui vont se connecter à votre site.
La gestion des connexions peut être faite avec flask-login.
Le fichiers views.py commence à prendre de l'embonpoint. Diviser le avec les blueprints

## Serveur de développement,gunicorn et serveur web

Votre site est prêt, il est temps de tester. Lancer juste votre fichier run.py avec python.

```shell
python run.py
* Serving Flask app 'web_app'
* Debug mode: on
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
* Running on all addresses (0.0.0.0)
* Running on http://127.0.0.1:5000
Press CTRL+C to quit
* Restarting with stat
* Debugger is active!
* Debugger PIN: 330-144-452
```

Le serveur inclus dans Flask n'est pas prévu pour de fortes charges.
Il faut utiliser un [WSGI](https://perso.liris.cnrs.fr/pierre-antoine.champin/2017/progweb-python/cours/cm1.html){target="_blank"}, par exemple Gunicorn (pip install gunicorn).
Il faudra ensuite associer Gunicorn à un serveur web (apache ou nginx par exemple).

## Ressources

[Flask](https://flask.palletsprojects.com/en/3.0.x/){target="_blank"}

[PHP](https://www.php.net/manual/fr/intro-whatis.php){target="_blank"}

[Django](https://www.djangoproject.com/){target="_blank"}

[fastAPI](https://fastapi.tiangolo.com/){target="_blank"}

[https://www.sqlalchemy.org/](https://www.sqlalchemy.org/){target="_blank"}
