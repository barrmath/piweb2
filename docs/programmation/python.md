# Python

## Introduction

[Python](https://www.python.org/){target="_blank} est un langage de programmation interprété.
Ainsi, il est indépendant de la machine tant que vous pouvez installer python sur celle-ci. Par contre, vous devez installer python.
Il peut servir pour faire de la data science, du web, des scripts pour les administrateurs, ... Bref, il est assez polyvalent.
En tant que langage interprété, (et non compilé), il a des performances en retrait par rapport à du C par exemple.
Il a comme avantage d'être simple, et relativement intuitif.
Pour faire un script python, crée un fichier texte avec votre éditeur favori (extension .pi en général). Pour lancer le script :

```shell
python nom_du_script.pi
```

On va voir les objets de base de python, les fonctions simples de python, puis la gestion des bibliothèques et des environnements python.

## Objets de base

### Les Variables

Les variables servent à stocker des valeurs dans la mémoire vive. On les déclare simplement avec un nom de variable, un signe égal,
puis la valeur. Exemple :

```python
phrase = "Hello world python"
version = 3
print(phrase,version)
print("Le type de phrase est" ,type(phrase))
print ("le type de version est" ,type(version))
version = float(version)
print("le nouveau type de version est ", type(version))
```

En testant ce script vous pouvez observer que vous pouvez changer de type de variable en cours de programme.
Les différents type en python sont :

- Bool : un 0 ou 1, vrais faux
- int : nombre entier
- float : nombre flottant à virgule
- str : string ou chaîne de caractère

### Les Listes, les tuples

#### Les Listes

Une liste est une liste de variables ou d'autres objets.
On la déclare entre [].
On peut y placer des nombres, des chaînes de caractères , ... Et même des listes, qui contiennent des listes, qui contiennent des listes, qui contiennent ...
Je préfère la pratique donc script d'exemple :

```python
# Creation de la liste
ma_liste = [1,2,3,4,"Leeloo",6]
print("la liste complete : ",ma_liste)
print("le premier element est  ", ma_liste[0])
print("Le cinquième élément est ",ma_liste[4])
print("la liste contient", len(ma_liste), "éléments")

#ajout suppression
ma_liste.append(7)
print("la liste complete : ",ma_liste)
print("la liste contient maintenant", len(ma_liste),"éléments")
ma_liste.remove(7)
print("la liste contient maintenant", len(ma_liste),"éléments")
print("la liste complete : ",ma_liste)
ma_liste.pop(4)
```

Les listes contiennent des méthodes pour rajouter des éléments, ou en enlever.
Il existe plein de fonctions sur les listes que vous pouvait trouver la [doc](https://docs.python.org/fr/3/tutorial/datastructures.html){target="_blank"}.

Pour information : les chaînes de caractères sont une liste un peu spéciale.

#### Les Tuples

Les tuples se déclarent entre ().

Les tuples se comportent comme des listes. Sauf que l'on ne peut pas les modifier. Elles sont dites immuables.
Par contre elles sont plus légères en mémoire, et plus rapides.

À vous de choisir entre la vitesse et l'adaptabilité.

### Les dictionnaires

Les dictionnaires se déclarent entre {}.

Il faut les voir comme un annuaire ou un index selon moi. Exemple :

```python
# Creation du dico
mes_choix = {"tux":"un manchot","d":"la reponse d","le sens de la vie":42,"sarah connor":"oui c'est moi"}
print (mes_choix)
print(mes_choix["tux"])    
```

Vous pouvez essayer avec d'autres clés.("tux" est une clé ici comme "d" ou "sarah connor").
Vous avez une clé, en entrant la clé, le dictionnaire vous donne une valeur.
Vous trouverez les dictionnaires pour faires des conditions multiples (le switch étant arrivé avec python 3.10). Mais il peut être utile pour par exemple traduire des couleurs. Exemple :

```python
couleurs={'blue' : '#0000FF' , 'red' : '#FF0000' , 'green' : '#0000FF', "taupe" : "it an animal not a fucking color"}
```

La doc des dicos est [ici.](https://docs.python.org/3/tutorial/datastructures.html#dictionaries){target="_blank"}

## Conditions, Boucles, Fonctions

Le scripts commence en haut et finit en bas. Mais quelquefois, il est intéressant de changer les instructions ou de les répéter. On utilise pour cela les conditions, les boucles et les fonctions.
Il faut bien comprendre que python fonctionne grâce à l'indexation du code.

### Conditions

#### if elif else

Let's script :

```python
# Creation du choix
ailes=True
miaou=False
if ailes:
      print("c'est un pingouin ou un oiseau")
elif miaou:
      print("c'est un chat")
else:
      print("c'est un chien")
```

On peut changer l'état des ailes, du miaou. En fonction, on va sélectionner la commande que l'on veut.
On peut aussi mettre plusieurs elif en cas de besoin.
Remarquer que le code est indexé, les espaces avant les print permettent à python de savoir que la commande est dans le if.

#### switch case

Une autre façon de faire des choix, le match ou switch case.

```python
# Creation du choix
bruit="gnouf"
match bruit:
  case "ouaf":
        print("c'est un chien")
  case "miaou":
        print("c'est un chat")
  case "cuicui":
        print("c'est un oiseau")
  case _:
      print("c'est un pingouin")    
```

En fonction de la valeur de bruit, on va répondre ce qu'il y a dans les cases. Si aucune case ne correspond, on utilise la case _

### Boucles

On doit répéter plusieurs choses les boucles sont là.

#### for

C'est la boucle d'itération, par exemple sur une liste :

```python
# Creation de la boucle avec liste
liste_ami = ["Pierre","Fatima","Ling","Ahmed","San","Julie"]
for ami in liste_ami:
      print("J'invite mon ami",ami,"à mon anniversaire.")
```

On met le premier élément de la liste dans ami, on fait les actions, puis le deuxième ...

#### while

Souvent traduit par les professeurs par "tant que".
Boucle de ma mère:
Tant que tu n'as pas fini tes devoirs, tu n'allumes pas la console.
bref lets script:

```python
# Creation de la boucle
nb_boucle = 0
animal ="skbdkgbdk" # j'aurait pus mettre un caratere vide mais pas envie
while animal !="manchot":
      nb_boucle += 1 #on incremente le nombre de boucle
      print("boucle numero :",nb_boucle)
      animal = input("Quel est la race de Tux? :") On pose la question
      if nb_boucle > 10: # si on depasse
              print("revise Linux")
              break #on casse la boucle
      if animal=="pingouin": # si c'est pingouin
              print("Bon presque mais tu as droit à un malus")
              nb_boucle +=1
              continue # on redemarre la boucle
      print("pas de malus")
print("nombre de reponse donnée :",nb_boucle)
```

Félicitation, vous avez fait votre premier jeu vidéo textuel. Vous pouvez être fier.
Alors le jeu fonctionne ainsi, vous avez 10 essais, il y a une réponse malus.
Le mot break vous fait sortir de la boucle.
Le mot continue vous fait recommencer la boucle au début.

### Fonctions

Vous êtes en train de coder, et vous remarquez que vous écriver la même chose dans le code.
Par exemple : Vous faite le meme calcul plusieurs fois.

```python
# Creation de la fonction
def calcul(a,b,c) :
        i=(a+b)*c
        print ("Le resultat est :",i)
        return i


e=5
d=6
f=7
calcul(e,d,f)
e=1
d=1
f=1
i=calcul(e,d,f)
print("la variable i est :",i)
```

Le mot def permet de définir une fonction (calcul) avec des arguments (e,d,f). Il est préférable de mettre une [docstring](https://pandas.pydata.org/docs/development/contributing_docstring.html){target="_blank"}.
Le commande return permets de retourner une valeur dans le programme.
Le scripts exécute la fonction lors de l'appel.
Une fonction peut ne pas avoir d'arguments, ni de valeurs à retourner.

Pour information, les objets complexes comme les listes, les dataframes vont être modifier par la fonctions, alors que les variables simples comme un nombre ne le seront pas.
Python étant programmé en C, il envoie une copie pour les objets simples, mais il envoie un pointeur avec des objets complexes.

#### Recursivité

Bon, la fonction puissance existe déjà mais on va la recréer avec ce qu'on appelle la récursivité. Lets script:

```python
# Creation de la fonction puissance
def calcul_puissance(chiffre,puissance) :
  # calcul une puissance en mode recursif (que les puissance entiere positive)
  if puissance == 1:
    return chiffre #si puissance =0 on quitte la fonction en retournant le resultat
  else:
    return chiffre*calcul_puissance(chiffre,puissance-1)


chiffre,puissance  = 3,3
print("resultat :", calcul_puissance(chiffre,puissance))
```

La fonction s'appelle elle-même. Cela permet de faire une sorte de boucle.
Quelquefois, c'est plus intuitif comme méthode que des boucles.
Par contre les défauts : consommation mémoire en hausse et python limite le nombre de récursivité possible, pour éviter les récursivités infinies
Plus d'information [ici.](https://rollbar.com/blog/python-recursionerror/#){target="_blank"}

## Environnement, Pip et bibliothèques/modules

Python existe depuis quelques années. Des millions voir des milliards de lignes de codes ont été écrites pour diverses raisons. Il y a de fortes chances pour que la fonction que vous voulez existe déjà quelque part.
Heureusement, il existe un site qui permet de chercher des paquets python : [pypi.org](https://pypi.org/){target="_blank"}.
Dites le à un enfant de 5 à 10 ans, ça va lui faire sa journée.
Python va tourner dans un environnement où il aura des paquets installés ou non.
Il faut faire la différence entre l'environnement local et les environnements virtuels.

### Environnement local

Divers programmes utilisent python, y compris des programmes importants sous Linux.
      Certaines distributions utilisent le gestionnaire par défaut pip,
      mais de plus en plus de distributions se servent de leurs propres gestionnaires de paquets pour plus de stabilité.
Éssayer d'installer un module avec pip :

```shell
pip install yolo                                                                           ✔ 
error: externally-managed-environment

× This environment is externally managed
╰─> To install Python packages system-wide, try 'pacman -S
  python-xyz', where xyz is the package you are trying to
  install.
  
  If you wish to install a non-Arch-packaged Python package,
  create a virtual environment using 'python -m venv path/to/venv'.
  Then use path/to/venv/bin/python and path/to/venv/bin/pip.
  
  If you wish to install a non-Arch packaged Python application,
  it may be easiest to use 'pipx install xyz', which will manage a
  virtual environment for you. Make sure you have python-pipx
  installed via pacman.

note: If you believe this is a mistake, please contact your Python installation or OS distribution provider. You can override this, at the risk of breaking your Python installation or OS, by passing --break-system-packages.
hint: See PEP 668 for the detailed specification.  
```

Voici le message d'erreur lorsque vous essayez d'installer un paquet sur l'environnement local. Il vous demande sois de passer par le gestionnaire de paquets (pacman apt dnf) ou de créer un environnement virtuel.
Vous pouvez installer les bibliothèques/modules que vous utilisez souvent en local. Par exemple installer django si vous êtes developpeur web.
Mais il est plus que conseillé d'utiliser les environnements virtuels pour éviter des conflits avec les programmes systèmes.

### Environnement virtuel

Pour créer un environnement virtuel, c'est relativement facile. Aller dans un dossier où vous débuter un nouveau projet python et taper :

```shell
python -m venv venv
```

Pour activer l'environnement virtuel, taper :

```shell
source venv/bin/activate
```

Maintenant, vous pouvez utiliser pip pour installer vos modules.

### Pip

Les commandes principales de pip:

- pip install Nom_du_paquet : installe le paquet
- pip uninstal Nom_du_paquet : désinstalle le paquet
- pip freeze : liste les paquets installés
- pip freeze > requirements.txt : crée un fichier requirements.txt avec la liste de tous les paquets installés
- pip install -r requirements.txt  : installe les paquets listés dans requirements.txt

Donc, avec ces simples commandes, vous pouvez débuter un projet, mettre le fichier requirements.txt dans un repo git. Un utilisateur pourra installer et tester votre programme grâce à la création d'environnement virtuels et à pip.

### Mise à jour pip

Pour mettre à jour pip, il suffit de taper

```shell
pip install pip --upgrade pip
```

Pour mettre à jour tous les paquets de pip :

```shell
pip freeze --local | awk -F "=" '{print "pip install -U "$1}' | sh
```

Tester votre projet et mettez à jour requirements.txt

```shell
pip freeze > requirements.txt
```

### Utiliser les modules

Vous avez installé plein de modules, comment on les importe ? Tout simplement avec la commande imports. Par exemple :

```python
import pandas
```

Ensuite, vous pouvez utiliser la bibliothèque pandas dans votre code (si vous l'avez installé avec pip avant bien entendu).
Par exemple pour créer un dataframe

```python
>dataframe = pandas.DataFrame()
```

Écrire pandas est trop long ? Importer la bibliothèque comme ça :

```python
import pandas as pd
```

Maintenant, vous pouvez écrire :

```python
pd.DataFrame()
```

Vous n'avez besoin que de la fonction DataFrame ? Pas de soucis, écrivez ceci :

```python
from pandas import DataFrame
```

Création du Dataframe :

```python
dataframe = DataFrame()
```

!!! waning
      Une fausse bonne idée : from pandas import *
      Vous importez tout pandas sans le namespace. Du coup, vous n'avez plus besoin de taper pandas.fonction ou pd.fonction.
      MAIS imaginer que vous importer une autre bibliothèque et que cette bibliothèque à un nom de fonction identique à celle de pandas.
      Pour en avoir fait l'expérience, bon courage pour tout déboguer.

### Modules perso

Créer un dossier, créer dans celui-ci un fichier `__init__.py` et un fichier `mesfonctions.py`.
Et importer le avec :

```python
import Nom_du_dossierpy
```

comme un modules.

## Conclusion

Avec ceci, vous avez juste les bases de python. De quoi vous débrouiller.
Allez voir les bibliothèques et regarder la doc. Tester les différentes fonctions. Bref, éclatez-vous.

## Ressources

[Python](https://www.python.org/){target="_blank"}

[Limite de recursivité](https://rollbar.com/blog/python-recursionerror/#){target="_blank"}
