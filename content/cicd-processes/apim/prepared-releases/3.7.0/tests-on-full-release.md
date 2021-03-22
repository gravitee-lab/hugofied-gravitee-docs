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

# POM.XML transition matrix

* 15 => 15.1
* 17.1 => 17.2
* 19 => 19.2.1
* 19.1 => 19.3



## Release 3.7.0 : the B.O.M.

```JSon
{
 "built_execution_plan_is": [
  [],
  [
   {
    "name": "gravitee-repository",
    "version": "3.7.0-SNAPSHOT"
   }
  ],
  [
   {
    "name": "gravitee-repository-test",
    "version": "3.7.0-SNAPSHOT"
   }
  ],
  [
   {
    "name": "gravitee-definition",
    "version": "1.27.0-SNAPSHOT"
   },
   {
    "name": "gravitee-reporter-api",
    "version": "1.20.0-SNAPSHOT"
   },
   {
    "name": "gravitee-repository-mongodb",
    "version": "3.7.0-SNAPSHOT"
   },
   {
    "name": "gravitee-repository-jdbc",
    "version": "3.7.0-SNAPSHOT"
   },
   {
    "name": "gravitee-repository-gateway-bridge-http",
    "version": "3.7.0-SNAPSHOT"
   }
  ],
  [],
  [],
  [],
  [
   {
    "name": "graviteeio-node",
    "version": "1.11.0-SNAPSHOT"
   }
  ],
  [
   {
    "name": "gravitee-gateway",
    "version": "3.7.0-SNAPSHOT"
   }
  ],
  [
   {
    "name": "gravitee-resource-cache",
    "version": "1.5.0-SNAPSHOT"
   }
  ],
  [
   {
    "name": "gravitee-policy-rest-to-soap",
    "version": "1.12.0-SNAPSHOT"
   },
   {
    "name": "gravitee-policy-cache",
    "version": "1.10.0-SNAPSHOT"
   },
   {
    "name": "gravitee-policy-oauth2",
    "version": "1.16.0-SNAPSHOT"
   },
   {
    "name": "gravitee-reporter-file",
    "version": "2.2.0-SNAPSHOT"
   },
   {
    "name": "gravitee-policy-http-signature",
    "version": "1.1.0-SNAPSHOT"
   }
  ],
  [
   {
    "name": "gravitee-management-rest-api",
    "version": "3.7.0-SNAPSHOT"
   },
   {
    "name": "gravitee-management-webui",
    "version": "3.7.0-SNAPSHOT"
   },
   {
    "name": "gravitee-portal-webui",
    "version": "3.7.0-SNAPSHOT"
   }
  ]
 ]
}
```

repo listing :

```bash

git clone git@github.com:gravitee-io/gravitee-repository
# "3.7.0-SNAPSHOT"
git checkout master
git clone git@github.com:gravitee-io/gravitee-repository-test
# "3.7.0-SNAPSHOT"
git checkout master

git clone git@github.com:gravitee-io/gravitee-definition
# "1.27.0-SNAPSHOT"
git checkout master

git clone git@github.com:gravitee-io/gravitee-reporter-api
# "1.20.0-SNAPSHOT"
git checkout master

git clone git@github.com:gravitee-io/gravitee-repository-mongodb
# "3.7.0-SNAPSHOT"
git checkout master

git clone git@github.com:gravitee-io/gravitee-repository-jdbc
# "3.7.0-SNAPSHOT"
git checkout master

git clone git@github.com:gravitee-io/gravitee-repository-gateway-bridge-http
# "3.7.0-SNAPSHOT"
git checkout master

git clone git@github.com:gravitee-io/graviteeio-node
# "1.11.0-SNAPSHOT"
git checkout master

git clone git@github.com:gravitee-io/gravitee-gateway
# "3.7.0-SNAPSHOT"
git checkout master

git clone git@github.com:gravitee-io/gravitee-resource-cache
# "1.5.0-SNAPSHOT"
git checkout master

git clone git@github.com:gravitee-io/gravitee-policy-rest-to-soap
# "1.12.0-SNAPSHOT"
git checkout master

git clone git@github.com:gravitee-io/gravitee-policy-cache
# "1.10.0-SNAPSHOT"
git checkout master

git clone git@github.com:gravitee-io/gravitee-policy-oauth2
# "version": "1.16.0-SNAPSHOT"
git checkout master


git clone git@github.com:gravitee-io/gravitee-reporter-file
# "2.2.0-SNAPSHOT"
git checkout master

git clone git@github.com:gravitee-io/gravitee-policy-http-signature
# "1.1.0-SNAPSHOT"
git checkout master

git clone git@github.com:gravitee-io/gravitee-management-rest-api
# "3.7.0-SNAPSHOT"
git checkout master

git clone git@github.com:gravitee-io/gravitee-management-webui
# "3.7.0-SNAPSHOT"
git checkout master

git clone git@github.com:gravitee-io/gravitee-portal-webui
# "3.7.0-SNAPSHOT"
git checkout master

```

