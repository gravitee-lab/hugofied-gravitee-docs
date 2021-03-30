---
title: "Gravitee Cockpit Release Replay"
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "CI/CD Processes"
menu: cockpit_processes
menu_index: 11
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: cockpit-processes
---

## Process Description

TODO

## How to Replay a Release

* Launch in dry run mode  :

```bash
export CCI_TOKEN=<your user circle ci token>

export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-cockpit"
export BRANCH="cicd/release_process"
export BRANCH="master"
export BRANCH="cicd/docker_release_replay"
export GIO_RELEASE_TAG="1.1.2"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"replay_release\",
        \"dry_run\": true,
        \"gio_release_tag\": \"${GIO_RELEASE_TAG}\"
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```


* Launch in dry run mode  :

```bash
export CCI_TOKEN=<your user circle ci token>

export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-cockpit"
export BRANCH="cicd/release_process"
export BRANCH="master"
export BRANCH="cicd/docker_release_replay"
export GIO_RELEASE_TAG="1.1.2"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"replay_release\",
        \"dry_run\": false,
        \"gio_release_tag\": \"${GIO_RELEASE_TAG}\"
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```
