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


## How to: Perform a Package Bundle

This process publishes to https://download.gravitee.io/

The Cockpit Package Bundle

This process is executed within the release process

#### With dry run mode ON

* To test the package bundle within a dry run release

```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-cockpit"
export BRANCH="cicd/release_process"
export BRANCH="master"
export GIO_RELEASE_VERSION="1.2.1"
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
export REPO_NAME="gravitee-cockpit"
export BRANCH="cicd/release_process"
export BRANCH="master"
export GIO_RELEASE_VERSION="1.2.1"
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


## Test the In Release Package Bundle

* To test the package bundle within a dry run release :

```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-cockpit"
export BRANCH="master"
# Note : "cicd/in_release_package_bundle" git branch was created from the master git branch
export BRANCH="cicd/in_release_package_bundle"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"release\": true,
        \"dry_run\": true
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```


I also had to make a dry-run release of the `gravitee-cockpit-api` version `1.5.0` :
* in the dry run release of `gravitee-cockpit`, during the `Maven Prepare Release`, with "removes the `-SNAPSHOT` suffixes" from dependencies versio properties,
  * he `gravitee-cockpit-api` is in `1.5.0-SNAPSHOT` version, and is not updated to `1.5.0`, because in the dry-run release artifactory repository, the `1.5.0` is not there (I removed it)
  * SO I have to make a dry run release of `gravtiee-cockpit-api` from master git branch


```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-cockpit-api"
# on a "*.*.x" branch for a support release
export BRANCH="9.3.x"
export BRANCH="0.1.x"
# on master branch for a major release
export BRANCH="master"
# IMPORTANT ! Name of Maven profile defines in which Artifactory repo the mvn deploys sends
export MAVEN_PROFILE_ID="gravitee-dry-run"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"standalone_release\",
        \"maven_profile_id\": \"${MAVEN_PROFILE_ID}\",
        \"dry_run\": true
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```


I of course did not perform the release with dry run mode off :

```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-cockpit-api"
# on a "*.*.x" branch for a support release
export BRANCH="9.3.x"
export BRANCH="0.1.x"
# on master branch for a major release
export BRANCH="master"
# IMPORTANT ! Name of Maven profile defines in which Artifactory repo the mvn deploys sends
export MAVEN_PROFILE_ID="gravitee-dry-run"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"standalone_release\",
        \"maven_profile_id\": \"${MAVEN_PROFILE_ID}\",
        \"dry_run\": false
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```