```bash

git clone git@github.com:gravitee-io/gravitee-repository
# "3.7.0-SNAPSHOT" - DONE

git clone git@github.com:gravitee-io/gravitee-repository-test
# "3.7.0-SNAPSHOT" - DONE

git clone git@github.com:gravitee-io/gravitee-definition
# "1.27.0-SNAPSHOT" - DONE

git clone git@github.com:gravitee-io/gravitee-reporter-api
# "1.20.0-SNAPSHOT" - DONE

git clone git@github.com:gravitee-io/gravitee-repository-mongodb
# "3.7.0-SNAPSHOT" - DONE

git clone git@github.com:gravitee-io/gravitee-repository-jdbc
# "3.7.0-SNAPSHOT" - DONE

git clone git@github.com:gravitee-io/gravitee-repository-gateway-bridge-http
# "3.7.0-SNAPSHOT" - DONE

git clone git@github.com:gravitee-io/graviteeio-node
# "1.11.0-SNAPSHOT" - DONE

git clone git@github.com:gravitee-io/gravitee-gateway
# "3.7.0-SNAPSHOT" - DONE

git clone git@github.com:gravitee-io/gravitee-resource-cache
# "1.5.0-SNAPSHOT" - DONE

git clone git@github.com:gravitee-io/gravitee-policy-rest-to-soap
# "1.12.0-SNAPSHOT" - DONE

git clone git@github.com:gravitee-io/gravitee-policy-cache
# "1.10.0-SNAPSHOT" - DONE

git clone git@github.com:gravitee-io/gravitee-policy-oauth2
# "1.16.0-SNAPSHOT" - DONE

git clone git@github.com:gravitee-io/gravitee-reporter-file
# "2.2.0-SNAPSHOT" - DONE

git clone git@github.com:gravitee-io/gravitee-policy-http-signature
# "1.1.0-SNAPSHOT" - DONE

git clone git@github.com:gravitee-io/gravitee-management-rest-api
# "3.7.0-SNAPSHOT" - DONE

git clone git@github.com:gravitee-io/gravitee-management-webui
# "3.7.0-SNAPSHOT" - DONE

git clone git@github.com:gravitee-io/gravitee-portal-webui
# "3.7.0-SNAPSHOT" - DONE


```

Had to release a gravitee-parent `19.2.2` : https://ci2.gravitee.io/job/Release%20Parent/22/console

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
https://app.circleci.com/pipelines/github/gravitee-io/release/828/workflows/6fccaf01-426a-4678-a782-af376b2f5c29/jobs/832

* To run the orchestrated Maven and git release, with dry run mode off :

