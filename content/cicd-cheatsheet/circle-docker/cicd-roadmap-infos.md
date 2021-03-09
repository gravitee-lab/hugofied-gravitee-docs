---
title: "CICD Roadmap Infos"
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "Circle CI and Docker"
menu: circle_docker
menu_index: 2
product: "CICD Roadmap"
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: circle-docker
---

Here I keep all infos taht I collected to implement the rest of the roadmap on CICD global work "Migrate From Jenkins to Circle CI"


# Gravitee Release RoadMap

## Gravitee APIM Release

### Maven and git Release (with release.json)

Secrethub and config.yml setup new Secrets creation and update all config.yml

### Package bundle https://download.gravitee.io

APIM v3 for Community Edition (Publish to Bintray in Jenkins) :

* Secrethub and config.yml setup new Secrets creation and update all config.yml
* Basic Web UI customization, (Gravitee Logo)
* migration of existing files,
* and DNS configuration

APIM v3 for Entreprise Edition :

Ci dessous , cela fait le job uniquement pour APIM :

* package bundle (zip) pour la version Entreprise Edition V3 :
  * c'est des instructions Docker
  * toutes les instructions docker sont dans : https://ci2.gravitee.io/view/Gravitee.io%20EE/job/Build%20V3%20full-ee.zip/configure
  * à noter : dans le docker volume `-v "/opt/dist/dist.gravitee.io/graviteeio-ee/apim/distributions:/opt/dist"` sont générés les fichiers qui doivent être installés dans https://download.gravitee.io, dans le répertoire `graviteeio-ee/apim/distributions`.

* package bundle (zip) pour la version Entreprise Edition V1 :
  * c'est des instructions Docker
  * toutes les instructions docker sont dans : https://ci2.gravitee.io/view/Gravitee.io%20EE/job/Build%20V1%20full-ee.zip/configure
  * à noter : dans le docker volume `-v "/opt/dist/dist.gravitee.io/graviteeio-ee/apim/distributions:/opt/dist"` sont générés les fichiers qui doivent être installés dans https://download.gravitee.io, dans le répertoire `graviteeio-ee/apim/distributions`.


### Publish to Public Sonatype for Community Edition (“Nexus Staging”)

* Secrethub and `config.yml` setup : new Secrets creation and update all `.circleci/config.yml`

### Changelog Generation

* Génération du ChangeLog :
  * https://ci2.gravitee.io/view/Release/job/Docker%20graviteeio-changelog/configure
  * https://ci2.gravitee.io/job/Generate%20Changelog/configure exécute un script groovy qui fait un docker run de l'image construite avec https://ci2.gravitee.io/view/Release/job/Docker%20graviteeio-changelog/configure
  * dans Circle CI , celui s'exécutera dans le `config.yml` du repo de release, comme le nexus staging.


### Publish to Public Sonatype for Entreprise Edition (Nexus Staging) : should be merged in same job than Community Edition

Do not publish to NExus Sonatype for Entreprise Edition

### Docker images : Build and push Entreprise & Community Edition

#### Community Edition

* One Workflow, 4 Jobs, all same pipeline parameters
  * APIM v3 Gateway :
    * https://ci2.gravitee.io/view/Docker/job/APIM%20-%20V3%20-%20Docker%20API%20Gateway/configure
    * https://ci2.gravitee.io/view/Platform%20v3/job/APIM%20-%20V3%20-%20Docker%20API%20Gateway/configure
  * APIM v3 Management API:
    * https://ci2.gravitee.io/view/Docker/job/APIM%20-%20V3%20-%20Docker%20Management%20API/configure
    * https://ci2.gravitee.io/view/Platform%20v3/job/APIM%20-%20V3%20-%20Docker%20Management%20API/configure
  * APIM v3 Management UI:
    * https://ci2.gravitee.io/view/Docker/job/APIM%20-%20V3%20-%20Docker%20Management%20UI/configure
    * https://ci2.gravitee.io/view/Platform%20v3/job/APIM%20-%20V3%20-%20Docker%20Management%20UI/configure
  * APIM v3 Portal UI :
    * https://ci2.gravitee.io/view/Docker/job/APIM%20-%20V3%20-%20Docker%20Portal%20UI/configure
    * https://ci2.gravitee.io/view/Platform%20v3/job/APIM%20-%20V3%20-%20Docker%20Portal%20UI/configure

* One Workflow, 3 Jobs, all same pipeline parameters
  * APIM v1 gateway : https://ci2.gravitee.io/view/Docker/job/Docker%20graviteeio-gateway/configure
  * APIM v1 Management API : https://ci2.gravitee.io/view/Docker/job/Docker%20graviteeio-management-api/configure
  * APIM v1 Management UI : https://ci2.gravitee.io/view/Docker/job/Docker%20graviteeio-management-ui/configure


