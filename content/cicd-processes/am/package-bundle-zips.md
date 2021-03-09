---
title: "Package and Publish Zips bundles to https://download.gravitee.io "
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "CI/CD Processes"
menu: am_processes
menu_index: 10
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: am-processes
---

## Process Description

TODO

## How to run

TODO: automation is not there yet.


## About the future automation


* **Package Bundle** Les Zip à envoyer sur https://download.gravitee.io : leur publication se fait manuellement :
  *  en y regardant, pour moi voici la llsite des fichiers concernés :
    * le fichier `graviteeio-am-full-${GRAVITEEAM_VERSION}.zip` dans https://download.gravitee.io/graviteeio-am/distributions/
    * dans https://download.gravitee.io/graviteeio-am/components/ 3 répertoires :
      * Un répertoire pour Gavitee AM Gateway, un seul zip `gravitee-am-gateway-standalone-${GRAVITEEAM_VERSION}.zip` : https://download.gravitee.io/graviteeio-am/components/gravitee-am-gateway/
      * Un répertoire pour Gavitee AM Management API, un seul zip `gravitee-am-management-api-standalone-${GRAVITEEAM_VERSION}.zip` : https://download.gravitee.io/graviteeio-am/components/gravitee-am-management-api/
      * Un répertoire pour Gavitee AM Management UI, , un seul zip `gravitee-am-webui-${GRAVITEEAM_VERSION}.zip` : https://download.gravitee.io/graviteeio-am/components/gravitee-am-webui/
    * un seul plugin dans https://download.gravitee.io/graviteeio-am/plugins/repositories/gravitee-repository-mongodb/gravitee-am-repository-mongodb-3.3.1-SNAPSHOT.zip :
      * dans un répertoire plugins, de type repository,  https://download.gravitee.io/graviteeio-am/plugins/repositories/gravitee-repository-mongodb/gravitee-am-repository-mongodb-${GRAVITEEAM_VERSION}.zip

Résumé de l'arbre :

```bash

https://download.gravitee.io
          |
          |_____ graviteeio-am
          |           |
          |           |
          |           |____ distributions
          |           |           |
          |           |           |___ graviteeio-am-full-${GRAVITEEAM_VERSION}.zip
          |           |           |
          |           |
          |           |
          |           |
          |           |____ components
          |           |         |
          |           |         |___ gravitee-am-gateway
          |           |         |         |
          |           |         |         |_____ gravitee-am-gateway-standalone-${GRAVITEEAM_VERSION}.zip
          |           |         |         |
          |           |         |
          |           |         |___ gravitee-am-management-api
          |           |         |         |
          |           |         |         |_____ gravitee-am-management-api-standalone-${GRAVITEEAM_VERSION}.zip
          |           |         |         |
          |           |         |
          |           |         |
          |           |         |___ gravitee-am-webui
          |           |         |         |
          |           |         |         |_____ gravitee-am-webui-${GRAVITEEAM_VERSION}.zip
          |           |         |         |
          |           |         |
          |           |         |
          |           |         |
          |           |
          |           |
          |           |____ plugins
          |           |        |
          |           |        |_____ repositories
          |           |        |           |
          |           |        |           |_____ gravitee-repository-mongodb
          |           |        |           |                 |
          |           |        |           |                 |____ gravitee-am-repository-mongodb-${PLUGIN_VERSION}.zip (could also be a SNAPSHOT)
          |           |        |           |                 |
          |           |        |           |
          |           |        |
          |           |        |
```

Donc pour automatisder le tout, il me suffit :
* d'écrire un python identitque à celui d'APIM, mais simplifié :
  * unqiuement les `components` et le `distributions`
  * et pour les plugins, unqiueent un seul plugin : gravitee-am-repository-mongodb-${PLUGIN_VERSION}.zip
  * reste une seule chose à créer : un release.json AM, qui permettra de déclarer la dépendance entre uyne version de Gravitee AM, et la versiond e chaque plugin.
* Une fois le script python fait, et le release.json, alors derrière, il me suffit de re-faire le package bundle :
  * pour les 3 components (aucune différence entre AM v1 et AM v3, impecc)
  * pour le gros zip full "distributions"
  * et derrière mon `Consolidator` NodeJS peut -être réutilisé à l'identique pour placer les plugins :
    * il suffit que le répertoire racine destination soit gravitee-am au lieu de graivtee-apim
    * donc il me suffit d'ajouter une variable d'environnement pour configurer le nom de ce répertoire racine, sera géré par conf pour AM ou APIM

Ok donc pricipal du travail :
* script python,
* `release.json` AM (et d'ailleurs il y a aussi pour moi de la version de WS connectors qui va là dedans, non ?)
