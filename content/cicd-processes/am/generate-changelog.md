---
title: "Gravitee AM Release"
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "CI/CD Processes"
menu: am_processes
menu_index: 9
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: am-processes
---

## Process Description

Generate the CHANGELOG for a given Gravitee.io AM Release :
* set `dry_run` parameter to `false`, to get the CHANGELOG pushed to the issues repo


## How to run


#### Example for Release `1.25.27`

* example for Release `1.25.27`, see [this pipeline execution](cccccc)  :

```bash
export CCI_TOKEN=<your Circle CI Token>
# https://github.com/gravitee-io/issues/milestones
export GIO_MILESTONE_VERSION="APIM - 1.25.27"
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

* example for Release `1.25.26`, see [this pipeline execution](cccccc)  :

```bash
export CCI_TOKEN=<your Circle CI Token>
# https://github.com/gravitee-io/issues/milestones
export GIO_MILESTONE_VERSION="APIM - 1.25.26"
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


* example for Release `3.5.4`, see [this pipeline execution](cccccc)  :

```bash
export CCI_TOKEN=<your Circle CI Token>
# https://github.com/gravitee-io/issues/milestones
export GIO_MILESTONE_VERSION="APIM - 3.5.4"
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