Indication pourles paramètres de pipeline pour la release des iamges Dockers V3 :
* si on lui dit que c'est une release `3.0.15`  :
  * il fera un tag (et le push) `latest`, si un param `boolean` de est à `true` (et à true par défaut)
  * il fera un tag (et le push)  `3`, si et ssi ...
  * il fera un tag (et le push) `3.0`, si et ssi ...
  * et il fera toujours un tag `3.0.15`  (et le push)
  * à retrouver dans la définition du pipeline jenkins

#### Entreprise Edition

Exact Same as community, but Docker images are here : https://github.com/gravitee-io/gravitee-docker/tree/master/enterprise


### Docker nightly images : hrs release; mais ...

2 APIM v3 nightly, pour
* tester les builds docker à la fois dans chaque repo, et dans le https://github.com/gravitee-io/gravitee-docker
* et à partir du release.json, pour en gros savoir de quelle version de gravitee "c'est la nightly".


* APIM v 3 nightly, les 4 images des 4 composants sont faites en un seul job Jenkins :
  * dans le repo `release.json`
  * par git clone des 4 repos git, dernière version sur `master`, et lancement du build sur les 4 repos
  * https://ci2.gravitee.io/view/Docker/job/APIM%20-%20v3%20-%20Docker%20nightly/configure

* APIM v 3 nightly "gravitee-docker", mais cette fois les 4 images des 4 composants sont faites en un seul job Jenkins :
  * dans le repo `release.json`
  * les 4 par git clone du même repo git `git@github.com:gravitee-io/gravitee-docker.git`, dernière version sur `master`, et lancement du build n push Docker
  * https://ci2.gravitee.io/view/Docker/job/APIM%20-%20v3%20-%20Docker%20nightly/configure



### RPMs : Generate and publish

Deux workflow Circle CI, et des pipeline parameters, ainsi qu'un token secret pour le publish des RPM vers le service digital ocean

* APIM v3 : https://ci2.gravitee.io/view/Packages/job/RPM%20for%20Gravitee.io%20APIM%203.x/configure
* APIM v1 : https://ci2.gravitee.io/view/Packages/job/RPM%20for%20Gravitee.io%20APIM%201.x/configure


### Build n Deploy the https://docs.gravitee.io with every APIM Release (update _config.yml + a git commit on master => deploys)

* Release et déploiement du https://docs.gravitee.io vers clever cloud :
  * https://www.clever-cloud.com/doc/deploy/application/docker/docker/
  * https://console.clever-cloud.com/organisations/orga_ba284152-8da9-4e8f-b32f-21d86100cac1/applications/app_5f58775b-2ac9-4b33-8ad4-7fcfcb16a02d
  * https://app-5f58775b-2ac9-4b33-8ad4-7fcfcb16a02d.cleverapps.io/
  * ok à priori, la seule chose qu'il faut faire pour déclencher le déploiement, c'est de faire un commit sur `master`, et ça déploie directement. See https://console.clever-cloud.com/organisations/orga_ba284152-8da9-4e8f-b32f-21d86100cac1/applications/app_5f58775b-2ac9-4b33-8ad4-7fcfcb16a02d/information
  * ok j'ai trouvé ce qu'il faut faire :
    * dans https://github.com/gravitee-io/gravitee-docs/blob/master/_config.yml
    * changer la valeur de `products.apim._3x.version` https://github.com/gravitee-io/gravitee-docs/blob/master/_config.yml#L122
    * puis faire le git commit and push sur master, avec un git tag en incrémentant le numéro de version, mode semver.






## Gravitee AM Release


### Maven and git Release (with release.json)

Since it is a mono-repo :
* The release will be done without artifactory, like it is done on JEnkins, with the `gravitee-release` profile, So the publish to nexus will be done by the release process
* all I will need is the settings.xml used to perform Gravitee AM Release
* I will have to configure the GPG to sign artifacts


### Package bundle (Publish to Bintray in Jenkins) https://download.gravitee.io

For Community edition and Entreprise Edition, will reproduce what is done for APIM :
* I did not find any job that does this

### Publish to Public Sonatype for Community Edition (“Nexus Staging”)

Since it is a mono-repo :
* The release will be done without artifactory, like it is done on JEnkins, with the `gravitee-release` profile, So the publish to nexus will be done by the release process
* all I will need is the settings.xml used to perform Gravitee AM Release
* I will have to configure the GPG to sign artifacts


### Changelog Generation

I did not find any ChangeLog specific to Gravitee AM, and the Jenkins Job has parameters to run a Changelog either for APIM, or AM

* Génération du ChangeLog :
  * https://ci2.gravitee.io/view/Release/job/Docker%20graviteeio-changelog/configure
  * https://ci2.gravitee.io/job/Generate%20Changelog/configure exécute un script groovy qui fait un docker run de l'image construite avec https://ci2.gravitee.io/view/Release/job/Docker%20graviteeio-changelog/configure
  * dans Circle CI , celui s'exécutera dans le `config.yml` du repo de release, comme le nexus staging.


