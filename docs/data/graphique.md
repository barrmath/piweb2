# Graphique

Les graphiques sous python peuvent être effectuées par plusieurs bibliothèques :
[matplotlib](https://matplotlib.org){target="_blank"}
, [seaborn](https://seaborn.pydata.org"){target="_blank"}
, [Bokhet](https://bokeh.org/){target="_blank"}.
Je vous présente rapidement les 2 premières.

## Matplotlib

Matplotlib permet de faire des graphiques en python.Il y a deux méthode pour utiliser matplotlib :

- la méthode script
- la méthode Objet

Les 2 méthodes sont bonnes, mais choisissez-en une. Les incompréhensions sont souvent dues à un mélange des méthodes.

### La méthode script

Exemple :

```python
import matplotlib.pyplot as plt

plt.plot([1, 2, 3, 4])
plt.ylabel('some numbers')
plt.show()
```

On va faire un script qui va construire le graphe. On reconnaît cette méthode avec l'utilisation quasi-exclusive des fonctions incluses dans matplotlib.
C'est une méthode efficace et assez facile à prendre en main.

### La méthode objet

Exemple :

```python
import matplotlib.pyplot as plt
fig,ax =plt.subplots()
ax.plot([1, 2, 3, 4])
ax.set_ylabel('some numbers')
plt.show()
```

On crée les objets fig et ax qui vont permettre de faire le graphe.
On applique ensuite les méthodes de l'objet ax ou fig pour construire le graphe.
L'objet fig est la figure (la fenêtre pour vulgariser) qui va contenir le graphe. ax est l'objet graphe (axe).
Personnellement, je préfère la méthode objet. Mais vous pouvez faire les mêmes choses en script.

## Seaborn

Seaborn est une amélioration de matplotlib. Vous trouverez souvent un argument ax pour intégrer un axe matplotlib.

Voyons voir ça avec divers exemples :

```python
import seaborn as sns
# config graphe
sns.set_theme(style="whitegrid")
sns.set_context("notebook", font_scale=1.5, rc={"lines.linewidth": 2.5})
sns.set_palette("pastel")
palette = sns.color_palette("pastel").as_hex()
```

Un peu comme le css avec html, seaborn peut modifier le style de vos graphiques matplotlib.
Au-dessus, on sélectionne un style whitegrid (fond blanc avec des lignes) et une palette de couleurs pastel.

Cela va changer les couleurs de tous les graphiques matplotlib et seaborn construit en dessous de ces lignes.

Exemple de graqhe :

```python
fig,ax=plt.subplots()
fig.set_size_inches(10,10)
sns.barplot(data=data_amelie[data_amelie['annee']==2018],x='cla_age_5',y="pourcentage acte selon la classe d'age",ax=ax,estimator='mean')
ax.set_title('pourcentage de la population en cours de traitements par classe d\'age en 2018')
ax.set_xlabel('Classe d\'age')
ax.tick_params(axis='x', labelrotation=90)
plt.show()
```

On construit donc un objet matplotlib, on l'injecte dans les fonctions seaborn et on peut ensuite utiliser les méthodes de matplotlib pour changer le graphe.

Pourquoi utiliser seaborn alors ? Regardez bien la fonction , l'autre avantage de seaborn est qu'il est compatible avec pandas.
Vous pouvez donc envoyer une vue filtrée (ou non) de votre dataframe directement dans la fonction seaborn avec l'argument data,
 les arguments x et y correspondent par exemple à 2 colonnes de votre dataframe.

## Conclusion

Ces deux bibliothèques vous permettent de faire des graphiques en python.
Si vous voulez des graphiques, plus interactifs, il y a bokeh.
Pour faire des tableaux de bord, orientez-vous vers des logiciels plus spécialisés comme :

- [PowerBI](https://www.microsoft.com/fr-fr/power-platform/products/power-bi){target="_blank"}
- [Tableau](https://tableau.com/){target="_blank"}
- [Grafana](https://grafana.com/){target="_blank"} (qui fait du monitoring à la base, mais il est possible d'en faire un logiciel de datavisualisation)

## Ressources

[Matplotlib](https://matplotlib.org){target="_blank"}

[Seaborn](https://seaborn.pydata.org){target="_blank"}

[Bohket](https://bokeh.org/){target="_blank"}

[PowerBi](https://www.microsoft.com/fr-fr/power-platform/products/power-bi){target="_blank"}

[Tableau](https://tableau.com/){target="_blank"}

[Grafana](https://grafana.com/){target="_blank"}
