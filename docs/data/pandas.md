# Pandas

Quand on parle de la bibliothèque [pandas](https://pandas.pydata.org/){target="_blank"} on parle surtout de son objet le Dataframe. 
Pour décrire cet objet, prenons une table de base de données. Elle a des colonnes et des valeurs.
Imaginer maintenant mettre cette table en RAM, et pouvoir la manipuler avec python. 
Vous associez la simplicité de python, et la rapidité de la RAM. Voilà votre dataframe.
Si vous êtes sur excel, vous pouvez automatiser certaines actions comme le nettoyage de données ou la création de graphiques.
Mais aussi dépasser le million de lignes. 

## Installation par pip

```shell
pip install pandas
```

Vous permet d'installer pandas avec pip. Il ne reste plus qu'à faire un import.    

```python
import pandas as pd
```

Vous permet d'utiliser le namecode 'pd' au lieu de pandas, raccourci souvent utilisé par les data scientist.

## Conseil et Source de donnée

Si vous vous intéressez à pandas, vous allez très certainement déborder sur numpy, matplotlib, seaborn, ... . Je vous 
conseille la distribution [anaconda](https://www.anaconda.com/download){target="_blank"}. 
Elle contient ipython, les bibliothèques/modules principaux en data, 
mais aussi jupyterlab qui permet de faire des notebooks, et pleins d'autres outils (spider, conda). 

Au niveau des sources de données, je vous conseille des plateformes open-data comme par exemple :

- [data-gouv](https://www.data.gouv.fr/fr/){target="_blank"} : données publiques du gouvernement français
- [INSEE](https://www.insee.fr/fr/information/2410988){target="_blank"} : données de l'INSEE, notamment IRIS pour les fonds de carte

## Importation des données

### Données sur fichier

Vous avez les données dans un fichier. Facile la commande

```python
pd.read_something
```

Exemple :

```python
data = pd.read_csv("mon_fichier.csv")
```

Vous permet de lire votre fichier csv et de le mettre dans un dataframe. Plus d'info dans la 
[documentation](https://pandas.pydata.org/docs/reference/api/pandas.read_csv.html){target="_blank"} de pandas

### Donnée sur BDD

Si vos données sont sur une base de données, il existe des connecteurs.

#### Base de données SQL

Vous pouvez utiliser directement des bases de données SQL avec les commandes incluses dans pandas.
Plus d'info ici : 
[https://pandas.pydata.org/pandas-docs/stable/user_guide/io.html#io-sql](https://pandas.pydata.org/pandas-docs/stable/user_guide/io.html#io-sql){target="_blank"}

Certains préfèrent utiliser la bibliothèque sqlalchemy que vous trouverez là :
[https://www.sqlalchemy.org/](https://www.sqlalchemy.org/){target="_blank"}

#### Base de données no SQL

Les bases de données no-SQL proposent souvent des connecteurs. Par exemple mongoDB propose pymongo.
Vous pouvez voir un exemple d'utilisation ici :
[https://github.com/barrmath/mongo_db_py/blob/main/mongodb_test.ipynb](https://github.com/barrmath/mongo_db_py/blob/main/mongodb_test.ipynb){target="_blank"}

## Commande de base

Que peut-on faire avec un dataframe ? Dans la suite de cette page, je considère que vous avez un dataframe qui s'appelle data

### head/tail

Les méthodes head et tail vous permettent de voir le début et la fin d'un dataframe.

```python
data.head()
```

Affiche les 5 premières lignes du dataframe.

```python
data.tail(10)
```

Affiche les 10 dernières lignes.

### Ajout de colonne

Avant de faire cela, il faut apprendre à sélectionner les colonnes. Il existe plusieurs méthodes :

```python
data["colonne"]# sélectionne la colonne par son nom entre []
data.colonne # sélectionne la colonne par son nom après le .
data[5:10 , 2:5] # affiche les ligne 6 à 10 des colonnes 3 à 5. 
['colonnne1','colonne2']] # sélection multiple
```

Besoin de rajouter une colonne pour faire un calcul ?

```python
data[new]=data.colonne1+data['colonne2']
```

### Filtre

Vous ne voulez que les enfants de moins de trois ans : data[data['age']&lt;3] . 
Décortiquons un peu le fonctionnement:

```python
data['age'] # va vous sélectionner la colonne age
data['age']&lt;3 # envoie une série de true false
data[data['age']&lt;3] # vous renvoie un dataframe qui ne contient que les enfants de moins de 3 ans
```

Vous pouvez continuer à compléter ce dataframe par exemple en ne voulant que les noms, prénoms, classes des enfants de moins de 3 ans.

```python
data[data['age']&lt;3][['nom','prenom','classe']]
```

Pour une introduction à pandas, c'est pas mal. Plus de fonction dans la documentation (loc, iloc pour le tri).

Un dernier tip pour la route, pourchanger le type des colonnes, regarder la méthode 
[astype](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.astype.html){target="_blank"}

## Sauvegarder votre Dataframe

La méthode data.to_csv("fichier.csv") permet de sauvegarder votre dataframe en format csv. Vous pouvez trouver d'autres méthodes dans la doc de pandas.

## Premier graphique

Juste pour information, vous pouvez utiliser pandas pour dessiner des graphiques avec la méthode plot.
Je vous mets le lien vers la documentation de plot : 
[https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.plot.html](https://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.plot.html){target="_blank}

## Conclusion

Il s'agit juste d'une introduction. Vous pouvez trouver des utilisations de pandas dans mon
[github](https://github.com/barrmath){target="_blank"}.
Faites vos propres graphiques, essayer de chercher ce que vous pouvez faire avec les données ouvertes. C'est la meilleure façon d'apprendre. 

## Ressources

[Pandas](https://pandas.pydata.org/){target="_blank"}

[Anaconda](https://www.anaconda.com/download){target="_blank}

[Data-Gouc](https://www.data.gouv.fr/fr/){target="_blank"}

[INSEE](https://www.insee.fr/fr/information/2410988){target="_blank"}

[https://www.sqlalchemy.org/](https://www.sqlalchemy.org/){target="_blank"}

[https://github.com/barrmath](https://github.com/barrmath){target="_blank"}

