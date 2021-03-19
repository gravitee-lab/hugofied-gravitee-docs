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

## Release 3.5.8 : the B.O.M.

```JSon
{
 "built_execution_plan_is": [
  [],
  [],
  [],
  [
   {
    "name": "gravitee-repository-gateway-bridge-http",
    "version": "3.5.4-SNAPSHOT"
   }
  ],
  [],
  [],
  [],
  [],
  [
   {
    "name": "gravitee-gateway",
    "version": "3.5.8-SNAPSHOT"
   }
  ],
  [],
  [
   {
    "name": "gravitee-policy-rest-to-soap",
    "version": "1.11.1-SNAPSHOT"
   }
  ],
  [
   {
    "name": "gravitee-management-rest-api",
    "version": "3.5.8-SNAPSHOT"
   },
   {
    "name": "gravitee-management-webui",
    "version": "3.5.8-SNAPSHOT"
   },
   {
    "name": "gravitee-portal-webui",
    "version": "3.5.8-SNAPSHOT"
   }
  ]
 ]
}
```

## Gravitee APIM 3.5.8 release

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
export BRANCH="3.5.x"
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
export BRANCH="3.5.x"
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

https://app.circleci.com/pipelines/github/gravitee-io/release/793/workflows/aa28d9c6-f6e2-4474-9c60-37f78e02bcd5/jobs/801


### 2. Package bundle

#### Process overview

* Running the package bundle requires the git tag to exist : so the maven and git release must be run with dry run mode off (Orchestrator invoked with GNU Option `--dry-run false`)

The package Bundle Entreprise Edition fetches zips from https://download.gravitee.io. That's why we must:
* first execute the package bundle for the Comunity Edition
* then execute the wget script to transfer the zips from the S3 Bucket, to https://download.gravitee.io :

```bash
wget https://raw.githubusercontent.com/gravitee-lab/hugofied-gravitee-docs/feature/first_release/content/cicd-processes/apim/prepared-releases/3.5.8/package_bundles_ce/script.download.gravitee.io.sh -O ./script.download.gravitee.io.sh
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


* To run the package bundle for the Release `3.5.8`, without Entreprise Edition  (**tested OK** , see [this pipeline execution](https://app.circleci.com/pipelines/github/gravitee-io/release/505/workflows/1632b81a-eb26-46eb-9528-68ed7cb818d1/jobs/477), showing that it's the transformation from dist.gravitee.io to download.graavitee.io , formerly done manually, which has an issue )  :

#### Now the process curls

```bash
# export CCI_TOKEN=<your Circle CI Token>

export GRAVITEE_RELEASE_VERSION="3.5.8"
export ORG_NAME="gravitee-io"
export REPO_NAME="release"
export BRANCH="3.5.x"
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

* To run the package bundle for the Release `3.5.8`, with Entreprise Edition

```bash
# export CCI_TOKEN=<your Circle CI Token>
# the versions for the below dependencies were confirmed at each release time by POs
export GRAVITEE_RELEASE_VERSION="3.5.8"
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
export BRANCH="3.5.x"
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
# Will fail at downloading https://download.gravitee.io/graviteeio-apim/distributions/graviteeio-full-3.5.8.zip
# But we have              https://gravitee-releases-downloads.cellar-c2.services.clever-cloud.com/graviteeio-apim/distributions/graviteeio-full-3.5.8.zip
```

Package bundle is completely idempotent : you can run as many times as you want, nothing will ever fail "because it was already done". And the result is always the exact same, unles you change either parameters, or soruce code of the package bundler (NodeJS Python or Circle CI Orb)


### 3. Nexus staging

beware, there is no dry run for this one

```bash
# export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="release"
export BRANCH="3.5.x"
export GIO_RELEASE_VERSION="3.5.8"
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
  * [SOLVED] https://app.circleci.com/pipelines/github/gravitee-io/gravitee-repository-gateway-bridge-http/78/workflows/6d4ff5fb-c6d2-40b7-819f-74c4c46a416a/jobs/69 : because of a problem wuth secrethub orb.. Just Relaunched it and it was successful
  * [SOLVED] https://app.circleci.com/pipelines/github/gravitee-io/gravitee-management-webui/834/workflows/cb31a3c1-1b4d-49b9-8d53-3a9cae9cdcb3/jobs/814 : missing license headers because gravitee license plugin configuration does not ignore the `node/` folder (which contains the npm project, and the `node_modules` folder). https://github.com/gravitee-io/gravitee-management-webui/blob/a5ad8d78606ef1c51c60ec0d98f1826a265e4718/pom.xml#L71 . This one I can solve by editing the pom.xml in the S3 Bucket.
  * [SOLVED] https://app.circleci.com/pipelines/github/gravitee-io/gravitee-gateway/344/workflows/461583c2-5284-430b-ba12-23830429d609/jobs/316 :  real strange error for this one permission denied for a mysterious executable :
    * closest github issues found :
      * https://github.com/google/protobuf-gradle-plugin/issues/165
      * https://stackoverflow.com/questions/39331665/permission-denied-for-protoc-on-maven-build-in-teamcity
    * By resetting permissions on files (exec permission on exucatable, read permission on all project files), and also docker priviledged contaienr, I had [a change](https://app.circleci.com/pipelines/github/gravitee-io/gravitee-gateway/347/workflows/91d5881c-7f8a-41fa-88de-40a5c7812b23/jobs/321) :
      * this time the problem is that "protoc did not exit cleanly"
      * here is my new error : `[ERROR] PROTOC FAILED: /usr/src/giomaven_project/gravitee-gateway-standalone/gravitee-gateway-standalone-container/target/protoc-plugins/protoc-gen-grpc-java-1.25.0-linux-x86_64.exe: program not found or is not executable
