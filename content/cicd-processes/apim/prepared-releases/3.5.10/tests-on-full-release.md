---
title: "Full Release Process Tests"
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "CI/CD Processes"
menu: apim_processes
menu_index: 11
product: "Gravitee APIM"
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: apim-processes
---

## Process Description

Here I leave the tests I ran to perform a full APIM release :
* 1. maven and git release
* 2. en parallèle :
  * package n publish zip bundles
  * nexus-staging
* 3. En parallèle :
  * docker images CE and EE
  * rpm
  * changelog
  * continous delivery https://docs.gravitee.io (truc à valider pour les branchesde départ et arrivée)
* etc...

## Release 3.5.10 : the B.O.M.

```JSon
{
 "built_execution_plan_is": [
  [],
  [],
  [],
  [],
  [],
  [],
  [],
  [],
  [
   {
    "name": "gravitee-gateway",
    "since": "3.5.9",
    "version": "3.5.10-SNAPSHOT"
   }
  ],
  [],
  [
   {
    "name": "gravitee-policy-groovy",
    "version": "1.12.2-SNAPSHOT"
   },
   {
    "name": "gravitee-policy-keyless",
    "version": "1.3.1-SNAPSHOT"
   }
  ],
  [
   {
    "name": "gravitee-management-rest-api",
    "since": "3.5.9",
    "version": "3.5.10-SNAPSHOT"
   },
   {
    "name": "gravitee-management-webui",
    "since": "3.5.9",
    "version": "3.5.10-SNAPSHOT"
   },
   {
    "name": "gravitee-portal-webui",
    "since": "3.5.9",
    "version": "3.5.10-SNAPSHOT"
   }
  ]
 ]
}
```

git clones :

```bash
export OPS_HOME=$(pwd)


git clone git@github.com:gravitee-io/gravitee-gateway
cd gravitee-gateway
git checkout 3.5.x
cd ${OPS_HOME}
# "version": "3.5.10-SNAPSHOT"

git clone git@github.com:gravitee-io/gravitee-management-rest-api
cd gravitee-management-rest-api
git checkout 3.5.x
cd ${OPS_HOME}
# "version": "3.5.10-SNAPSHOT"

git clone git@github.com:gravitee-io/gravitee-management-webui
cd gravitee-management-webui
git checkout 3.5.x
cd ${OPS_HOME}
# "version": "3.5.10-SNAPSHOT"

git clone git@github.com:gravitee-io/gravitee-portal-webui
cd gravitee-portal-webui
git checkout 3.5.x
cd ${OPS_HOME}
# "version": "3.5.10-SNAPSHOT"



# -- other repos

git clone git@github.com:gravitee-io/gravitee-policy-groovy
cd gravitee-policy-groovy/
git checkout 1.12.x
# version: 1.12.2-SNAPSHOT
cd ${OPS_HOME}

git clone git@github.com:gravitee-io/gravitee-policy-keyless
cd gravitee-policy-keyless/
git checkout 1.3.x
# version: 1.3.1-SNAPSHOT
cd ${OPS_HOME}

```

AFTER I UPDATED CONFIG.YML FOR ALL REPOS, @RACHID DID ALL THE RELEASE PROCESS STEPS HIMSELF
I JUST RE RAN THE NEXUS STAGING PART, TO FIX A NEXUS STAGING ISSUE IN ORB WITH DOCKER EXECUTORS

## Gravitee APIM `3.5.10` release

To get a Circlei CI Token, I personally use :

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

But you can get a Circle CI "Personal API Token" just using the Circle CI Web UI in your profile settings menu.



### 3. Nexus staging

beware, there is no dry run for this one

```bash
# export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="release"
export BRANCH="3.5.x"
export GIO_RELEASE_VERSION="3.5.10"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"nexus_staging\",
        \"gio_release_version\": \"${GIO_RELEASE_VERSION}\"
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```
