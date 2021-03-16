---
title: "Dopcker Images Release"
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "CI/CD Processes"
menu: am_processes
menu_index: 13
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: am-processes
---

## Process Description

TODO

## Legacy Jenkins

#### Entreprise Edition

* Gravitee AM V3 :
  * https://ci2.gravitee.io/job/Docker%20EE%20AM%20V3%20Management%20API/ : Docker Gravitee AM V3 management API
  * https://ci2.gravitee.io/job/Docker%20EE%20AM%20V3%20-%20Management%20UI/ : Docker Gravitee AM V3 management UI
  * https://ci2.gravitee.io/job/Docker%20EE%20AM%20V3%20-%20Access%20Gateway/ : Docker Gravitee AM V3 Gateway
* Gravitee AM V2 :
  * https://ci2.gravitee.io/job/Docker%20EE%20AM%20Management%20API/ : Docker Gravitee AM V2 management API
  * https://ci2.gravitee.io/job/Docker%20EE%20AM%20-%20Management%20UI/
  * https://ci2.gravitee.io/job/Docker%20EE%20AM%20-%20Access%20Gateway/


## How to: Perfom a Docker Images Release

### Dry run tests

* Launching Gravitee AM version `3.5.3` with `gio_product = am_v3` ( tested ok with [this pipeline execution](https://app.circleci.com/pipelines/github/gravitee-io/gravitee-docker/84/workflows/c0274387-d96a-42d0-aca0-8c38df3775bd) ) :

```bash
# It should be SECRETHUB_ORG=graviteeio, but Cirlce CI token is related to
# a Circle CI User, not an Org, so just reusing the same than for Gravtiee-Lab here, to work faster
# ---
SECRETHUB_ORG=gravitee-lab
SECRETHUB_REPO=cicd
# Nevertheless, I today think :
# Each team member should have his own personal secrethub repo in the [graviteeio] secrethub org.
# like this :
# a [graviteeio/${TEAM_MEMBER_NAME}] secrethub repo for each team member
# and the Circle CI Personal Access token stored with [graviteeio/${TEAM_MEMBER_NAME}/circleci/token]
# ---
export HUMAN_NAME=jblasselle
export CCI_TOKEN=$(secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/humans/${HUMAN_NAME}/circleci/token")
# You, will just use your own Circle CI Token
# export CCI_TOKEN=<your user circle ci token>

export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-docker"
export BRANCH="master"
export BRANCH="feature/cicd-circle-image-builds"
export GIO_RELEASE_VERSION="3.5.3"
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


* Launching Gravitee AM version `3.5.3` with `gio_product = am_v2` (should build zero images, because of the error tested ok with [this pipeline execution](https://app.circleci.com/pipelines/github/gravitee-io/gravitee-docker/89/workflows/b03bf1ba-5c92-423c-8b99-1efdc8e35d20) ):

```bash
# It should be SECRETHUB_ORG=graviteeio, but Cirlce CI token is related to
# a Circle CI User, not an Org, so just reusing the same than for Gravtiee-Lab here, to work faster
# ---
SECRETHUB_ORG=gravitee-lab
SECRETHUB_REPO=cicd
# Nevertheless, I today think :
# Each team member should have his own personal secrethub repo in the [graviteeio] secrethub org.
# like this :
# a [graviteeio/${TEAM_MEMBER_NAME}] secrethub repo for each team member
# and the Circle CI Personal Access token stored with [graviteeio/${TEAM_MEMBER_NAME}/circleci/token]
# ---
export HUMAN_NAME=jblasselle
export CCI_TOKEN=$(secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/humans/${HUMAN_NAME}/circleci/token")
# You, will just use your own Circle CI Token
# export CCI_TOKEN=<your user circle ci token>

export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-docker"
export BRANCH="master"
export BRANCH="feature/cicd-circle-image-builds"
export GIO_RELEASE_VERSION="3.5.3"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"dry_run\": true,
        \"gio_product\": \"am_v2\",
        \"graviteeio_version\": \"${GIO_RELEASE_VERSION}\"
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```


* Launching Gravitee AM version `2.0.1` with `gio_product = am_v2` ( tested ok with [this pipeline execution](https://app.circleci.com/pipelines/github/gravitee-io/gravitee-docker/87/workflows/04b9bfc8-376d-4e76-99d4-b2618fd71953) ):

```bash
# It should be SECRETHUB_ORG=graviteeio, but Cirlce CI token is related to
# a Circle CI User, not an Org, so just reusing the same than for Gravtiee-Lab here, to work faster
# ---
SECRETHUB_ORG=gravitee-lab
SECRETHUB_REPO=cicd
# Nevertheless, I today think :
# Each team member should have his own personal secrethub repo in the [graviteeio] secrethub org.
# like this :
# a [graviteeio/${TEAM_MEMBER_NAME}] secrethub repo for each team member
# and the Circle CI Personal Access token stored with [graviteeio/${TEAM_MEMBER_NAME}/circleci/token]
# ---
export HUMAN_NAME=jblasselle
export CCI_TOKEN=$(secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/humans/${HUMAN_NAME}/circleci/token")
# You, will just use your own Circle CI Token
# export CCI_TOKEN=<your user circle ci token>

export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-docker"
export BRANCH="master"
export BRANCH="feature/cicd-circle-image-builds"
export GIO_RELEASE_VERSION="2.0.1"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"dry_run\": true,
        \"gio_product\": \"am_v2\",
        \"graviteeio_version\": \"${GIO_RELEASE_VERSION}\"
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```


* Launching Gravitee AM version `2.0.1` with `gio_product = am_v3` ( should be aborted becasue `2.0.1` is not a `v3`, tested ok with [this pipeline execution](https://app.circleci.com/pipelines/github/gravitee-io/gravitee-docker/91/workflows/b8051f14-d312-44a3-8f43-424fb23563a1) ):

```bash
# It should be SECRETHUB_ORG=graviteeio, but Cirlce CI token is related to
# a Circle CI User, not an Org, so just reusing the same than for Gravtiee-Lab here, to work faster
# ---
SECRETHUB_ORG=gravitee-lab
SECRETHUB_REPO=cicd
# Nevertheless, I today think :
# Each team member should have his own personal secrethub repo in the [graviteeio] secrethub org.
# like this :
# a [graviteeio/${TEAM_MEMBER_NAME}] secrethub repo for each team member
# and the Circle CI Personal Access token stored with [graviteeio/${TEAM_MEMBER_NAME}/circleci/token]
# ---
export HUMAN_NAME=jblasselle
export CCI_TOKEN=$(secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/humans/${HUMAN_NAME}/circleci/token")
# You, will just use your own Circle CI Token
# export CCI_TOKEN=<your user circle ci token>

export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-docker"
export BRANCH="master"
export BRANCH="feature/cicd-circle-image-builds"
export GIO_RELEASE_VERSION="2.0.1"
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

<!--   PIPELINE OPTIONAL PARAMETERS :
== DRY_RUN: << pipeline.parameters.dry_run >>
== TAG_LATEST: << pipeline.parameters.tag_latest >>
== GRAVITEEIO_VERSION: << pipeline.parameters.graviteeio_version >>
-->
