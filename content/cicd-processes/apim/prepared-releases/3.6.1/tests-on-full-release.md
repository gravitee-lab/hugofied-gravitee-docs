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

## Release 3.6.1 : the B.O.M.

```JSon
{
 "built_execution_plan_is": [
  [],
  [],
  [
   {
    "name": "gravitee-repository-test",
    "version": "3.6.1-SNAPSHOT"
   }
  ],
  [
   {
    "name": "gravitee-repository-mongodb",
    "version": "3.6.1-SNAPSHOT"
   },
   {
    "name": "gravitee-repository-jdbc",
    "version": "3.6.1-SNAPSHOT"
   },
   {
    "name": "gravitee-repository-gateway-bridge-http",
    "version": "3.6.1-SNAPSHOT"
   }
  ],
  [],
  [],
  [],
  [],
  [
   {
    "name": "gravitee-gateway",
    "version": "3.6.1-SNAPSHOT"
   }
  ],
  [],
  [
   {
    "name": "gravitee-reporter-file",
    "version": "2.1.1-SNAPSHOT"
   },
   {
    "name": "gravitee-reporter-tcp",
    "version": "1.2.0-SNAPSHOT"
   },
   {
    "name": "gravitee-policy-http-signature",
    "version": "1.0.1-SNAPSHOT"
   }
  ],
  [
   {
    "name": "gravitee-management-rest-api",
    "version": "3.6.1-SNAPSHOT"
   },
   {
    "name": "gravitee-management-webui",
    "version": "3.6.1-SNAPSHOT"
   },
   {
    "name": "gravitee-portal-webui",
    "version": "3.6.1-SNAPSHOT"
   }
  ]
 ]
}
```

## Gravitee APIM 3.6.1 release

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
export BRANCH="3.6.x"
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
# PAS AVANT GO !!!!!
export ORG_NAME="gravitee-io"
export REPO_NAME="release"
export BRANCH="3.6.x"
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

The release process in non dry run mode successfully completed in the following pipeline execution :

https://app.circleci.com/pipelines/github/gravitee-io/release/815/workflows/24d9265e-c4c3-4cb3-81b1-1e3473141a09/jobs/821


### 2. Package bundle

#### Process overview

* Running the package bundle requires the git tag to exist : so the maven and git release must be run with dry run mode off (Orchestrator invoked with GNU Option `--dry-run false`)

The package Bundle Entreprise Edition fetches zips from https://download.gravitee.io. That's why we must:
* first execute the package bundle for the Comunity Edition
* then execute the wget script to transfer the zips from the S3 Bucket, to https://download.gravitee.io :

```bash
wget https://raw.githubusercontent.com/gravitee-lab/hugofied-gravitee-docs/feature/first_release/content/cicd-processes/apim/prepared-releases/3.6.1/package_bundles_ce/script.download.gravitee.io.sh -O ./script.download.gravitee.io.sh
wget https://raw.githubusercontent.com/gravitee-lab/hugofied-gravitee-docs/feature/first_release/content/cicd-processes/apim/prepared-releases/3.6.1/package_bundles_ce/mkdirs.download.gravitee.io.sh -O ./mkdirs.download.gravitee.io.sh

chmod +x ./script.download.gravitee.io.sh
mdkir -p /opt/folder_for_test
export BASE_WWW_FOLDER="/opt/folder_for_test"
./script.download.gravitee.io.sh
# we also create the target folders which do not exist in the "/opt/folder_for_test" test folder
./mkdirs.download.gravitee.io.sh
# ---
# Then we check if what is in the [/opt/folder_for_test] has the expected tree structure
# ---
# And the we can run again with the path of the foler actually served by the https://download.gravitee.io server
# Can't check that but I thin k the path is :
# export BASE_WWW_FOLDER="/opt/dist/download.gravitee.io"
# ---
#
export BASE_WWW_FOLDER="/opt/dist/download.gravitee.io"
./script.download.gravitee.io.sh
# we do not create the target folders inthe real www folder : theynshould already exist

```

* and finally run the packge bundle for the Entreprise Edition


