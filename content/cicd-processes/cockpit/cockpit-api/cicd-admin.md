---
title: "CICD Janitor"
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "CI/CD Processes"
menu: apim_processes
menu_index: 4
product: "Gravitee APIM"
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: apim-processes
---


## Cicd janitor

For each gravitee repo, They are common task we have to perform, on a regular basis, very anoying ones like :
* force re-calculate the maven metadata
* etc...

This Pipeline Wokrkflow aautomates running those tedious tasks

#### Before you start : your need your Circle CI API Token

To execute every step of the release process, you will need something from circle CI : a Personal API Token.

Here is how you can get one :
* log into Circle CI at https://app.circleci.com with github authentication. Grant access to `gravitee-io` Github Org.
* Go to your Use settings menu : bottom left corner icon
* Then go to the  _**"Personal API Tokens"**_ menu, and click the "Create new Token" button.
* Keep the value of your token, you will need it at each step.


## Launch the CICD Janitor



```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-cockpit-api"
# on master branch for a major release
export BRANCH="master"
# on a "*.*.x" branch for a support release
export BRANCH="9.3.x"
export BRANCH="cicd/force-mvn-metadata-artifactory-orb"
# IMPORTANT ! Name of Maven profile defines in which Artifactory repo the mvn deploys sends
export MAVEN_PROFILE_ID="gravitee-dry-run"
# The Maven meta data wil be forced re-calculated for this Artifaactory Repository
export ARTIFACTORY_REPOSITORY="dry-run-releases"
export ARTIFACTORY_REPOSITORY="gravitee-releases"
export ARTIFACTORY_REPOSITORY="gravitee-snapshots"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"cicd_janitor\",
        \"maven_profile_id\": \"${MAVEN_PROFILE_ID}\",
        \"janitor_artifactory_repository\": \"${ARTIFACTORY_REPOSITORY}\"
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```