Please specify a program using absolute path or make sure the program is available in your PATH system variable`
      * this new eror is about a new executable file which needs exec permissions. After chmod +x on this file issue was solved.
      * last : what happened here : while pushing to s3 bucket those executables, `s3cmd` removed their exec permissions for s3 storage security. My guess at least.

<pre>
An error occurred while invoking protoc: Error while executing process. Cannot run program "/usr/src/giomaven_project/gravitee-gateway-standalone/gravitee-gateway-standalone-container/target/protoc-plugins/protoc-3.12.2-linux-x86_64.exe": error=13, Permission denied -> [Help 1]
</pre>

* To indivudually relaunch the nexus staging with a `curl`, just for gravitee-gateway :

```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-gateway"
export BRANCH="3.5.x"
export GIO_RELEASE_VERSION="3.5.8"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"nexus_staging\",
        \"secrethub_org\": \"graviteeio\",
        \"secrethub_repo\": \"cicd\",
        \"s3_bucket_name\": \"prepared-nexus-staging-gravitee-apim-3_5_8\",
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
  * `gravitee-policy-rest-to-soap` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-policy-rest-to-soap/54/workflows/6e63041f-4695-4401-be13-367f20181f90/jobs/49
  * `gravitee-portal-webui` :  https://app.circleci.com/pipelines/github/gravitee-io/gravitee-portal-webui/295/workflows/e5e64717-dba0-4523-b6c7-1fcb16efab19/jobs/272
  * `gravitee-repository-gateway-bridge-http` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-repository-gateway-bridge-http/78/workflows/23abe867-1c63-46ce-9e41-b2697e05be2b/jobs/70
  * `gravitee-management-rest-api` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-management-rest-api/895/workflows/9ba6b428-4203-4647-bc21-da90b2f66073/jobs/867
  * `gravitee-management-webui` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-management-webui/834/workflows/85b724f9-057b-47a4-b5bc-eec11ae5dcce/jobs/816
  * `gravitee-gateway` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-gateway/349/workflows/f84e849b-f17f-4941-82ef-146101ec5a1e/jobs/323

  #### changelog

  * example for Release `3.5.8`, see [this pipeline execution](cccccc)  :

```bash
export CCI_TOKEN=<your Circle CI Token>
# https://github.com/gravitee-io/issues/milestones
export GIO_MILESTONE_VERSION="APIM - 3.5.8"
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

* and in non dry run when logged CHANGELOG modification is confirmed :) :

```bash
export CCI_TOKEN=<your Circle CI Token>
# https://github.com/gravitee-io/issues/milestones
export GIO_MILESTONE_VERSION="APIM - 3.5.8"
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
export GRAVITEEIO_VERSION="3.5.8"
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

### RPM Packages `3.5.8`

```bash
export GRAVITEE_RELEASE_VERSION="3.5.8"
export ORG_NAME="gravitee-io"
export REPO_NAME="release"
export BRANCH="3.5.x"
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
# git add --all && git commit -m "CiCd / prepare APIM 3.5.8 release: upgrade gravitee-parent to version 15.1, and [.circleci/config.yml] pipeline def." && git push -u origin HEAD

# ++ if gravitee parent pom is in a 17.x version :
# git add --all && git commit -m "CiCd / prepare APIM 3.5.8 release: upgrade gravitee-parent to version 17.2, and [.circleci/config.yml] pipeline def." && git push -u origin HEAD

# ++ if gravitee parent pom is in a 19.x version :
# git add --all && git commit -m "CiCd / prepare APIM 3.5.8 release: upgrade gravitee-parent to version 19.2, and [.circleci/config.yml] pipeline def." && git push -u origin HEAD

```
