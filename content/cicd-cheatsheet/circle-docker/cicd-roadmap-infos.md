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

I did not find any ChangeLog specific to Gravitee AM, So maybe same as APIM

* Génération du ChangeLog :
  * https://ci2.gravitee.io/view/Release/job/Docker%20graviteeio-changelog/configure
  * https://ci2.gravitee.io/job/Generate%20Changelog/configure exécute un script groovy qui fait un docker run de l'image construite avec https://ci2.gravitee.io/view/Release/job/Docker%20graviteeio-changelog/configure
  * dans Circle CI , celui s'exécutera dans le `config.yml` du repo de release, comme le nexus staging.


### Publish to Public Sonatype for Entreprise Edition (Nexus Staging) : should be merged in same job than Community Edition

We do not publish to public Sonatype for Entreprise Version ?


### Docker images : Build and push Entreprise & Community Edition

* One Workflow, building and pushing all Gravitee AM components, with pipeline parameters
  * https://ci2.gravitee.io/view/Release/job/Docker%20Gravitee.io%20AM%20-%20Release/configure
  * no option about docker tags : always the version and that's it.

But we could add those paramters about tagging :

Indication pourles paramètres de pipeline pour la release des iamges Dockers V3 :
* si on lui dit que c'est une release `3.0.15`  :
  * il fera un tag (et le push) `latest`, si un param `boolean` de est à `true` (et à true par défaut)
  * il fera un tag (et le push)  `3`, si et ssi ...
  * il fera un tag (et le push) `3.0`, si et ssi ...
  * et il fera toujours un tag `3.0.15`  (et le push)
  * à retrouver dans la définition du pipeline jenkins

Entrerprise Edtion :
* Exact Same as community,
* but Docker images are here : https://github.com/gravitee-io/gravitee-docker/tree/master/enterprise/am


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











### RPM for AE

https://ci2.gravitee.io/view/Packages/job/RPM%20for%20Gravitee.io%20AE/configure

# The Roadmap (Workload Assessments I commited on)


## Gravitee APIM : What is done

* `Maven and git Release` (with release.json)
* `Package bundle` for Community Edition (Publish to Bintray in Jenkins) https://download.gravitee.io
* `Publish to Public Sonatype` for Community Edition (“Nexus Staging”)
* just need tests on gravtiee-io : and enough to support main part of gravtiee release 3.7

#### How to run this

* `Maven and git Release` : edit the release.json, and one curl command, provide git branch name of release repo (on which release.json was edited)
* `Package bundle` : One curl command , provide Release version number
* `Publish to Public Sonatype` : One curl command , provide Release version number
* `Package bundle and  Publish to Public Sonatype` : can run in parallel, after Maven and git Release completed

## Gravitee APIM: What is left to do (8 days)

* `[1 day]` Secrethub and config.yml setup new Secrets creation and update all config.yml for every listed task below (we will need to buy secrethub plan)
* `[2 days]` Changelog Generation
* `[1 day]` Package bundle for Entreprise Edition (https://ci2.gravitee.io/view/Gravitee.io%20EE/  in Jenkins) https://download.gravitee.io should be merged in same job than Community Edition
* `[1 day]` Publish to Public Sonatype for Entreprise Edition (Nexus Staging) : do we publish ee artefacts to nexus ?
* `[1 day]` https://download.gravitee.io Basic Web UI customization , migration of existing files, and DNS configuration
* `[1 day]` Docker images : Build and push Entreprise & Community Edition
* `[0.5 day]` RPMs : Generate and publish
* `[0.5 day]` Build n Deploy the https://docs.gravitee.io with every APIM Release (update _config.yml + a git commit on master => deploys)

## Gravitee AM : TODO list (8 days)

* `[5 days]` Maven and git Release monorepo => no release.json => will use only Docker executors (like Cockpit), will not use artifactory, will do exact same thing as done in Jenkins : will use  gravitee-release maven profile, prepare release, will perform nexus staging, then  git release, all in one Job
* `[? days]` Package bundle for Community Edition (Publish to Bintray in Jenkins) https://download.gravitee.io https://ci2.gravitee.io/job/Publish_to_Bintray/configure does it for APIM, have to do python for AM ? I do not know if there exists a jenkins job to do it.
* `[? days]` Package bundle for Entreprise Edition  https://ci2.gravitee.io/view/Gravitee.io%20EE/job/Build%20V1%20full-ee.zip/configure does it for APIM v1, I do not know if there exists a jenkins job to do it.
* `[0 days]` Publish to Public Sonatype for Community Edition (“Nexus Staging”) done in Maven and git Release
* `[?]` Changelog Generation : same workflow as as APIM ? Is there a ChangeLog for AM ?
* `[1 day]` Publish to Public Sonatype for Entreprise Edition (Nexus Staging) : do we publish ee artefacts to nexus ?
* `[1 day]` Docker images : Build and push Entreprise & Community Edition
* `[0.5 day]` RPMs : Generate and publish
* `[0.5 day]` Build n Deploy the https://docs.gravitee.io exact same as APIM Release (update _config.yml + a git commit on master => deploys)

## Gravitee AE : same as Gravitee Cockpit ? (5 days)

* `[3 days]` Maven and git Release monorepo => no release.json => will use only Docker executors (like Cockpit), will not use artifactory, will do exact same thing as done in Jenkins : will use  gravitee-release maven profile, prepare release, will perform nexus staging, then  git release, all in one Job
* Package bundle (Publish to Bintray in Jenkins) https://download.gravitee.io
* `[0 days]` Publish to Public Sonatype for Community Edition (“Nexus Staging”) done in Maven and git Release
* `[?]` Changelog Generation : same workflow as as APIM ? Is there a ChangeLog for AM ?
* Publish to Public Sonatype for Entreprise Edition (Nexus Staging) : should be merged in same job than Community Edition
* `[1 day]` Docker images : Build and push Entreprise
* `[0.5 day]` RPMs : Generate and publish
* `[0.5 day]` Build n Deploy the https://docs.gravitee.io exact same as APIM / AM Release (update _config.yml + a git commit on master => deploys)

## Entreprise Edition Release Optimization (2 to 4 days)

[2 to 4 days] Optimized Maven and git Release With monorepo => A first Circle CI experiment with the nightly release gave a 25 minutes long Pipeline. The goal here is to re-implement the release process, but with Docker Executor instead of Machine Executor. A bit of complexity for example due to GPG signature.
Will be done right after we tested APIM release 1.25.x with Nicolas, see https://graviteeio.slack.com/archives/C018EUYFKRB/p1613554046034900
