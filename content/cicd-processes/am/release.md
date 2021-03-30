---
title: "Gravitee AM Release"
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "CI/CD Processes"
menu: am_processes
menu_index: 12
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: am-processes
---

## Process Description

TODO

## The Circle CI TOken

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

## How to: Perfom a Release

* Launch in dry run mode  :

```bash
export CCI_TOKEN=<your user circle ci token>

export ORG_NAME="gravitee-lab"
export ORG_NAME="gravitee-io"
export REPO_NAME="gio-graviteeio-access-management"
export REPO_NAME="graviteeio-access-management"
export BRANCH="master"
export BRANCH="cicd/circleci-release"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"release\",
        \"dry_run\": true
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```


## Running locally (with dry run mode only)


```bash
export DOCKER_IMAGE_GUN="circleci/openjdk:11.0.3-jdk-stretch"

# In Docker executor : uid=3434(circleci) gid=3434(circleci) groups=3434(circleci)
export NON_ROOT_USER_NAME="circleci"
export CCI_USER_UID="3434"
export CCI_USER_GID="3434"
export OUTSIDE_CONTAINER_SECRETS_VOLUME=$(mktemp -d -t "oci_secrets_vol-XXXXXXXXXX")
docker pull ${DOCKER_IMAGE_GUN}

# docker run -it --rm --user ${CCI_USER_UID}:${CCI_USER_GID} -v ${OUTSIDE_CONTAINER_SECRETS_VOLUME}:/home/$NON_ROOT_USER_NAME/.secrets -v "$PWD":/usr/src/giomaven_project -v "$HOME/.m2":/home/${NON_ROOT_USER_NAME_LABEL}/.m2 -e MAVEN_CONFIG=/home/${NON_ROOT_USER_NAME_LABEL}/.m2 -w /usr/src/giomaven_project "${MVN_DOCKER}" ${MAVEN_SHELL_SCRIPT}
# docker run -it --rm --user ${CCI_USER_UID}:${CCI_USER_GID} -v ${OUTSIDE_CONTAINER_SECRETS_VOLUME}:/home/$NON_ROOT_USER_NAME/.secrets -v "$PWD":/home/circleci/project -v "$HOME/.m2":/home/${NON_ROOT_USER_NAME_LABEL}/.m2 -e MAVEN_CONFIG=/home/${NON_ROOT_USER_NAME_LABEL}/.m2 -w /home/circleci/project "${DOCKER_IMAGE_GUN}" ${MAVEN_SHELL_SCRIPT}
docker run -it --rm --user ${CCI_USER_UID}:${CCI_USER_GID} -v "$PWD":/home/circleci/project -v "$HOME/.m2":/home/${NON_ROOT_USER_NAME_LABEL}/.m2 -e MAVEN_CONFIG=/home/${NON_ROOT_USER_NAME_LABEL}/.m2 -w /home/circleci/project "${DOCKER_IMAGE_GUN}" ${MAVEN_SHELL_SCRIPT}

```
