---
title: "Gravitee AE CI/CD Processes"
date: 2020-12-16T00:44:23+01:00
draft: false
menu_index: 7
showChildrenInMenu : true
nav_menu: "CI/CD Processes"
type: ae-processes
---


J'ai mis le classique commun à tous les projets, et il manque dans artifactory, dans `gravitee-snapshots`,  la gravitee-license, surement qu'elle manquaera aussi pour la release (dry run ou pas) :

https://app.circleci.com/pipelines/github/gravitee-io/gravitee-alert-engine/116/workflows/8169c3b5-2634-49f8-a36b-74408ca3d4aa/jobs/177

bref, là c'est du multi-repo, et il faudrait du replay pour booter le tout, ou alors comme cockpit on fait une standalone release et on utilise le bump
