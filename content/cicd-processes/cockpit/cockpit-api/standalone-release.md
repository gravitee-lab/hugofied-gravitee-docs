---
title: "Standalone (Replay) Release"
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


## The Standalone release process

The Purpose is to be able to "release" any github repo, "alone": out of the context of any Gravitee APIM orchestrated release.

This process is very important, among other cases, because it can quickly solve a problem of circular dependencies across repositories

Finally note that I wanted to also bring the ability to "replay" releases. I will bring this ability, first, in the context of a _Standalone_ release, and it will be provided later, in the context of an orchestrated release.



#### Before you start : your need your Circle CI API Token

To execute every step of the release process, you will need something from circle CI : a Personal API Token.

Here is how you can get one :
* log into Circle CI at https://app.circleci.com with github authentication. Grant access to `gravitee-io` Github Org.
* Go to your Use settings menu : bottom left corner icon
* Then go to the  _**"Personal API Tokens"**_ menu, and click the "Create new Token" button.
* Keep the value of your token, you will need it at each step.


## Launch the Standalone Release


#### With dry run mode ON

```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-cockpit-api"
# on master branch for a major release
export BRANCH="master"
# on a "*.*.x" branch for a support release
export BRANCH="9.3.x"
export BRANCH="cicd/respawned-pipeline"
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

When launched, no Nexus Staging Workflow will be triggered :

![Standalone Release Dry run](https://github.com/gravitee-io/gravitee-circleci-orbinoid/raw/develop/orb/src/scripts/nexus-staging/docker-executors/standalone/images/standalone_release_0.png)

#### With dry run mode OFF (immutable!)

```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-cockpit-api"
# on master branch for a major release
export BRANCH="master"
# on a "*.*.x" branch for a support release
export BRANCH="9.3.x"
export BRANCH="cicd/respawned-pipeline"
# IMPORTANT ! Name of Maven profile defines in which Artifactory repo the mvn deploys sends
export MAVEN_PROFILE_ID="gio-release"
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

When launched, A Nexus Staging Workflow will be triggered, and will hold 2 jobs in a row :
* The Nexus staging with dry run mode on, which you will approve only when the `maven_n_git_release` job has successfully completed (because then the maven project will be available in an S3 Bucket, "frozen", ready to be used by the maven staging). When you will approve it, it will complete its execution without releasing your project to the Public Sonatype Nexus "Maven Central"
* The Nexus staging with dry run mode off, which you will approve only when Nexus staging with dry run mode on, has completed without error(s) (this ensures everything is fine for the nexus staging). When you will approve it, it will complete its execution without releasing your project to the Public Sonatype Nexus "Maven Central"

