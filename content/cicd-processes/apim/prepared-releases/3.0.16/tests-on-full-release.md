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

## Release 3.0.16 : the B.O.M.

```JSon
{
 "built_execution_plan_is": [
  [],
  [
   {
    "name": "gravitee-repository",
    "version": "3.0.9-SNAPSHOT"
   }
  ],
  [
   {
    "name": "gravitee-repository-test",
    "version": "3.0.9-SNAPSHOT"
   }
  ],
  [
   {
    "name": "gravitee-repository-mongodb",
    "version": "3.0.9-SNAPSHOT"
   },
   {
    "name": "gravitee-repository-jdbc",
    "version": "3.0.11-SNAPSHOT"
   }
  ],
  [],
  [],
  [],
  [],
  [
   {
    "name": "gravitee-gateway",
    "version": "3.0.16-SNAPSHOT"
   }
  ],
  [],
  [
   {
    "name": "gravitee-elasticsearch",
    "version": "3.0.11-SNAPSHOT"
   }
  ],
  [
   {
    "name": "gravitee-management-rest-api",
    "version": "3.0.16-SNAPSHOT"
   },
   {
    "name": "gravitee-management-webui",
    "version": "3.0.16-SNAPSHOT"
   },
   {
    "name": "gravitee-portal-webui",
    "version": "3.0.16-SNAPSHOT"
   }
  ]
 ]
}
```

git clones :

```bash
export OPS_HOME=$(pwd)

git clone git@github.com:gravitee-io/gravitee-repository
cd gravitee-repository
git checkout 3.0.x
cd ${OPS_HOME}
# "version": "3.0.9-SNAPSHOT"

git clone git@github.com:gravitee-io/gravitee-repository-test
cd gravitee-repository-test
git checkout 3.0.x
cd ${OPS_HOME}
# "version": "3.0.9-SNAPSHOT"

git clone git@github.com:gravitee-io/gravitee-repository-mongodb
cd gravitee-repository-mongodb
git checkout 3.0.x
cd ${OPS_HOME}
# "version": "3.0.9-SNAPSHOT"

git clone git@github.com:gravitee-io/gravitee-repository-jdbc
cd gravitee-repository-jdbc
git checkout 3.0.x
cd ${OPS_HOME}
# "version": "3.0.11-SNAPSHOT"

git clone git@github.com:gravitee-io/gravitee-gateway
cd gravitee-gateway
git checkout 3.0.x
cd ${OPS_HOME}
# "version": "3.0.16-SNAPSHOT"

git clone git@github.com:gravitee-io/gravitee-elasticsearch
cd gravitee-elasticsearch
git checkout 3.0.x
cd ${OPS_HOME}
# "version": "3.0.11-SNAPSHOT"

git clone git@github.com:gravitee-io/gravitee-management-rest-api
cd gravitee-management-rest-api
git checkout 3.0.x
cd ${OPS_HOME}
# "version": "3.0.16-SNAPSHOT"

git clone git@github.com:gravitee-io/gravitee-management-webui
cd gravitee-management-webui
git checkout 3.0.x
cd ${OPS_HOME}
# "version": "3.0.16-SNAPSHOT"

git clone git@github.com:gravitee-io/gravitee-portal-webui
cd gravitee-portal-webui
git checkout 3.0.x
cd ${OPS_HOME}
# "version": "3.0.16-SNAPSHOT"

```


## Gravitee APIM 3.0.16 release

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
export BRANCH="3.0.x"
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
export BRANCH="3.0.x"
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

The release process in non dry run mode successfully compelted in the folowing pipeline execution :

* https://app.circleci.com/pipelines/github/gravitee-io/release/897/workflows/777ed908-0e27-48a0-b1cd-2116a23f7309/jobs/899
* there is an error in this pipeline eecution, but not due to pipeline execution of repo which have failed

There was an incident with `gravitee-management-webui` :

* in artifactory serach `gravitee-management-webui-3.0.16.zip` :
  * in dry run releases repository, the zip is fine, right size
  * in gravitee-releases repository, the zip has an anomaly : it is less than 300Ko
