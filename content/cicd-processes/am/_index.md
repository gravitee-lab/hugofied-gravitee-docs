---
title: "Gravitee AM CI/CD Processes"
date: 2020-12-16T00:44:23+01:00
draft: false
menu_index: 7
showChildrenInMenu : true
nav_menu: "CI/CD Processes"
type: am-processes
---

In this page, you will find a full step by step procedure for APIM Release
see also https://github.com/gravitee-io/kb/wiki/CICD:-All-About-Gravitee-AM


## Process Description

Here are the steps :
* 0. [A kind of (magic) Release](#0-a-kind-of-magic-release)
* 1. [The Maven and Git release](#1-maven-and-git-release)
* can be run in parallel :
  * 2. [Package n publish zip bundles](#2-package-bundle)
  * 3. [nexus-staging](3-nexus-staging)
* can be run in parallel :
  * 4. [changelog](#4-changelog)
  * 5. [Docker images CE and EE](#5-docker-images)
  * 6. [Publish `rpm` packages](#6-rpm-packages)
  * 7. [continuous delivery of https://docs.gravitee.io](#7-publish-documentation)

#### Before you start : your need your Circle CI API Token

To execute every step of the release process, you will need something from circle CI : a Personal API Token.

Here is how you can get one :
* log into Circle CI at https://app.circleci.com with github authentication. Grant access to `gravitee-io` Github Org.
* Go to your Use settings menu : bottom left corner icon
* Then go to the  _**"Personal API Tokens"**_ menu, and click the "Create new Token" button.
* Keep the value of your token, you will need it at each step.


## 0. A kind of (magic) Release

You will release a given version of AM.

Whatever the release version number is, you will be in one of the two following cases :
* If `C` is zero, then:
  * this release is a major release
  * and the source code which will be used to perform the release will will be the latest commit on the `master` git branch.
* If `C` is not zero, then:
  * this is a support release.
  * and the source code which will be used to perform the release will be the latest commit on the `A.B.x` git branch.

For example :
* if release version number is `7.8.4`, then this is a support release , and the source code to use will be the latest commit on the `7.8.x` git branch.
* if release version number is `11.5.0`, then this is a major release , and the source code to use will be the latest commit on the `master` git branch.

_**In all Below AM release steps, we note `M.N.P` the release version number of the AM release you need to perform.**_



## 1. Maven and git release

* To run the Maven and git release, with dry run mode on :

```bash
# export CCI_TOKEN=<You Circle CI User Personal Token>

export ORG_NAME="gravitee-io"
export REPO_NAME="graviteeio-access-management"
# For example, for the 3.6.1 APIM release, the git branch was 3.6.x
export BRANCH="3.6.x"
# if P is zero, than the git branch will be master
export BRANCH="master"
# if P is not zero, than the git branch will be M.N.x
export BRANCH="M.N.x"
export BRANCH="cicd/prepare-release"
# description: "The semver version number of the SAML2 identity provider plugin to bundle with GRavitee AM Entreprise Edition"
export ID_PROVIDER_SAML_VERSION="1.1.1"
export GRAVITEE_LICENSE_VERSION="1.1.0"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"release\",
        \"ee_id_provider_saml_version\": \"${ID_PROVIDER_SAML_VERSION}\",
        \"ee_gravitee_license_version\": \"${GRAVITEE_LICENSE_VERSION}\",
        \"dry_run\": true
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```


* To run the Maven and git release, with dry run mode off :

```bash
# export CCI_TOKEN=<You Circle CI User Personal Token>

export ORG_NAME="gravitee-io"
export REPO_NAME="graviteeio-access-management"
# For example, for the 3.6.1 APIM release, the git branch was 3.6.x
export BRANCH="3.6.x"
# if P is zero, than the git branch will be master
export BRANCH="master"
# if P is not zero, than the git branch will be M.N.x
export BRANCH="M.N.x"
export BRANCH="cicd/prepare-release"
# description: "The semver version number of the SAML2 identity provider plugin to bundle with GRavitee AM Entreprise Edition"
export ID_PROVIDER_SAML_VERSION="1.1.1"
export GRAVITEE_LICENSE_VERSION="1.1.0"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"release\",
        \"ee_id_provider_saml_version\": \"${ID_PROVIDER_SAML_VERSION}\",
        \"ee_gravitee_license_version\": \"${GRAVITEE_LICENSE_VERSION}\",
        \"dry_run\": false
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```





for more parameters to set versions of more EE Release addons, we could have :

* To run the Maven and git release, with dry run mode on :

```bash
# export CCI_TOKEN=<You Circle CI User Personal Token>

export ORG_NAME="gravitee-io"
export REPO_NAME="graviteeio-access-management"
# For example, for the 3.6.1 APIM release, the git branch was 3.6.x
export BRANCH="3.6.x"
# if P is zero, than the git branch will be master
export BRANCH="master"
# if P is not zero, than the git branch will be M.N.x
export BRANCH="M.N.x"
export BRANCH="cicd/prepare-release"
# description: "The semver version number of the CAS identity provider plugin to bundle with GRavitee AM Entreprise Edition"
export ID_PROVIDER_CAS_VERSION="1.0.0"
# description: "The semver version number of the Kerberos identity provider plugin to bundle with GRavitee AM Entreprise Edition"
export ID_PROVIDER_KERBEROS_VERSION="1.0.0"
# description: "The semver version number of the SAML2 identity provider plugin to bundle with GRavitee AM Entreprise Edition"
export ID_PROVIDER_SAML_VERSION="1.2.0"
export GRAVITEE_LICENSE_VERSION=""
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"release\",
        \"ee_id_provider_cas_version\": \"${ID_PROVIDER_CAS_VERSION}\",
        \"ee_id_provider_kerberos_version\": \"${ID_PROVIDER_KERBEROS_VERSION}\",
        \"ee_id_provider_saml_version\": \"${ID_PROVIDER_SAML_VERSION}\",
        \"ee_gravitee_license_version\": \"${GRAVITEE_LICENSE_VERSION}\",
        \"dry_run\": true
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```




* To run the orchestrated Maven and git release, with dry run mode off :

```bash
# export CCI_TOKEN=<You Circle CI User Personal Token>
export ORG_NAME="gravitee-io"
export REPO_NAME="graviteeio-access-management"
# For example, for the 3.6.1 APIM release, the git branch was 3.6.x
export BRANCH="3.6.x"
# if P is zero, than the git branch will be master
export BRANCH="master"
# if P is not zero, than the git branch will be M.N.x
export BRANCH="M.N.x"
export BRANCH="cicd/prepare-release"
# description: "The semver version number of the CAS identity provider plugin to bundle with GRavitee AM Entreprise Edition"
export ID_PROVIDER_CAS_VERSION="1.0.0"
# description: "The semver version number of the Kerberos identity provider plugin to bundle with GRavitee AM Entreprise Edition"
export ID_PROVIDER_KERBEROS_VERSION="1.0.0"
# description: "The semver version number of the SAML2 identity provider plugin to bundle with GRavitee AM Entreprise Edition"
export ID_PROVIDER_SAML_VERSION="1.2.0"

export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"release\",
        \"ee_id_provider_cas_version\": \"${ID_PROVIDER_CAS_VERSION}\",
        \"ee_id_provider_kerberos_version\": \"${ID_PROVIDER_KERBEROS_VERSION}\",
        \"ee_id_provider_saml_version\": \"${ID_PROVIDER_SAML_VERSION}\",
        \"dry_run\": false
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```

Once finished, maven, git release, nexus staging and package bundle are all done;

So what's left is :
* RPMs
* Docker images
* and Changelog


### How to: Perfom a Docker Images Release


For a `2.x` Gravitee AM, use `\"gio_product\": \"am_v2\",` instead of `\"gio_product\": \"am_v3\",`

#### Dryn run mode ON

* Launching `Gravitee AM` version `3.5.4` with `gio_product = am_v3` ( tested ok with [this pipeline execution](https://app.circleci.com/pipelines/github/gravitee-io/gravitee-docker/84/workflows/c0274387-d96a-42d0-aca0-8c38df3775bd) ) :

```bash
export CCI_TOKEN=<your user circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-docker"
export BRANCH="master"
export BRANCH="feature/cicd-circle-image-builds"
export GIO_RELEASE_VERSION="3.5.4"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"dry_run\": true,
        \"gio_product\": \"am_v3\",
        \"graviteeio_version\": \"${GIO_RELEASE_VERSION}\"
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```


* For a `Gravitee AM` Major Release version, for which docker images should be tagged latests, use the addtional `tag_latest` pipeline parameter (which defaults to `true`), example with `Gravitee AM` version `3.8.0` :

```bash
export CCI_TOKEN=<your user circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-docker"
export BRANCH="master"
export BRANCH="feature/cicd-circle-image-builds"
export GIO_RELEASE_VERSION="3.8.0"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"dry_run\": true,
        \"gio_product\": \"am_v3\",
        \"graviteeio_version\": \"${GIO_RELEASE_VERSION}\",
        \"tag_latest\": true
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```

<!--
tag_latest_support
-->


#### Dry run mode OFF (will push to Dockerhub)

* Launching Gravitee AM version `3.5.4` with `gio_product = am_v3` ( tested ok with [this pipeline execution](https://app.circleci.com/pipelines/github/gravitee-io/gravitee-docker/84/workflows/c0274387-d96a-42d0-aca0-8c38df3775bd) ) :

```bash
export CCI_TOKEN=<your user circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-docker"
export BRANCH="master"
export BRANCH="feature/cicd-circle-image-builds"
export GIO_RELEASE_VERSION="3.5.4"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"dry_run\": false,
        \"gio_product\": \"am_v3\",
        \"graviteeio_version\": \"${GIO_RELEASE_VERSION}\"
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```

### How to: Release RPMs

* example RPM Package release, for GRavitee AM Release `3.5.4`, see [this pipeline execution](cccc)  :

```bash
export CCI_TOKEN=<your Circle CI Token>

export GRAVITEE_RELEASE_VERSION="3.5.4"
#
export ORG_NAME="gravitee-io"
export REPO_NAME="graviteeio-access-management"
export BRANCH="3.5.x"
export BRANCH="cicd/prepare-release"
#
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"publish_rpms\",
        \"graviteeio_version\": \"${GRAVITEE_RELEASE_VERSION}\"
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```

### How to: Release the Changelog


* example for Release `3.5.4`, see [this pipeline execution](cccccc)  :

```bash
export CCI_TOKEN=<your Circle CI Token>
# https://github.com/gravitee-io/issues/milestones
export GIO_MILESTONE_VERSION="AM - 3.5.4"
export ORG_NAME="gravitee-io"
export REPO_NAME="issues"
export BRANCH="master"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"changelog_am\",
        \"gio_milestone_version\": \"${GIO_MILESTONE_VERSION}\",
        \"dry_run\": true
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```






### New CICD Migration Ops

Migrating to the new CICD requires 2 operations :
* Updating the `./.circleci/config.yml` with the reference [`config.yml`](./reference-config-yml/config.yml) (`content/cicd-processes/am/reference-config-yml/config.yml`)
* Updating the `pom.xml` gravitee parent version : it must use a version of the gravitee-parent, compatible with the new CICD, without breaking change

#### Where we are

Git Branches for Which the migration has been done :
* `master` : validated with the AM release `3.8.0` made with Circle CI
* `3.5.x` : validated with the AM release `3.5.4` made with Circle CI
* `3.7.x` : validated with the AM release `3.7.2` made with Circle CI
* `3.6.x` : validated with the AM release `3.6.4` made with Circle CI (yet `3.6.x` is today not supported anymore)