```bash
# export CCI_TOKEN=<You Circle CI User Personal Token>
# PAS AVANT GO !!!!!
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

The release process in non dry run mode successfully completed in the following pipeline execution :

https://app.circleci.com/pipelines/github/gravitee-io/release/829/workflows/460d69e5-d253-4e47-83ce-de9cf03baa3e/jobs/833


### 2. Package bundle

#### Process overview

* Running the package bundle requires the git tag to exist : so the maven and git release must be run with dry run mode off (Orchestrator invoked with GNU Option `--dry-run false`)

The package Bundle Entreprise Edition fetches zips from https://download.gravitee.io. That's why we must:
* first execute the package bundle for the Comunity Edition
* then execute the wget script to transfer the zips from the S3 Bucket, to https://download.gravitee.io :

```bash
wget https://raw.githubusercontent.com/gravitee-lab/hugofied-gravitee-docs/feature/first_release/content/cicd-processes/apim/prepared-releases/3.7.0/package_bundles_ce/script.download.gravitee.io.sh -O ./script.download.gravitee.io.sh
wget https://raw.githubusercontent.com/gravitee-lab/hugofied-gravitee-docs/feature/first_release/content/cicd-processes/apim/prepared-releases/3.7.0/package_bundles_ce/mkdirs.download.gravitee.io.sh -O ./mkdirs.download.gravitee.io.sh

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

