---
title: "Publish RPM Packages"
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "CI/CD Processes"
menu: am_processes
menu_index: 14
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: am-processes
---

## Process Description

Builds the RPM Packges, and Publishes them to _Package Cloud_ (Digital Ocean Service), for both GRavitee AM v3 and bv2

## Legacy Jenkins

#### Entreprise Edition

* Gravitee AM V3 :
  * https://ci2.gravitee.io/job/RPM%20for%20Gravitee.io%20AM%203.x/configure
* Gravitee AM V2 :
  * https://ci2.gravitee.io/job/RPM%20for%20Gravitee.io%20AM%202.x/configure


## How to: Perfom a Docker Images Release


* Grab a Circle CI Personal API Token, from Circle CI Web UI, personally I stored it in secrethub :

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
```


* example RPM Package release, for GRavitee AM Release `2.0.1`, see [this pipeline execution](https://app.circleci.com/pipelines/github/gravitee-io/graviteeio-access-management/1217/workflows/70966491-2e96-4a25-b376-251e4eb667ce/jobs/1203)  :

```bash
# export CCI_TOKEN=<your Circle CI Token>

export GRAVITEE_RELEASE_VERSION="2.4.0"
#
export ORG_NAME="gravitee-lab"
export ORG_NAME="gravitee-io"
export REPO_NAME="gio-graviteeio-access-management"
export REPO_NAME="graviteeio-access-management"
export BRANCH="master"
export BRANCH="cicd/circleci-release"
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


* example RPM Package release, for GRavitee AM Release `3.5.3`, see [this pipeline execution](https://app.circleci.com/pipelines/github/gravitee-io/graviteeio-access-management/1215/workflows/2384763e-eab4-466d-b3cc-976212f901c0/jobs/1197)  :

```bash
# export CCI_TOKEN=<your Circle CI Token>

export GRAVITEE_RELEASE_VERSION="3.5.3"
#
export ORG_NAME="gravitee-lab"
export ORG_NAME="gravitee-io"
export REPO_NAME="gio-graviteeio-access-management"
export REPO_NAME="graviteeio-access-management"
export BRANCH="master"
export BRANCH="cicd/circleci-release"
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
