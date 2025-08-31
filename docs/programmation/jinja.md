# Jinja2

Flask est fourni par défaut avec [Jinja2](https://flask.palletsprojects.com/en/3.0.x/templating/){target="_blank"} comme moteur de template.
Vous pouvez utiliser un autre moteur si vous voulez : par exemple [Angular](https://github.com/klebervirgilio/ng-spa-on-flask){target="_blank"}.

Le but de Flask et de jinja est de permettre de faciliter le travail du développeur. Jinja2 vous permet de générer du code html à partir de certains objets.
Exemple : faire une page de base qui se répète dans tout le site (les menus, la disposition de la page ...)

## Réutiliser du code html

Alors Jinja2 possède des balises un peu comme html :

- Les balises &#123;&#123; truc &#125;&#125; : permettent d'accéder à un objet
- Les balises &#123;% machin %&#125; : permettent de lancer des fonctions

Dans la page [Flask](flask.md){target="_blank"}, on a déjà vu comment répliquer le code d'une page HTML.
Pour rappel :
Exemple de fichier de base :

```jinja
<!DOCTYPE html>
<html lang="fr">
    <head>
    <meta charset="utf-8">
    {% block content %}{% endblock %}
    </head>
</html>
```

Fichier qui utilise la base :

```jinja
{% extends 'base.html' %}

{%block content %}

contenu de la page

{% endblock %}
```

Vous aurez besoin d'utiliser des objets dans les templates. Voyons voir comment faire.

## Les objets dans jinja2

### Les variables

Vous connaissez les variables en python ? Oui, cela tombe bien Jinja2 utilise plus ou moins les mêmes.
Déclaration de variables :

```jinja
{% set testing = 'it worked' %}
{% set another = testing %}
```

Vous pouvez envoyer des variables à partir du routage avec la commande render_template().

```python
render_template("web/jinja.html",menu=menu)
```

### Les listes et autres objets standards python

Des petites variables, c'est sympa, mais vous pouvez aussi envoyer des dictionnaires, des listes et des tuples avec la commande render_tempplate().
Même des [dataframes](https://datacorner.fr/jinja-amis-des-pandas/{target="_blank"} peuvent être utilisé par Jinja2.
Les methodes des objets fonctionnnent globalement de la même manière sur jinja2. Pensez juste aux accolades.

!!! warning
    Attention les interactions sous jinja influence votre code python

Vous pourriez avoir des surprises avec les méthodes pop par exemple qui supprime des objets des listes.

### Les conditions

Vous pouvez vouloir afficher ou non un objet en fonction d'une variable. (souvent utiliser pour les logins pour afficher le bouton se connecter ou se déconnecter par exemple).
Il suffit tout simplement d'utiliser la commande if :

```jinja
{% if truc == "machin" %}
    Il y a machin dans truc
{% elif truc == "bidule" %}
    Le truc c est un bidule en fait
{% else %}
    Le truc est un chimilibilil blick 
{% endif %}
```

### Les boucles for

Vous envoyez des listes ou des tuples dans Jinja2, c'est bien pour les utiliser. En python, on va utiliser la boucle for dans ce cas-là. En jinja2 aussi.

```jinja
{% for row in rows %}
    {{ row }}
{% endfor %}
```

Vous pouvez aussi mettre une condition directement dans la boucle par exemple si les utilisateurs veulent être cachés :

```jinja
{% for user in users if not user.hidden %}
    {{ user.username }}
{% endfor %}
```

Pour plus d'informations la [Doc officielle de jinja2.](https://jinja.palletsprojects.com/en/2.10.x/templates/#list-of-control-structures){target="_blank"}

## Ressources

[Doc officielle de jinja2.](https://jinja.palletsprojects.com/en/2.10.x/templates/#list-of-control-structures){target="_blank"}
