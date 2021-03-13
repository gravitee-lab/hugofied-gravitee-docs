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



## Gravitee APIM 3.7.0 release

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


### 1. Orchestrated Maven and git release

* To run the orchestrated Maven and git release, with dry run mode on :

```bash
# export CCI_TOKEN=<You Circle CI User Personal Token>

export ORG_NAME="gravitee-io"
export REPO_NAME="release"
export BRANCH="master"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"dry_release\"
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```


* To run the orchestrated Maven and git release, with dry run mode off :

```bash
# export CCI_TOKEN=<You Circle CI User Personal Token>

export ORG_NAME="gravitee-io"
export REPO_NAME="release"
export BRANCH="master"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"release\"
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```


### 2. Package bundle and Nexus staging


* Run orchestrated Maven and git release :

* Running the package bundle requires the git tag to exist : so the maven and git release must be run with dry run mode off (Orchestrator invoked with GNU Option `--dry-run false`)
* To run th epackage bundle for the Release `3.7.0`, without Entreprise Edition  (**tested OK** , see [this pipeline execution](https://app.circleci.com/pipelines/github/gravitee-io/release/505/workflows/1632b81a-eb26-46eb-9528-68ed7cb818d1/jobs/477), showing that it's the transformation from dist.gravitee.io to download.graavitee.io , formerly done manually, which has an issue )  :

```bash
# export CCI_TOKEN=<your Circle CI Token>

export GRAVITEE_RELEASE_VERSION="3.7.0"
export ORG_NAME="gravitee-io"
export REPO_NAME="release"
export BRANCH="master"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"publish_bundles\",
        \"gio_release_version\": \"${GRAVITEE_RELEASE_VERSION}\",
        \"with_ee\": false
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```

* To run the package bundle for the Release `3.7.0`, with Entreprise Edition

```bash
# export CCI_TOKEN=<your Circle CI Token>

export GRAVITEE_RELEASE_VERSION="3.7.0"
export AE_VERSION="1.3.0"
# https://github.com/gravitee-io/gravitee-license/tags
export LICENSE_VERSION="1.1.2"
# https://github.com/gravitee-io/gravitee-notifier-slack/tags
export NOTIFIER_SLACK_VERSION="1.0.3"
# https://github.com/gravitee-io/gravitee-notifier-webhook/tags
export NOTIFIER_WEBHOOK_VERSION="1.0.4"
# ---
# https://github.com/gravitee-io/gravitee-notifier-email/tags
# ---
# this one can be infered from release.json with :
# ---
# cat release.json | jq .components | jq --arg COMP_NAME "gravitee-notifier-email" '.[]|select(.name == $COMP_NAME)' | jq .version | awk -F '"' '{print $2}'
# ---
export NOTIFIER_EMAIL_VERSION="1.1.0"
export NOTIFIER_EMAIL_VERSION="1.2.7"


export ORG_NAME="gravitee-io"
export REPO_NAME="release"
export BRANCH="master"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"publish_bundles\",
        \"gio_release_version\": \"${GRAVITEE_RELEASE_VERSION}\",
        \"ae_version\": \"${AE_VERSION}\",
        \"license_version\": \"${LICENSE_VERSION}\",
        \"notifier_slack_version\": \"${NOTIFIER_SLACK_VERSION}\",
        \"notifier_webhook_version\": \"${NOTIFIER_WEBHOOK_VERSION}\",
        \"notifier_email_version\": \"${NOTIFIER_EMAIL_VERSION}\"
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .

# --
# Will fail at downloading https://download.gravitee.io/graviteeio-apim/distributions/graviteeio-full-1.25.27.zip
# But we have              https://gravitee-releases-downloads.cellar-c2.services.clever-cloud.com/graviteeio-apim/distributions/graviteeio-full-1.25.27.zip
```

Package bundle is completely idempotent : you can run as many times as you want, nothing will ever fail "because it was already done". And the result is always the exact same, unles you change either parameters, or soruce code of the package bundler (NodeJS Python or Circle CI Orb)


### 3. Nexus staging

```bash
# export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="release"
export BRANCH="master"
export GIO_RELEASE_VERSION="3.7.0"
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



## ANNEX A Utility commands for the maven and git release preps


Before being able to run the release, for each invovled repository, I had to :
* update the `.circleci/config.yml` on the branch invovled in the release
* update the pom.xml to use a new version of the gravitee-parent : the `19.2` version

To do that, I use JQ to quickly filter all the `-SNAPSHOT` components :

```bash

cat release.json | jq .components | jq '.[] | select(.version != null) | select(.version|endswith("-SNAPSHOT"))'

echo "And with the git branch for each repo : "
cat release.json | jq .components | jq '.[] | select(.version != null) | select(.version|endswith("-SNAPSHOT"))'  | jq '. | "https://github.com/gravitee-io/\(.name) branch \(.version)"' | sed "s#https://github.com/#git@github.com:#g" | awk -F '.' '{print $1 "." $2 "." $3 "." $4 }' | awk -F '"' '{print $2}' | awk -F '-SNAPSHOT' '{print $1}'
echo "And with the SSH GIT URI : "
cat release.json | jq .components | jq '.[] | select(.version != null) | select(.version|endswith("-SNAPSHOT"))'  | jq '. | "https://github.com/gravitee-io/\(.name) branch \(.version)"' | sed "s#https://github.com/#git@github.com:#g" | awk -F '.' '{print $1 "." $2 "." $3 "." $4 }' | awk -F '"' '{print $2}' | awk -F '-SNAPSHOT' '{print $1}' | awk -F '.' '{if ($NF == "0") {print $1 "." $2 "master" } else {print $1 "." $2 "." $3 "." $4}}'

export GIO_RELEASE_VERSION=$(cat release.json | jq .version | awk -F '"' '{print $2}')
echo "GIO_RELEASE_VERSION=[${GIO_RELEASE_VERSION}]"
cat release.json | jq .components | jq '.[] | select(.version == null)' | jq --arg GIO_RELEASE_VERSION "${GIO_RELEASE_VERSION}" '. | "https://github.com/gravitee-io/\(.name) branch \($GIO_RELEASE_VERSION)"' | sed "s#https://github.com/#git@github.com:#g" | awk -F '.' '{print $1 "." $2 "." $3 "." $4 }' | awk -F '"' '{print $2}' | awk -F '-SNAPSHOT' '{print $1}'
cat release.json | jq .components | jq '.[] | select(.version == null)' | jq --arg GIO_RELEASE_VERSION "${GIO_RELEASE_VERSION}" '. | "https://github.com/gravitee-io/\(.name) branch \($GIO_RELEASE_VERSION)"' | sed "s#https://github.com/#git@github.com:#g" | awk -F '.' '{print $1 "." $2 "." $3 "." $4 }' | awk -F '"' '{print $2}' | awk -F '-SNAPSHOT' '{print $1}' | awk -F '.' '{if ($NF == "0") {print $1 "." $2 "master" } else {print $1 "." $2 "." $3 "." $4}}'

```

prepared git commands :

```bash
# ++ if gravitee parent pom is in version 15 (like e.g. [gravitee-reporter-api]):
# git add --all && git commit -m "CiCd / prepare APIM 3.7.0 release: upgrade gravitee-parent to version 15.1, and [.circleci/config.yml] pipeline def." && git push -u origin HEAD

# ++ if gravitee parent pom is in a 17.x version :
# git add --all && git commit -m "CiCd / prepare APIM 3.7.0 release: upgrade gravitee-parent to version 17.2, and [.circleci/config.yml] pipeline def." && git push -u origin HEAD

# ++ if gravitee parent pom is in a 19.x version :
# git add --all && git commit -m "CiCd / prepare APIM 3.7.0 release: upgrade gravitee-parent to version 19.2, and [.circleci/config.yml] pipeline def." && git push -u origin HEAD

```