* On Circle CI :
  * the dry run release process, and the release process executed with succcess, both with exactly analogous outputs :
    * Circlec CI release : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-management-webui/870/workflows/97d4f196-f510-4bf9-adb9-677756812a72/jobs/850
    * Circle CI release dry run : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-management-webui/869/workflows/0284ff50-15b1-417b-ab10-ea63d9a57cb8/jobs/849
* the package bundle therefore used this one to publish to https://download.gravitee.io



### 2. Package bundle

#### Process overview

* Running the package bundle requires the git tag to exist : so the maven and git release must be run with dry run mode off (Orchestrator invoked with GNU Option `--dry-run false`)

The package Bundle Entreprise Edition fetches zips from https://download.gravitee.io. That's why we must:
* first execute the package bundle for the Comunity Edition
* then execute the wget script to transfer the zips from the S3 Bucket, to https://download.gravitee.io :

```bash
wget https://raw.githubusercontent.com/gravitee-lab/hugofied-gravitee-docs/feature/first_release/content/cicd-processes/apim/prepared-releases/3.0.16/package_bundles_ce/script.download.gravitee.io.sh -O ./script.download.gravitee.io.sh
chmod +x ./script.download.gravitee.io.sh
mdkir -p /opt/folder_for_test
export BASE_WWW_FOLDER="/opt/folder_for_test"
./script.download.gravitee.io.sh
# we also create the target folders which do not exist in the "/opt/folder_for_test" test folder
./script.download.gravitee.io.sh
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


* To run the package bundle for the Release `3.0.16`, without Entreprise Edition  (**tested OK** , see [this pipeline execution](https://app.circleci.com/pipelines/github/gravitee-io/release/505/workflows/1632b81a-eb26-46eb-9528-68ed7cb818d1/jobs/477), showing that it's the transformation from dist.gravitee.io to download.graavitee.io , formerly done manually, which has an issue )  :

#### Now the process curls

```bash
# export CCI_TOKEN=<your Circle CI Token>

export GRAVITEE_RELEASE_VERSION="3.0.16"
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

* successfully ran the package bundle for APIM CE (after 2 fixes on package bundle ) : https://app.circleci.com/pipelines/github/gravitee-io/release/882/workflows/262f866f-06d5-4cc0-9f63-60993d1f4b71/jobs/885

* To run the package bundle for the Release `3.0.16`, with Entreprise Edition

```bash
# export CCI_TOKEN=<your Circle CI Token>
# the versions for the below dependencies were confirmed at each release time by POs
export GRAVITEE_RELEASE_VERSION="3.0.16"
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

# --
# Will fail at downloading https://download.gravitee.io/graviteeio-apim/distributions/graviteeio-full-3.0.16.zip
# But we have              https://gravitee-releases-downloads.cellar-c2.services.clever-cloud.com/graviteeio-apim/distributions/graviteeio-full-3.0.16.zip
```

Package bundle is completely idempotent : you can run as many times as you want, nothing will ever fail "because it was already done". And the result is always the exact same, unles you change either parameters, or soruce code of the package bundler (NodeJS Python or Circle CI Orb)


python nonetype error :
* analyzed error : https://app.circleci.com/pipelines/github/gravitee-io/release/903/workflows/d3235a3d-05a5-43a6-baf1-106f1123214a/jobs/904
* fixed error : https://app.circleci.com/pipelines/github/gravitee-io/release/904/workflows/91f78624-74cd-4acb-8339-3434a2179c8a/jobs/905


### 3. Nexus staging

beware, there is no dry run for this one

```bash
# export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="release"
export BRANCH="3.0.x"
export GIO_RELEASE_VERSION="3.0.16"
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


* To indivudually relaunch the nexus staging with a `curl`, just for gravitee-gateway :

```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-management-webui"
export BRANCH="3.0.x"
export GIO_RELEASE_VERSION="3.0.16"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"nexus_staging\",
        \"secrethub_org\": \"graviteeio\",
        \"secrethub_repo\": \"cicd\",
        \"s3_bucket_name\": \"prepared-nexus-staging-gravitee-apim-3_0_16\",
        \"maven_profile_id\": \"gravitee-release\"
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```

```Yaml
nexus_staging:
  when:
    equal: [ nexus_staging, << pipeline.parameters.gio_action >> ]
  jobs:
    - gravitee/nexus_staging:
        context: cicd-orchestrator
        secrethub_org: << pipeline.parameters.secrethub_org >>
        secrethub_repo: << pipeline.parameters.secrethub_repo >>
        maven_profile_id: << pipeline.parameters.maven_profile_id >>
        s3_bucket_name: << pipeline.parameters.s3_bucket_name >>
