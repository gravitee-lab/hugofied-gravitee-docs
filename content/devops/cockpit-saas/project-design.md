---
title: "Project Main Lines"
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "Devops"
menu: cockpit_saas
menu_index: 6
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: cockpit-saas
---

## In a couple of sentences

The Cockpit SAAS is a production environment.

Here I detail the main topics and Milestones to go prod for the first time.

## First draft

partie déploiement, cockpit.gravitee.io ne sera pas un environnement de démo mais de prod

Ok, alors pour une prod il ya des étapes :
* **0. ETAPE0 (infra as code, 5 à 10 Jour Homme, JB seul)** : toute l'infra  http://cockpit.gravitee.io/ doit être gérée en infra as code. J'ai préparé le terrain avec Pulumi. Concrètement, cela veut dire qu'il y aura un repo privé  https://github.com/gravitee-io/cockpit-saas . Ce repo comportera 4 branches : dev, integration, staging, prod. sur chacune de ces branches, on aura un "Pulumi stakck" du même nom versionné avec `Pulumi.dev.yaml` , `Pulumi.integration.yaml` , `Pulumi.staging.yaml` , `Pulumi.prod.yaml` . Sur chacune de ces branches git :
  * chaque _Pulumi stack_ correspond à un  cluster Kubernetes différent,
  * chacun de ces cluster permet de faire des tests de l'infra.
  * Pull requests de dev => intégration => staging => prod.
  * Tests automatisés obligatoires, venant progressivement pour faire monter la fiabilité.
  * à chaque fois qu'une pull request est acceptée, l'infra cible est patchée. Ce sera l'outil central pour résoudre les incidents, et réaliser les Cockpits upgrades. les Clusters dev intégrations et ne tournent que de manière éphémère, pour les tests, avec des petits. Le cluster staging tourne au moins 2 jours par semaine de manière garantie, pour que l'équipe Acceptance (david, équipe Cockpit), valident les changements qui vont être propagés de staging vers prod.
  * Ici le git workflow sera spécifique aux devops :
    * on ne pourra pas utiliser les workflows utilisés en dev gravitee.
    * À priori, je vais utiliser  le git flow avec 4 configurations, une pour chaque branche (`dev`, `integration`, `staging` , et `master` )
* **1. ETAPE1 (monitoring - 5 à 10 Jour Homme, JB seul)** :  ce sera une prod, donc il faut prévoir un monitoring : obligatoire. ETAPE 1 : au pulumi JB ajoute un premier stack de monitoring classique sans chercher à trop réfléchir, juste ce que font les autres, aucune specs. Typiquement un Prometheus et du grafana, du Elastic FileBeats. 2 niveaux de monitoring : monitoring du cluster lmui même, monitoring du soft gravitee lui-même
* **2. ETAPE2 (gestion des incidents, 10 Jour Homme, JB et un des 4 fantastique pour valider les process, sur 5 jours)**  :  le monitoring seul, ça ne sert à rien, il faut prévoir des procédures de gestion des incident : qui est "de garde" (astreintes), pour gérer les incidents (la gestion incidents ne sera jamais 100% automatisée, des humains parleront aux clients, à un moment donné), escalade des tickets incidents support niveau 1, 2, 3 (niveau 3 JB prend lecode pulumi pour modifer quelque chose et faire un patch complexe de prod). Cette partie, c'est du pur process, on ne considère rien de technique, on dit comment ça DOIT, se gérer. ITIL est un modèle idéal à avoir entête : on essaie d'avoir du process compatible ITIL.
* **3. ETAPE2 (gestion des incidents, partie 2, 5 à 10 Jour Homme, JB seul)**  : JB  prend le schéma global des process de gestion incidents, et il automatise le maximum d'étapes avec des produits production-grade, gratuits open source. Typiquement, automatisation des notifications, intégration bot slack, envoi automatique d'email à un client / utilisateur pour lui dire que son ticket a bien été pris en compte / et un nouvel email à chaque fois que son ticket change de statut, etc.. etc.... On invente zéro, au plus on fait de la customisation de template d'emails, on reprend tout ce qui existe de meilleur sur le marché, qui a fait ses preuves. Exemple : discourse. JB va aussi modifier le monitoring pour qu'il collecte les métriques nécessaires pour la gestion d'incidents (analyse, alertes d'incidents pour prévéneir les cliets utilisateurs AVANT qu'ils no'uvrent un ticket etc...)
* **ETAPE 3 - DRP (JB seul, 5 à 10 jours)** :  hyper important, il DOIT y avaoir unr prodcédure de backup /restore valide, testée obligatoirement avec toute pull request de integration vers staging
* et là on fait le point :
  * est-ce qu'on se considère prêt pour le go prod ?
  * Possibilité , avant le go prod, on peut mettre à dispo l'environnement `staging`, avec un gros bandeau "CECI EST LA VERSION ALPHA DE COCKPIT AUCUN SUPPORT N'EST ASSURE, C4EST POUR VOUS FAIRE PLAISIR QUE VOUS VOYEZ CE QUI VA BIENTÔT ETRE DISPO"



_**Remarque: Sur la gestion des incidents**_

* on peut démarrer avec quelque chose de très simple, voire extêment simple : cela rendrait les étapes ci-dessu plus courtes.
* mais il faut qu'on en passe par les étapes ci-dessus, pour que cela soit une décission consciente: les process doivent être écrits explicitement, même si très simples, et schématisés clairement. En plus c'est JB qui se tapera de faire les beaux schemas avec draw.io qu'il n'y aura qu'à valider :slightly_smiling_face:
* Prendre des risques n'est pas un problème. Ce qui est un problème, c'est de prendre des risques sans même les avoirs mesurés avant.
