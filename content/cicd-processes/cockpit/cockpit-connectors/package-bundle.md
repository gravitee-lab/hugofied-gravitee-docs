---
title: "Gravitee Kubernetes Release"
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "CI/CD Processes"
menu: apim_processes
menu_index: 8
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: apim-processes
---

## Process Description


## How to: Perfom a Package Bundle

This process publishes to https://download.gravitee.io/#graviteeio-apim/plugins/services/gravitee-kubernetes-controller/ the APIM Kubernetes Controller

This process is executed within the release process

#### With dry run mode ON

* To test the package bundle within a dry run release

```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-cockpit-connectors"
export BRANCH="cicd/release_process"
export BRANCH="master"
export BRANCH="cicd/package_bundle"
export GIO_RELEASE_VERSION="1.2.0"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"package_bundle\",
        \"package_bundle_version\": \"${GIO_RELEASE_VERSION}\",
        \"dry_run\": true
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```

#### With dry run mode OFF

```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-cockpit-connectors"
export BRANCH="cicd/release_process"
export BRANCH="master"
export BRANCH="cicd/package_bundle"
export GIO_RELEASE_VERSION="1.2.0"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"package_bundle\",
        \"package_bundle_version\": \"${GIO_RELEASE_VERSION}\",
        \"dry_run\": false
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```