* To run the package bundle for the Release `3.6.1`, without Entreprise Edition  (**tested OK** , see [this pipeline execution](https://app.circleci.com/pipelines/github/gravitee-io/release/505/workflows/1632b81a-eb26-46eb-9528-68ed7cb818d1/jobs/477), showing that it's the transformation from dist.gravitee.io to download.graavitee.io , formerly done manually, which has an issue )  :

#### Now the process curls

```bash
# export CCI_TOKEN=<your Circle CI Token>

export GRAVITEE_RELEASE_VERSION="3.6.1"
export ORG_NAME="gravitee-io"
export REPO_NAME="release"
export BRANCH="3.6.x"
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
* succesfully ran the package bundle for Community Edition with this pipeline execution : https://app.circleci.com/pipelines/github/gravitee-io/release/820/workflows/d39d19a6-1fd6-4622-bdcc-d5850e00332d/jobs/824

* To run the package bundle for the Release `3.6.1`, with Entreprise Edition

```bash
# export CCI_TOKEN=<your Circle CI Token>
# the versions for the below dependencies were confirmed at each release time by POs
export GRAVITEE_RELEASE_VERSION="3.6.1"
export AE_VERSION="1.2.18"
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
export BRANCH="3.6.x"
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
# Will fail at downloading https://download.gravitee.io/graviteeio-apim/distributions/graviteeio-full-3.6.1.zip
# But we have              https://gravitee-releases-downloads.cellar-c2.services.clever-cloud.com/graviteeio-apim/distributions/graviteeio-full-3.6.1.zip
```

Package bundle is completely idempotent : you can run as many times as you want, nothing will ever fail "because it was already done". And the result is always the exact same, unles you change either parameters, or soruce code of the package bundler (NodeJS Python or Circle CI Orb)


### 3. Nexus staging

beware, there is no dry run for this one

```bash
# export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="release"
export BRANCH="3.6.x"
export GIO_RELEASE_VERSION="3.6.1"
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

#### Nexus staging results

* Failed jobs (each of them can be relaunched with circle ci web ui re-run button) :
  * [SOLVED] `gravitee-reporter-file` fails because `prettier --check fails` https://app.circleci.com/pipelines/github/gravitee-io/gravitee-reporter-file/43/workflows/5966ddd3-45bd-4bc2-969a-3672b1b30ce1/jobs/38 : fixed by rnning mvn prettier:write before nexus staging
  * [SOLVED] `gravitee-policy-http-signature` failed to find `gravitee-gateway-buffer` in nexus, https://app.circleci.com/pipelines/github/gravitee-io/gravitee-policy-http-signature/6/workflows/4f99c8b4-18f5-4b28-a46e-767269bb650c/jobs/5
  * [SOLVED] `gravitee-repository-mongodb` : failed because was failing to find `gravitee-repository-test` in nexus
  * basically dpeendencies are resolved from nexus, so : I should change the nexus-staging settings.xml, so that :
    * dependencies are resolved from private artifactory
    * and altDeploymentTBlabal: target mvn repository is nexus staging


* To indivudually relaunch the nexus staging with a `curl`, just for gravitee-gateway :

```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-reporter-file"
export BRANCH="2.1.x"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"nexus_staging\",
        \"secrethub_org\": \"graviteeio\",
        \"secrethub_repo\": \"cicd\",
        \"s3_bucket_name\": \"prepared-nexus-staging-gravitee-apim-3_6_1\",
        \"maven_profile_id\": \"gravitee-release\"
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```

* Successful nexus staging :
  * `gravitee-repository-test` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-repository-test/135/workflows/fa52b8b6-4764-4446-82e6-9f61616ec29f/jobs/123
  * `gravitee-repository-jdbc` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-repository-jdbc/143/workflows/08e66f16-690d-4d22-87b2-907c362f8cc3/jobs/132
  * `gravitee-repository-gateway-bridge-http` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-repository-gateway-bridge-http/85/workflows/613be08d-44d5-4b72-a74e-a366699dbfc7/jobs/76
  * `gravitee-reporter-tcp` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-reporter-tcp/22/workflows/a59607e5-4209-4476-a6b7-4657a4fd69a1/jobs/20
  * `gravitee-gateway` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-gateway/359/workflows/85c1fedd-3f03-43e6-b63e-e1af3ec9d247/jobs/332
  * `gravitee-portal-webui` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-portal-webui/301/workflows/be46bcc7-97bd-4864-ab28-bb83678d3ec0/jobs/277
  * `gravitee-management-webui` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-management-webui/844/workflows/ac305919-b6e4-4887-8e1f-4c6b94ff5961/jobs/825
  * `gravitee-repository-mongodb` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-repository-mongodb/144/workflows/e18e00bf-a27d-4550-b8b3-02f650e41a0b/jobs/133
  * `gravitee-management-rest-api` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-management-rest-api/906/workflows/3ceb581b-af5e-4244-bb77-4ac38298236a/jobs/877
  * `gravitee-policy-http-signature` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-policy-http-signature/6/workflows/a09e4002-7d17-4e8f-8881-1c2060cdb554/jobs/6
  * `gravitee-reporter-file` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-reporter-file/45/workflows/123c214a-595f-48bb-b974-e1d8fa9ae128/jobs/41




#### changelog

* example for Release `3.6.1`, see [this pipeline execution](cccccc)  :

```bash
export CCI_TOKEN=<your Circle CI Token>
# https://github.com/gravitee-io/issues/milestones
export GIO_MILESTONE_VERSION="APIM - 3.5.8"
export GIO_MILESTONE_VERSION="APIM - 3.6.1"
export ORG_NAME="gravitee-io"
export REPO_NAME="issues"
export BRANCH="master"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"changelog_apim\",
        \"gio_milestone_version\": \"${GIO_MILESTONE_VERSION}\",
        \"dry_run\": true
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```

* dry run success : https://app.circleci.com/pipelines/github/gravitee-io/issues/23/workflows/3d828633-aadb-4ef0-871a-4a7d2d7aa1fa/jobs/22

* and in non dry run when logged CHANGELOG modification is confirmed :) :

```bash
export CCI_TOKEN=<your Circle CI Token>
# https://github.com/gravitee-io/issues/milestones
export GIO_MILESTONE_VERSION="APIM - 3.6.1"
export ORG_NAME="gravitee-io"
export REPO_NAME="issues"
export BRANCH="master"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"changelog_apim\",
        \"gio_milestone_version\": \"${GIO_MILESTONE_VERSION}\",
        \"dry_run\": false
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```

* sucessful exec : https://app.circleci.com/pipelines/github/gravitee-io/issues/24/workflows/c16ac351-a517-480d-8955-dcc6880e742f/jobs/23

## docker images


```bash
# You, will just use your own Circle CI Token
export CCI_TOKEN=<your circle ci personal api token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-docker"
export BRANCH="master"
export BRANCH="feature/cicd-circle-image-builds"
export GRAVITEEIO_VERSION="3.6.1"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_product\": \"apim_3x\",
        \"graviteeio_version\": \"${GRAVITEEIO_VERSION}\",
        \"tag_latest\": false,
        \"dry_run\": false
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```

succesfully built images EE and CE :

* https://app.circleci.com/pipelines/github/gravitee-io/gravitee-docker/95/workflows/27806892-bc99-4721-b2e6-6c7d36ba4ea6/jobs/127

### RPM Packages `3.6.1`

```bash
export GRAVITEE_RELEASE_VERSION="3.6.1"
export ORG_NAME="gravitee-io"
export REPO_NAME="release"
export BRANCH="3.6.x"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"publish_rpms\",
        \"gio_release_version\": \"${GRAVITEE_RELEASE_VERSION}\"
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
# git add --all && git commit -m "CiCd / prepare APIM 3.6.1 release: upgrade gravitee-parent to version 15.1, and [.circleci/config.yml] pipeline def." && git push -u origin HEAD

# ++ if gravitee parent pom is in a 17.x version :
# git add --all && git commit -m "CiCd / prepare APIM 3.6.1 release: upgrade gravitee-parent to version 17.2, and [.circleci/config.yml] pipeline def." && git push -u origin HEAD

# ++ if gravitee parent pom is in a 19.x version :
# git add --all && git commit -m "CiCd / prepare APIM 3.6.1 release: upgrade gravitee-parent to version 19.2, and [.circleci/config.yml] pipeline def." && git push -u origin HEAD

```