* To run the package bundle for the Release `3.7.0`, without Entreprise Edition  (**tested OK** , see [this pipeline execution](https://app.circleci.com/pipelines/github/gravitee-io/release/505/workflows/1632b81a-eb26-46eb-9528-68ed7cb818d1/jobs/477), showing that it's the transformation from dist.gravitee.io to download.graavitee.io , formerly done manually, which has an issue )  :

#### Now the process curls

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
* succesfully ran the package bundle for Community Edition with this pipeline execution : https://app.circleci.com/pipelines/github/gravitee-io/release/820/workflows/d39d19a6-1fd6-4622-bdcc-d5850e00332d/jobs/824

* To run the package bundle for the Release `3.7.0`, with Entreprise Edition

```bash
# export CCI_TOKEN=<your Circle CI Token>
# the versions for the below dependencies were confirmed at each release time by POs
export GRAVITEE_RELEASE_VERSION="3.7.0"
export AE_VERSION="1.3.0"
# https://github.com/gravitee-io/gravitee-license/tags
export LICENSE_VERSION="1.1.2"
# https://github.com/gravitee-io/gravitee-notifier-slack/tags
export NOTIFIER_SLACK_VERSION="1.0.4"
# https://github.com/gravitee-io/gravitee-notifier-webhook/tags
export NOTIFIER_WEBHOOK_VERSION="1.0.6"
# ---
# https://github.com/gravitee-io/gravitee-notifier-email/tags
# ---
# this one can be infered from release.json with :
# ---
# cat release.json | jq .components | jq --arg COMP_NAME "gravitee-notifier-email" '.[]|select(.name == $COMP_NAME)' | jq .version | awk -F '"' '{print $2}'
# ---
export NOTIFIER_EMAIL_VERSION="1.1.0"
export NOTIFIER_EMAIL_VERSION="1.2.8"


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
# Will fail at downloading https://download.gravitee.io/graviteeio-apim/distributions/graviteeio-full-3.7.0.zip
# But we have              https://gravitee-releases-downloads.cellar-c2.services.clever-cloud.com/graviteeio-apim/distributions/graviteeio-full-3.7.0.zip
```

Package bundle is completely idempotent : you can run as many times as you want, nothing will ever fail "because it was already done". And the result is always the exact same, unles you change either parameters, or soruce code of the package bundler (NodeJS Python or Circle CI Orb)


### 3. Nexus staging

beware, there is no dry run for this one

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

#### Nexus staging results

* Failed jobs (each of them can be relaunched with circle ci web ui re-run button) :
  * [SOLVED] `gravitee-repository` :  failed for unknownb reason... succeeded right after I just relunched it
  * [SOLVED] `gravitee-repository-test`: ... succeeded right after I just relunched it ...failed because the GPG Signing Key Id which was looked up was `319791ef7a93c060` although it is not the GPG Key ID of the GPG key used to sign artifacts... see https://circleci.com/api/v1.1/project/github/gravitee-io/gravitee-repository-test/133/output/103/0?file=true&allocation-id=6058c95b48a4ba591136026f-0-build%2F3941D048
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
  * `gravitee-repository`: https://app.circleci.com/pipelines/github/gravitee-io/gravitee-repository/107/workflows/61c96ae4-6c31-4def-9b03-85ee81ed41d3/jobs/103
  * `gravitee-repository-test`: https://app.circleci.com/pipelines/github/gravitee-io/gravitee-repository-test/143/workflows/414b8e66-4710-4e60-9272-408ba4b7aa35/jobs/134
  * `gravitee-definition`: https://app.circleci.com/pipelines/github/gravitee-io/gravitee-definition/98/workflows/95111d0e-af0d-41f7-909c-9248ef2b9069/jobs/91
  * `gravitee-reporter-api`: https://app.circleci.com/pipelines/github/gravitee-io/gravitee-reporter-api/49/workflows/30e4795e-ba4d-4958-8dd7-2146c5dba777/jobs/51
  * `gravitee-repository-mongodb`: https://app.circleci.com/pipelines/github/gravitee-io/gravitee-repository-mongodb/152/workflows/c7c0b4bf-d288-4cc8-a59f-654ef00b81d3/jobs/142
  * `gravitee-repository-jdbc`: https://app.circleci.com/pipelines/github/gravitee-io/gravitee-repository-jdbc/151/workflows/c99fee3a-3079-4c03-bbad-d3b35c361fff/jobs/141
  * `gravitee-repository-gateway-bridge-http`: https://app.circleci.com/pipelines/github/gravitee-io/gravitee-repository-gateway-bridge-http/93/workflows/636e2c07-2b34-4fd2-bb07-d9d23fae01a4/jobs/84
  * `graviteeio-node`: https://app.circleci.com/pipelines/github/gravitee-io/graviteeio-node/60/workflows/c7fe123e-0752-4c9f-8d62-5015ea4ad2a8/jobs/58
  * `gravitee-gateway`: https://app.circleci.com/pipelines/github/gravitee-io/gravitee-gateway/370/workflows/462d6466-466e-4806-b020-aeb3d730b01e/jobs/345
  * `gravitee-resource-cache`: https://app.circleci.com/pipelines/github/gravitee-io/gravitee-resource-cache/53/workflows/3018b944-aa6b-462f-ab68-9b8ca1ec6e07/jobs/52
  * `gravitee-policy-rest-to-soap`: https://app.circleci.com/pipelines/github/gravitee-io/gravitee-policy-rest-to-soap/61/workflows/5e4ba5e3-0f50-43c7-af86-0e714d1ca0f0/jobs/56
  * `gravitee-policy-cache`:
    * ok so could not publish bersion `1.10.0` because this version already exists in nexus public,
    * search `Artifact updating: Repository =&apos;releases:Releases&apos; does not allow updating artifact=&apos;/io/gravitee/policy/gravitee-policy-cache/1.10.0/gravitee-policy-cache-1.10.0.pom&apos;` in logs : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-policy-cache/62/workflows/7ec18290-e10f-4921-83d7-eb91da426813/jobs/70
    * but still I cannot find this version listed by nexus public : https://search.maven.org/artifact/io.gravitee.policy/gravitee-policy-cache
    * ok but confirmed I could find it in nexus : https://repo.maven.apache.org/maven2/io/gravitee/policy/gravitee-policy-cache/1.10.0/ (and this was not done with APIM release 3.7.0 in circle ci)
  * `gravitee-policy-oauth2`: https://app.circleci.com/pipelines/github/gravitee-io/gravitee-policy-oauth2/70/workflows/61ad7f37-501b-46a5-a275-cf20825d2797/jobs/70
  * `gravitee-reporter-file`:https://app.circleci.com/pipelines/github/gravitee-io/gravitee-reporter-file/54/workflows/87a49f81-919d-4aa2-afdc-6d6d5acdbbb8/jobs/50
  * `gravitee-policy-http-signature`: https://app.circleci.com/pipelines/github/gravitee-io/gravitee-policy-http-signature/13/workflows/1effd007-3159-4e84-8b71-6fb425cc7f2c/jobs/13
  * `gravitee-management-rest-api`: https://app.circleci.com/pipelines/github/gravitee-io/gravitee-management-rest-api/922/workflows/5a78ebc0-2404-43cd-9a36-9df2ac3f116d/jobs/893
  * `gravitee-management-webui`: https://app.circleci.com/pipelines/github/gravitee-io/gravitee-management-webui/860/workflows/740431fe-73b3-4038-b79f-f8a9eec5a4bd/jobs/840
  * `gravitee-portal-webui`: https://app.circleci.com/pipelines/github/gravitee-io/gravitee-portal-webui/311/workflows/dcb4eb16-b58b-49f8-a099-515f7b04b18b/jobs/286

Note :
* it too some time before `gravitee-resource-cache` becomes available on public nexus , see https://repo1.maven.org/maven2/io/gravitee/resource/gravitee-resource-cache/
* that's why i definitely think the best optimiaztion for the nexus staging settings.xml, is that is resolves dependencies from the privte artifactory, and deploys to the public nexus staging
* note quite similar logs than https://stackoverflow.com/questions/50026583/why-my-project-cannot-still-be-found-on-maven-center : so really seems to be a question of time.
* confirmed, it was available after an hour or so : https://repo1.maven.org/maven2/io/gravitee/resource/gravitee-resource-cache/1.5.0/


Most advanced error i had about `gravitee-policy-cache` in logs  https://app.circleci.com/pipelines/github/gravitee-io/gravitee-policy-cache/62/workflows/7ec18290-e10f-4921-83d7-eb91da426813/jobs/70 :

```XML
<stagingProperty>
  <name>failureMessage</name>
  <value>Artifact updating: Repository =&apos;releases:Releases&apos; does not allow updating artifact=&apos;/io/gravitee/policy/gravitee-policy-cache/1.10.0/gravitee-policy-cache-1.10.0-sources.jar&apos;</value>
</stagingProperty>
```





#### changelog

* example for Release `3.7.0`, see [this pipeline execution](cccccc)  :

```bash
export CCI_TOKEN=<your Circle CI Token>
# https://github.com/gravitee-io/issues/milestones
export GIO_MILESTONE_VERSION="APIM - 3.5.8"
export GIO_MILESTONE_VERSION="APIM - 3.7.0"
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

* dry run success :

* and in non dry run when logged CHANGELOG modification is confirmed :) :

```bash
export CCI_TOKEN=<your Circle CI Token>
# https://github.com/gravitee-io/issues/milestones
export GIO_MILESTONE_VERSION="APIM - 3.7.0"
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
export GRAVITEEIO_VERSION="3.7.0"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_product\": \"apim_3x\",
        \"graviteeio_version\": \"${GRAVITEEIO_VERSION}\",
        \"tag_latest\": true,
        \"dry_run\": false
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```

succesfully built images EE and CE :

* https://app.circleci.com/pipelines/github/gravitee-io/gravitee-docker/97/workflows/d78854dd-e574-4cfd-8f26-d1a9092c54d7/jobs/129

### RPM Packages `3.7.0`

```bash
export GRAVITEE_RELEASE_VERSION="3.7.0"
export ORG_NAME="gravitee-io"
export REPO_NAME="release"
export BRANCH="master"
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

successful execution : https://app.circleci.com/pipelines/github/gravitee-io/release/841/workflows/beb11fd0-5c2f-451d-a2ae-78a3d646f439/jobs/844


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
