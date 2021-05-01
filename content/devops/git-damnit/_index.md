

* métrique : TDM / par seconde ?

# Scenario


une équipe de 3 dev


* On déteste ce type d'hsitorique: (il montre un slide où on a un historique git peu lisible) : on arrive pas à s'y retrouver
* TDD : se forcer à bine écrire le message de commit permet de se concentrer sur la feature (bonne pratique)
* outil pour générer le changelog


### but garder un historique de commit propre

* "t'as oublié tel truc dans ton dernier commit"
* modif + git add + git commit --amend :

```bash

# modif contenu + commit message
git commit --amend --no-edit

# modif contenu seulement
git commit --amend --no-edit

# -->> si je susi sur "ma branche", donc no probleme

```

amend ça marche que sur "le dernier commit"

Et si le commit est avant le dernier ? ==>> `git commit --fixup A`

```bash
git commit --fixup A
# et après un rebase pour réécrire l'historique: le fixup va juse créer un commit supplémentaire à la suite
git rebase -i A~ --autosquash

# A~ => pour déisgner le commit parent du commit A
```



## supprimer le dernier commit

git add : ça ajoute un fichier modifié, du working directory, dans l'index
git commit : ça fait bouger le pointeur HEAD wvers le point de l'index où se trouve mon fchier modifier



Ok donc `git reset` :

```bash

# --soft => fait bouger uniquement HEAD vers le commit précédent, le INDEX et le WORKIGN DIRECTORY ne BOUgENT PAS
git reset HEAD~ --soft
git reset HEAD~ --mixed
git reset HEAD~ --hard

```

git fetch : ça ne modifie localement que les branches "remote", donc si je fais :

```bash
git reset --hard origin/feature/masuperfeature

# ce que ça fait : ma branche locale [feature/masuperfeature] est remise dans l'état de la branche distante [origin/feature/masuperfeature]
```

### Un cas complexe

* git rebase --interactive : permet même de réordonenr les les commits !!

```bash
git diff ${GIT_COMMIT_HASH1}..${GIT_COMMIT_HASH2}
```

```bash
# ça c'est pour faire un git add de pas toutes les modofi d'un fichier, seulement certaines parties d'un fichier
git add -p chemin/vers/fichier
```

* Ah astuce sympa
```bash
# je reviens à un commit pour voir comment le code était
git checkout ${GIT_COMMIT_HASH1}
# je reviens au point où j'étais jsute avant le checkout
git checkout -

# --
# au cas où il y ait un nom de ficheir qui corrspond à un fichier
# Ci-dessous c'est le fichier master qui est checkouté, pas la branche master
git checkout -- master

```


### tous les détails sur https://mghignet.github.io/git-dammit-talk/  => à forker

Pour réparer cette présentation, il dit qu'il a passé beaucoup de temps
