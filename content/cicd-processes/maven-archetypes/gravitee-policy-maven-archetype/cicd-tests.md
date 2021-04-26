---
title: "Gravitee Policy Maven Archetype CI/CD Processes"
date: 2020-12-16T00:44:23+01:00
draft: false
menu_index: 7
showChildrenInMenu : true
nav_menu: "CI/CD Processes"
type: metacicd-processes
---


#### Before you start : your need your Circle CI API Token

To execute every step of the release process, you will need something from circle CI : a Personal API Token.

Here is how you can get one :
* log into Circle CI at https://app.circleci.com with github authentication. Grant access to `gravitee-io` Github Org.
* Go to your Use settings menu : bottom left corner icon
* Then go to the  _**"Personal API Tokens"**_ menu, and click the "Create new Token" button.
* Keep the value of your token, you will need it at each step.


## Gravitee Policy Maven Archetype Releases


At the end of the release process:
* the git release is done (git tag and prepared next snapshot version)
* mvn deploy to Gravitee 's Private Artifactory
* mvn deploy to Nexus Staging

### Example to Release Gravitee Policy Maven Archetype `16.1` on `16.x` git branch

* To run the Maven and git release, with dry run mode on :

```bash
export CCI_TOKEN=<You Circle CI User Personal Token>

export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-parent"
export BRANCH="16.x"
# description: "Used only for the Gravitee Policy Maven Archetype Release Process: What will be the next snapshot version?"
export NEXT_SNAPSHOT_VERSION="16.2-SNAPSHOT"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"release\",
        \"next_snapshot_version\": \"${NEXT_SNAPSHOT_VERSION}\",
        \"dry_run\": true
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```

* To run the Maven and git release, with dry run mode off :

```bash
export CCI_TOKEN=<You Circle CI User Personal Token>

export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-parent"
export BRANCH="cicd/circleci-pipeline-def"
# release will happen on git branch "16.x" , when "cicd/circleci-pipeline-def" is merged into "16.x"
export BRANCH="16.x"
# description: "Used only for the Gravitee Policy Maven Archetype Release Process: What will be the next snapshot version?"
export NEXT_SNAPSHOT_VERSION="16.2-SNAPSHOT"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"release\",
        \"next_snapshot_version\": \"${NEXT_SNAPSHOT_VERSION}\",
        \"dry_run\": false
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```


### Example to REPLAY Release Gravitee Policy Maven Archetype `16.1` on `16.x` git branch


#### Without replaying the release to Nexus

* To run the Maven and git release, with dry run mode on :

```bash
export CCI_TOKEN=<You Circle CI User Personal Token>

export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-parent"
export BRANCH="16.x"
# description: "Used only for the Gravitee Policy Maven Archetype Release Process: What will be the next snapshot version?"
export REPLAYED_RELEASE="16.1"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"replay_release\",
        \"replayed_release\": \"${REPLAYED_RELEASE}\",
        \"dry_run\": true
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```

* To run the Maven and git release, with dry run mode off :

```bash
export CCI_TOKEN=<You Circle CI User Personal Token>

export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-parent"
export BRANCH="cicd/circleci-pipeline-def"
# release will happen on git branch "16.x" , when "cicd/circleci-pipeline-def" is merged into "16.x"
export BRANCH="16.x"
# description: "Used only for the Gravitee Policy Maven Archetype Release Process: What will be the next snapshot version?"
export REPLAYED_RELEASE="16.1"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"replay_release\",
        \"replayed_release\": \"${REPLAYED_RELEASE}\",
        \"dry_run\": false
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```


#### With a replay of the release to Nexus

* To run the Maven and git release, with dry run mode on :

```bash
export CCI_TOKEN=<You Circle CI User Personal Token>

export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-parent"
export BRANCH="16.x"
# description: "Used only for the Gravitee Policy Maven Archetype Release Process: What will be the next snapshot version?"
export REPLAYED_RELEASE="16.1"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"replay_release\",
        \"replayed_release\": \"${REPLAYED_RELEASE}\",
        \"replay_nexus\": true,
        \"dry_run\": true
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```

* To run the Maven and git release, with dry run mode off :

```bash
export CCI_TOKEN=<You Circle CI User Personal Token>

export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-parent"
export BRANCH="cicd/circleci-pipeline-def"
# release will happen on git branch "16.x" , when "cicd/circleci-pipeline-def" is merged into "16.x"
export BRANCH="16.x"
# description: "Used only for the Gravitee Policy Maven Archetype Release Process: What will be the next snapshot version?"
export REPLAYED_RELEASE="16.1"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"replay_release\",
        \"replayed_release\": \"${REPLAYED_RELEASE}\",
        \"replay_nexus\": true,
        \"dry_run\": false
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```
