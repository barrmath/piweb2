# Django

!!! warning
    En construction, non relu, faites pas attention aux fautes.

Pour un aperçu (non-exhaustif) des différents modules de [Flask](flask.md){target="_blank"}

C'est une page qui va être faite en mode agile en parallèle d'un projet que je fais. (GMAO, libre)

## Installation

Soit vous utilisez votre gestionnaire de paquets, soit un environnement virtuel et pip.

Pour un environnement virtuel :

Version Linux dans un terminal :

```bash
python -m venv venv
source venv/bin/activate
pip install django
```

Version Windows (Troll : je conseille d'installer Linux, mais faite ce que vous voulez)

Démarrez cmd ou powershell puis tapez :

```bash
python -m venv venv
venv/bin/activate.bat
pip install django
```

Personnellement, je crée un fichier requirements.txt et je note tous les paquets que j'installe un par un.
Puis un

```bash
pip install -r requirements.txt 
```

me permet d'installer tous les paquets. (Des outils comme [poetry](https://python-poetry.org/){target="_blank"} existe aussi).

## Démarrage d'un projet hello world

Django par rapport à Flask est plus monolithique. Il a donc une approche plus stricte que Flask.

Il fonctionne obligatoire avec une base de données.

Le serveur de développement vous livre les fichiers statiques. Le serveur de production ne livre plus les fichiers statiques, il faut donc prévoir un serveur web.

Pour démarrer un projet django GMAO :

```bash
django-admin startproject GMAO
```

Cela crée un dossier GMAO avec des fichiers :

``` sh
├── GMAO
│   ├── asgi.py # Configuraton ASGI (Uvicorn)
│   ├── __init__.py 
│   ├── settings.py # config du projet
│   ├── urls.py # gestion des URL 
│   └── wsgi.py # configuration du wsgi (Gunicorn)
└── manage.py #script qui fait plein de trucs
```

Pour info : [les différences entre gunicorn et uvicorn](https://medium.com/@ezekieloluwadamy/uvicorn-gunicorn-daphne-and-fastapi-a-guide-to-choosing-the-right-stack-76ffaa169791)

Lançons le serveur de dev grâce au script manage.py:

```bash
python manage.py runserver 127.0.0.1:5000
```

Allons sur 127.0.0.1:5000.

![hello world django](django/hello_django.png)

Youpi, django est installé.

Ce dossier vous permets de configurer django et les app qui tournent dessus. (eventuellement les WSGI ensuite).

## première application

Terminal :

```bash
python manage.py startapp login
```

Va créer une application login et un dossier login.
Votre dossier devrait ressembler à ça :

```bash
├── db.sqlite3
├── GMAO
│   ├── asgi.py
│   ├── __init__.py
│   ├── __pycache__
│   │   ├── __init__.cpython-313.pyc
│   │   ├── settings.cpython-313.pyc
│   │   ├── urls.cpython-313.pyc
│   │   └── wsgi.cpython-313.pyc
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
├── login
│   ├── admin.py
│   ├── apps.py
│   ├── __init__.py
│   ├── migrations
│   │   └── __init__.py
│   ├── models.py
│   ├── tests.py
│   └── views.py
└── manage.py
```

Modifions le fichier views.py dans login.

``` py title="views.py"
from django.http import HttpResponse


def index(request):
    return HttpResponse("Hello, world. You're at the login.")
```

On crée un fichier urls.py dans le dossier login.

``` py title="login/urls.py"
from django.urls import path

from . import views

urlpatterns = [
    path("", views.index, name="index"),
]
```

On configure django pour servir l'app avec son urls.py

```py title="GMAO/urls.py" hl_lines="7"
from django.contrib import admin
from django.urls import include, path


urlpatterns = [
    path("admin/", admin.site.urls),
    path("login/", include("login.urls")),
]
```

Maintenant on peux aller sur :

[http://127.0.0.1:5000/login/](http://127.0.0.1:5000/login/){target="_blank"}

On a un hello world de notre premiere appli.

## Un peu de base de données

Django est fourni avec une base de données (par default SQLlite).
Si besoin vous pouvez modifer les variables dans /nomduprojet/settings.py pour en changer (par exemple mettre MariaDB ou Postgres)
On verras plus tard lors d'une containerisation.
