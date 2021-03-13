---
title: "Package Bundle (Zips)"
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "CI/CD Processes"
menu: apim_processes
menu_index: 7
product: "Gravitee APIM"
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: apim-processes
---

## Process Description

Build the zip files and deploy them to https://download.gravitee.io




## How to run

Launch the package bundle for a given Gravitee.io Release :

#### Example for Release `1.25.27`

* example for Release `1.25.27`, with Entreprise Edition  (**tested OK** , see [this pipeline execution](cccccc), showing that it's the transformation from dist.gravitee.io to download.graavitee.io , formerly done manually, which has an issue )  :

```bash
export CCI_TOKEN=<your Circle CI Token>

export GRAVITEE_RELEASE_VERSION="1.25.27"
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
export BRANCH="1.25.x"
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

* example for Release `1.25.27`, without Entreprise Edition  (**tested OK** , see [this pipeline execution](https://app.circleci.com/pipelines/github/gravitee-io/release/505/workflows/1632b81a-eb26-46eb-9528-68ed7cb818d1/jobs/477), showing that it's the transformation from dist.gravitee.io to download.graavitee.io , formerly done manually, which has an issue )  :

```bash
export CCI_TOKEN=<your Circle CI Token>

export GRAVITEE_RELEASE_VERSION="1.25.27"
export ORG_NAME="gravitee-io"
export REPO_NAME="release"
export BRANCH="1.25.x"
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

#### Example for Release `1.25.26`

* example for Release `1.25.26`, with Entreprise Edition  (**tested OK** , see [this pipeline execution](cccccc), showing that it's the transformation from dist.gravitee.io to download.graavitee.io , formerly done manually, which has an issue )  :

```bash
export CCI_TOKEN=<your Circle CI Token>

export GRAVITEE_RELEASE_VERSION="1.25.26"
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
export BRANCH="1.25.x"
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

* example for Release `1.25.26`, without Entreprise Edition  (**tested OK** , see [this pipeline execution](cccccc), showing that it's the transformation from dist.gravitee.io to download.graavitee.io , formerly done manually, which has an issue )  :

```bash
export CCI_TOKEN=<your Circle CI Token>

export GRAVITEE_RELEASE_VERSION="1.25.26"
export ORG_NAME="gravitee-io"
export REPO_NAME="release"
export BRANCH="1.25.x"
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


### Example for release `3.0.2`

* example package bundle  for Release `3.0.2`, without entreprise edition :

```bash
export CCI_TOKEN=<your Circle CI Token>
export GRAVITEE_RELEASE_VERSION="3.0.2"
export ORG_NAME="gravitee-io"
export REPO_NAME="release"
export BRANCH="3.0.x"
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

* Example package bundle for APIM `3.0.2`, with entreprise edition (tested ok with [this pipeline execution](https://app.circleci.com/pipelines/github/gravitee-io/release/771/workflows/0a3b209c-6507-4fb4-8bd1-d377229f6ace/jobs/779) ) :

```bash
export CCI_TOKEN=<your Circle CI Token>

export GRAVITEE_RELEASE_VERSION="3.0.2"
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
# this one (only this one) can be infered from release.json with :
# ---
# cat release.json | jq .components | jq --arg COMP_NAME "gravitee-notifier-email" '.[]|select(.name == $COMP_NAME)' | jq .version | awk -F '"' '{print $2}'
# ---
export NOTIFIER_EMAIL_VERSION="1.2.7"
export NOTIFIER_EMAIL_VERSION="1.2.2"


export ORG_NAME="gravitee-io"
export REPO_NAME="release"
export BRANCH="3.0.x"
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


### Example for release `3.0.10`

* Example package bundle for APIM `3.0.10`, with entreprise edition (tested ok with [this pipeline execution](https://app.circleci.com/pipelines/github/gravitee-io/release/771/workflows/0a3b209c-6507-4fb4-8bd1-d377229f6ace/jobs/779) ) :

```bash
export CCI_TOKEN=<your Circle CI Token>

export GRAVITEE_RELEASE_VERSION="3.0.10"
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
# this one (only this one) can be infered from release.json with :
# ---
# cat release.json | jq .components | jq --arg COMP_NAME "gravitee-notifier-email" '.[]|select(.name == $COMP_NAME)' | jq .version | awk -F '"' '{print $2}'
# ---
export NOTIFIER_EMAIL_VERSION="1.2.2"
export NOTIFIER_EMAIL_VERSION="1.2.7"


export ORG_NAME="gravitee-io"
export REPO_NAME="release"
export BRANCH="3.0.x"
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


## ANNEX : Utility Script to test the whole delivery


* When the Orb has finsihed executing, the last step is `Publish to https://download.gravitee.io (s3 butcket)`. At the end of the logs of this step, the source code of a script is displayed, to help you test the whole delivery.
* copy the source code of that shell script for example into a `./script.sh` file, and then execute it like this :

```bash
mkdir ./where-you-will-test-locally
cd ./where-you-will-test-locally/
mkdir my_test_www
chmod +x ./script.sh
export BASE_WWW_FOLDER=$(pwd)/my_test_www
./script.sh
# and then discover the whole tree of fiels and fodlers which is delivered :
tree $(pwd)/my_test_www
echo "Eventually modify ./script.sh to reset destination path of a few zip files"
echo "and when you're ready, run the script agaisnt the folder served by https://download.gravitee.io : "
export BASE_WWW_FOLDER="/opt/dist/download.gravitee.io/www"
./script.sh
```
