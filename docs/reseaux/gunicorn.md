# Gunicorn

## Pourquoi utiliser Gunicorn

Lorsque vous lancez Flask avec python, il vous informe qu'il s'agit d'un serveur de test.

```shell
* Serving Flask app 'web_app'
* Debug mode: on
WARNING: This is a development server. Do not use it in a production deployment. Use a production WSGI server instead.
* Running on all addresses (0.0.0.0)
* Running on http://127.0.0.1:5000
* Running on http://192.168.1.42:5000
Press CTRL+C to quit
* Restarting with stat
* Debugger is active!
* Debugger PIN: 415-401-457
```

Il faut un WSGI (Web Server Gateway Interface) qui va communiquer avec votre application python (Flask django ou autres).
Il est souvent utilisé avec un proxy http ([nginx](https://www.nginx.org){target="_blank"}, ou 
[apache httpd](https://httpd.apache.org/docs/2.4/fr/programs/httpd.html){target="_blank"}).

![gunicorn](gunicorn/nginx_gunicorn.png#only-light)
![gunicorn](gunicorn/nginx_gunicorn_dark.png#only-dark)

Ainsi, vous pouvez utiliser Gunicorn comme un serveur de production.

## Installation


Vous pouvez passer par votre gestionnaire de paquets sur Linux, ou bien par pip. Pour nos ami(e)s sous windows,
vous pouvez utiliser pip install [waitress.](https://github.com/Pylons/waitress){target="_blank"} 

```shell
pip install gunicorn
```

## Configuration et démarrage


Pour lancer gunicorn, il suffit de taper la commande gunicorn avec votre app. 
Pour la configuration de l'app : nom_du_fichier:Nom_app ou nom_du_fichier:Appelle_fonction_creatrice() si vous êtes en app_factory.

```shell
gunicorn web_app:app
```

Vous pouvez aussi utiliser l'option -w pour indiquer le nombre de workers. (souvent nombre de thread dispo +1). 
Vous pouvez définir vos workers avec -k WORKERCLASS aussi pour par exemple avoir des fonctions asynchrones.

```shell
gunicorn web_app:app -w 5
```

Vous pouvez aussi définir un port avec -b 0.0.0.0:5000 .

```shell
gunicorn web_app:app -b 0.0.0.0:5000
```

Pour moi le plus simple reste le fichier de configuration en .py pour gunicorn.
Par exemple le fichier conf.py :

```shell
bind = '0.0.0.0:5000'
workers = 5
wsgi_app = 'run:create_app()'
```

On peux lancer gunicorn avec la commande :

```shell
gunicorn --config conf.py
```

## Conclusion

Vous pouvez maintenant avoir un wsgi en production, une étape de plus avant la mise en ligne.
Il ne reste plus qu'à configurer nginx et faire les certificats pour le https.

## Ressources

[nginx](https://www.nginx.org){target="_blank"}

[apache httpd](https://httpd.apache.org/docs/2.4/fr/programs/httpd.html){target="_blank"}

[Gunicorn](https://gunicorn.org//){target="_blank"}

[Waitress.](https://github.com/Pylons/waitress){target="_blank"}