![Standalone Release Dry run mode off](https://github.com/gravitee-io/gravitee-circleci-orbinoid/raw/develop/orb/src/scripts/nexus-staging/docker-executors/standalone/images/standalone_release_1.png)

![Standalone Release Dry run mode off](https://github.com/gravitee-io/gravitee-circleci-orbinoid/raw/develop/orb/src/scripts/nexus-staging/docker-executors/standalone/images/standalone_release_2.png)

![Standalone Release Dry run mode off](https://github.com/gravitee-io/gravitee-circleci-orbinoid/raw/develop/orb/src/scripts/nexus-staging/docker-executors/standalone/images/standalone_release_3.png)

![Standalone Release Dry run mode off](https://github.com/gravitee-io/gravitee-circleci-orbinoid/raw/develop/orb/src/scripts/nexus-staging/docker-executors/standalone/images/standalone_release_4.png)



## Launch the Standalone Release Replay


#### With dry run mode ON

* without specifying the `S3_BUCKET_NAME` :

```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-cockpit-api"
# on a "*.*.x" branch for a support release
export BRANCH="9.3.x"
# on master branch for a major release
export BRANCH="master"
export BRANCH="cicd/respawned-pipeline"
# IMPORTANT ! Name of Maven profile defines in which Artifactory repo the mvn deploys sends
export MAVEN_PROFILE_ID="gravitee-dry-run"
export REPLAYED_RELEASE="0.1.0"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"standalone_release_replay\",
        \"maven_profile_id\": \"${MAVEN_PROFILE_ID}\",
        \"replayed_release\": \"${REPLAYED_RELEASE}\",
        \"dry_run\": true
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```

When launched, no Nexus Staging Workflow will be triggered :

![Standalone Release Dry run](https://github.com/gravitee-io/gravitee-circleci-orbinoid/raw/develop/orb/src/scripts/nexus-staging/docker-executors/standalone/images/standalone_release_0.png)

* One can also trigger the  Standalone Release Replay By specifying the `S3_BUCKET_NAME` (do not use unless there is a very good reason for that) :

```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-cockpit-api"
# on a "*.*.x" branch for a support release
export BRANCH="9.3.x"
# on master branch for a major release
export BRANCH="master"
export BRANCH="cicd/respawned-pipeline"
# IMPORTANT ! Name of Maven profile defines in which Artifactory repo the mvn deploys sends
export MAVEN_PROFILE_ID="gravitee-dry-run"
export REPLAYED_RELEASE="0.1.0"
export MAJOR_VERSION=$(echo "${REPLAYED_RELEASE}" | awk -F '.' '{print $1}')
export MINOR_VERSION=$(echo "${REPLAYED_RELEASE}" | awk -F '.' '{print $2}')
export PATCH_VERSION=$(echo "${REPLAYED_RELEASE}" | awk -F '.' '{print $3}')
export S3_BUCKET_NAME="prepared-standalone-nexus-staging-gravitee-cockpit-api-${MAJOR_VERSION}_${MINOR_VERSION}_${PATCH_VERSION}"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"standalone_release_replay\",
        \"maven_profile_id\": \"${MAVEN_PROFILE_ID}\",
        \"s3_bucket_name\": \"${S3_BUCKET_NAME}\",
        \"replayed_release\": \"${REPLAYED_RELEASE}\",
        \"dry_run\": true
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```

#### With dry run mode OFF (immutable!)



* without specifying the `S3_BUCKET_NAME` :

```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-cockpit-api"
# on a "*.*.x" branch for a support release
export BRANCH="9.3.x"
# on master branch for a major release
export BRANCH="master"
export BRANCH="cicd/respawned-pipeline"
# IMPORTANT ! Name of Maven profile defines in which Artifactory repo the mvn deploys sends
export MAVEN_PROFILE_ID="gio-release"
export REPLAYED_RELEASE="0.1.0"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"standalone_release_replay\",
        \"maven_profile_id\": \"${MAVEN_PROFILE_ID}\",
        \"replayed_release\": \"${REPLAYED_RELEASE}\",
        \"dry_run\": false
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```
When launched, A Nexus Staging Workflow will be triggered, and will hold 2 jobs in a row :
* The Nexus staging with dry run mode on, which you will approve only when the `maven_n_git_release` job has successfully completed (because then the maven project will be available in an S3 Bucket, "frozen", ready to be used by the maven staging). When you will approve it, it will complete its execution without releasing your project to the Public Sonatype Nexus "Maven Central"
* The Nexus staging with dry run mode off, which you will approve only when Nexus staging with dry run mode on, has completed without error(s) (this ensures everything is fine for the nexus staging). When you will approve it, it will complete its execution without releasing your project to the Public Sonatype Nexus "Maven Central"



* One can also trigger the  Standalone Release Replay By specifying the `S3_BUCKET_NAME` (do not use unless there is a very good reason for that) :

```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-cockpit-api"
# on a "*.*.x" branch for a support release
export BRANCH="9.3.x"
# on master branch for a major release
export BRANCH="master"
export BRANCH="cicd/respawned-pipeline"
# IMPORTANT ! Name of Maven profile defines in which Artifactory repo the mvn deploys sends
export MAVEN_PROFILE_ID="gio-release"
export REPLAYED_RELEASE="0.1.0"
export MAJOR_VERSION=$(echo "${REPLAYED_RELEASE}" | awk -F '.' '{print $1}')
export MINOR_VERSION=$(echo "${REPLAYED_RELEASE}" | awk -F '.' '{print $2}')
export PATCH_VERSION=$(echo "${REPLAYED_RELEASE}" | awk -F '.' '{print $3}')
export S3_BUCKET_NAME="prepared-standalone-nexus-staging-gravitee-cockpit-api-${MAJOR_VERSION}_${MINOR_VERSION}_${PATCH_VERSION}"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"standalone_release_replay\",
        \"maven_profile_id\": \"${MAVEN_PROFILE_ID}\",
        \"s3_bucket_name\": \"${S3_BUCKET_NAME}\",
        \"replayed_release\": \"${REPLAYED_RELEASE}\",
        \"dry_run\": false
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```
