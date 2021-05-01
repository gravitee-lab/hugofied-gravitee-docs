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


### 3. PAckage Bundle CE only


```bash
# export CCI_TOKEN=<you circle ci token>
export GRAVITEE_RELEASE_VERSION="3.8.0"
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

```bash
# export CCI_TOKEN=<your Circle CI Token>
# the versions for the below dependencies were confirmed at each release time by POs
export GRAVITEE_RELEASE_VERSION="3.6.1"
# what is the version of Alert Engine ?
export AE_VERSION="1.2.18"
# https://github.com/gravitee-io/gravitee-license/tags
# what is the the version of the Gravitee License ?
export LICENSE_VERSION="1.1.2"
# https://github.com/gravitee-io/gravitee-notifier-slack/tags
# what is the version of Notifier Slack ?
export NOTIFIER_SLACK_VERSION="1.0.3"
# https://github.com/gravitee-io/gravitee-notifier-webhook/tags
# what is the version of Notifier Webhook ?
export NOTIFIER_WEBHOOK_VERSION="1.0.4"
# ---
# https://github.com/gravitee-io/gravitee-notifier-email/tags
# ---
# this one can be infered from release.json with :
# ---
# cat release.json | jq .components | jq --arg COMP_NAME "gravitee-notifier-email" '.[]|select(.name == $COMP_NAME)' | jq .version | awk -F '"' '{print $2}'
# ---
# what is the version of Notifier Email ?
export NOTIFIER_EMAIL_VERSION="1.2.7"


export ORG_NAME="gravitee-io"
export REPO_NAME="release"
# For example, for the 3.6.1 APIM release, the git branch was 3.6.x
export BRANCH="3.6.x"
# if P is zero, than the git branch will be master
export BRANCH="master"
# if P is not zero, than the git branch will be M.N.x
export BRANCH="M.N.x"

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

```
