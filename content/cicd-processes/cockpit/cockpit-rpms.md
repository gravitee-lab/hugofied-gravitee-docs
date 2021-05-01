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

Build Cockpit RPMs Redhat Packages


### How to: Release Cockpit RPMs

* example RPM Package release, for GRavitee Cckpit Release `1.2.1`, with dry run mode ON , see [this pipeline execution](https://app.circleci.com/pipelines/github/gravitee-io/gravitee-cockpit/2187/workflows/bfbb5824-07ea-480c-bbb4-9c378e7dff78/jobs/5754)  :

```bash
export CCI_TOKEN=<your Circle CI Token>

export GRAVITEE_RELEASE_VERSION="1.3.0"
export GRAVITEE_RELEASE_VERSION="1.2.1"
#
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-cockpit"
export BRANCH="1.2.x"
export BRANCH="cicd/rpm_release"
#
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"publish_rpms\",
        \"graviteeio_version\": \"${GRAVITEE_RELEASE_VERSION}\",
        \"dry_run\": true
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```

* example RPM Package release, for Gravitee Cckpit Release `1.2.1`, with dry run mode ON , see [this pipeline execution](https://app.circleci.com/pipelines/github/gravitee-io/gravitee-cockpit/2187/workflows/bfbb5824-07ea-480c-bbb4-9c378e7dff78/jobs/5754)  :

```bash
export CCI_TOKEN=<your Circle CI Token>

export GRAVITEE_RELEASE_VERSION="1.3.0"
export GRAVITEE_RELEASE_VERSION="1.2.1"
export GRAVITEE_RELEASE_VERSION="1.2.2"
#
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-cockpit"
export BRANCH="1.2.x"
export BRANCH="cicd/rpm_release"
#
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"publish_rpms\",
        \"graviteeio_version\": \"${GRAVITEE_RELEASE_VERSION}\",
        \"dry_run\": false
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```


```bash
export CCI_TOKEN=<your Circle CI Token>

export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-cockpit"
export BRANCH="cicd/release_process"
export BRANCH="master"
export BRANCH="cicd/docker_release_replay"
export BRANCH="cicd/in_release_package_bundle"

export GIO_RELEASE_TAG="1.2.1"
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