```

* Successful nexus staging :
  * `gravitee-repository` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-repository/118/workflows/0c267964-34ae-47a5-b264-e7699fd86817/jobs/113
  * `gravitee-repository-mongodb` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-repository-mongodb/160/workflows/5f63ea07-c43e-4dda-bab0-3e1d38c99660/jobs/152
  * `gravitee-repository-jdbc` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-repository-jdbc/160/workflows/23dd7526-598c-465f-8f70-6c8e203743f7/jobs/152
  * `gravitee-repository-test` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-repository-test/151/workflows/ee7562cc-7c37-4829-aa6d-356b2360a322/jobs/144
  * `gravitee-portal-webui` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-portal-webui/318/workflows/7b36e801-c0db-43a4-a325-92852f96c996/jobs/292
  * `gravitee-elasticsearch` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-elasticsearch/107/workflows/6c470616-a045-4c99-9484-fcf9fbbf6915/jobs/91
  * `gravitee-gateway` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-gateway/381/workflows/937cadcd-0c3e-4f42-9997-60136fa35425/jobs/356
  * `gravitee-management-webui` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-management-webui/882/workflows/e9739084-b53c-47d3-a9d8-6ebcfafeebb0/jobs/867
  * `gravitee-management-rest-api` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-management-rest-api/946/workflows/a053b807-cf8f-48bf-8ce7-717a02be014a/jobs/921


  #### changelog

  * example for Release `3.0.16`, see [this pipeline execution](cccccc)  :

```bash
export CCI_TOKEN=<your Circle CI Token>
# https://github.com/gravitee-io/issues/milestones
export GIO_MILESTONE_VERSION="APIM - 3.0.16"
export ORG_NAME="gravitee-io"
export REPO_NAME="issues"
# there is only the master git branch on issues repo
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

* and in non dry run when logged CHANGELOG modification is confirmed :) :

```bash
export CCI_TOKEN=<your Circle CI Token>
# https://github.com/gravitee-io/issues/milestones
export GIO_MILESTONE_VERSION="APIM - 3.0.16"
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


## docker images


```bash
# You, will just use your own Circle CI Token
export CCI_TOKEN=<your circle ci personal api token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-docker"
export BRANCH="master"
export BRANCH="feature/cicd-circle-image-builds"
export GRAVITEEIO_VERSION="3.0.16"
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

* https://app.circleci.com/pipelines/github/gravitee-io/gravitee-docker/92/workflows/44a25dc1-e97e-4e48-8fc1-ce6fc30ae6e7/jobs/125
* and another to add minor vesions tags `3.5` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-docker/94/workflows/e5c60e5c-52fd-4351-b1e3-dc900172d303/jobs/126

### RPM Packages `3.0.16`

```bash
export GRAVITEE_RELEASE_VERSION="3.0.16"
export ORG_NAME="gravitee-io"
export REPO_NAME="release"
export BRANCH="3.0.x"
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
# git add --all && git commit -m "CiCd / prepare APIM 3.0.16 release: upgrade gravitee-parent to version 15.1, and [.circleci/config.yml] pipeline def." && git push -u origin HEAD

# ++ if gravitee parent pom is in a 17.x version :
# git add --all && git commit -m "CiCd / prepare APIM 3.0.16 release: upgrade gravitee-parent to version 17.2, and [.circleci/config.yml] pipeline def." && git push -u origin HEAD

# ++ if gravitee parent pom is in a 19.x version :
# git add --all && git commit -m "CiCd / prepare APIM 3.0.16 release: upgrade gravitee-parent to version 19.2, and [.circleci/config.yml] pipeline def." && git push -u origin HEAD

```