### Publish to Public Sonatype for Entreprise Edition (Nexus Staging) : should be merged in same job than Community Edition

We do not publish to public Sonatype for Entreprise Version ?

Entreprise Edition is based on :
* Community Edition
* and special plugins


### Docker images : Build and push Entreprise & Community Edition

#### Community Edition

* One Workflow, building and pushing all Gravitee AM components, with pipeline parameters
  * https://ci2.gravitee.io/view/Release/job/Docker%20Gravitee.io%20AM%20-%20Release/configure
  * no option about docker tags : always the version and that's it.

But we could add those parameters about tagging :

Indication pourles paramètres de pipeline pour la release des iamges Dockers V3 :
* si on lui dit que c'est une release `3.0.15`  :
* il fera un tag (et le push) `latest`, si un param `boolean` de est à `true` (et à true par défaut)
* il fera un tag (et le push)  `3`, si et ssi ...
* il fera un tag (et le push) `3.0`, si et ssi ...
* et il fera toujours un tag `3.0.15`  (et le push)
* à retrouver dans la définition du pipeline jenkins

#### Entreprise  Edition

* Dockerfiles are here : https://github.com/gravitee-io/gravitee-docker/tree/master/enterprise/am

* Docker images Entreprise Edition, 3 Jobs sont utilisés (uniquement des images Docker, la spécificité vient des plugins ajoutés et c'est tout) :
  * https://ci2.gravitee.io/job/Docker%20EE%20AM%20V3%20-%20Access%20Gateway/ (EE Gateway)
  * https://ci2.gravitee.io/job/Docker%20EE%20AM%20V3%20-%20Management%20UI/ (EE UI)
  * https://ci2.gravitee.io/job/Docker%20EE%20AM%20V3%20Management%20API/ (EE API)


### RPMs : Generate and publish

Deux workflow Circle CI, et des pipeline parameters, ainsi qu'un token secret pour le publish des RPM vers le service digital ocean

* AM v2 : https://ci2.gravitee.io/view/Packages/job/RPM%20for%20Gravitee.io%20AM%202.x/configure
* AM v3 : https://ci2.gravitee.io/view/Packages/job/RPM%20for%20Gravitee.io%20AM%203.x/configure

### Build n Deploy the https://docs.gravitee.io with every APIM Release (update _config.yml + a git commit on master => deploys)

Un seul `Circle CI` Workflow ou Job, pour faire :
* un git commit poussé sur la branche `master` de https://github.com/gravitee-io/gravitee-docs
* le git tag de release dans https://github.com/gravitee-io/gravitee-docs (incrémenter le dernier git tag de release)


* Release et déploiement du https://docs.gravitee.io vers clever cloud :
  * https://www.clever-cloud.com/doc/deploy/application/docker/docker/
  * https://console.clever-cloud.com/organisations/orga_ba284152-8da9-4e8f-b32f-21d86100cac1/applications/app_5f58775b-2ac9-4b33-8ad4-7fcfcb16a02d
  * https://app-5f58775b-2ac9-4b33-8ad4-7fcfcb16a02d.cleverapps.io/
  * ok à priori, la seule chose qu'il faut faire pour déclencher le déploiement, c'est de faire un commit sur `master`, et ça déploie directement. See https://console.clever-cloud.com/organisations/orga_ba284152-8da9-4e8f-b32f-21d86100cac1/applications/app_5f58775b-2ac9-4b33-8ad4-7fcfcb16a02d/information
  * ok j'ai trouvé ce qu'il faut faire :
    * dans https://github.com/gravitee-io/gravitee-docs/blob/master/_config.yml
    * changer la valeur de `products.apim._3x.version` https://github.com/gravitee-io/gravitee-docs/blob/master/_config.yml#L122
    * puis faire le git commit and push sur master, avec un git tag en incrémentant le numéro de version, mode semver.



### Infos Gravitee AM (source : Titouan)

#### Package Bundle

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


#### Entreprise Edition Release


* Pour faire la Release Entreprise Edition, 3 Jobs sont utilisés (uniquement des images Docker, la spécificité vient des plugins ajoutés et c'est tout) :
  * https://ci2.gravitee.io/job/Docker%20EE%20AM%20V3%20-%20Access%20Gateway/ (EE Gateway)
  * https://ci2.gravitee.io/job/Docker%20EE%20AM%20V3%20-%20Management%20UI/ (EE UI)
  * https://ci2.gravitee.io/job/Docker%20EE%20AM%20V3%20Management%20API/ (EE API)





### RPM for AE

https://ci2.gravitee.io/view/Packages/job/RPM%20for%20Gravitee.io%20AE/configure



# The Gravitee container Library

TODO : create a dedicated menu to document :
* What is the Gravitee Container Library
* How to build the container images of the container library
* list all images, and describe what they are used for

[graviteeio/java]
[graviteeio/changelog]
[graviteeio/fpm]
[graviteeio/httpd]
[graviteeio/python]
