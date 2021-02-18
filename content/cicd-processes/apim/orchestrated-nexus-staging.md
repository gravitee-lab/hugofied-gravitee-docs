---
title: "Orchestrated Nexus Staging"
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "CI/CD Processes"
menu: apim_processes
menu_index: 3
product: "Gravitee APIM"
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: apim-processes
---

## Process Description

When we have performed a [Gravitee APIM Product Orchestrated Release](/cicd-processes/apim/orchestrated-release/), well we then want to perform the nexus staging part :
* The new Gravitee components maven versions' artifacts are maven deployed to the private artifactory,
* And we want to "push them to the Nexus public repository"
* publishing artifacts to the Nexus public maven repository, is achieved :
  * with a transactional process :
    * for any Gravitee dev repo, if the "nexus staging" operation fails, then it has to be resumed exactly "as if it had never been attempted ".
    * which is why the Nexus public maven repository uses an intermediate repository named "nexus staging" : this git repo is used to persist the state of the nexus staging operation, seen as one global operation on the set of all gravitee components (repos) which have to be published to nexus staging.
  * using the maven pluign named `nexus-staging`
* Each published version of a given maven artifact, to the Nexus public maven repository, is immutable : once you have published it, you cannot "re-plublish". SO basically, one should be very sure of a given artifact version, before publishing it to the maven Nexus public repository


## How to run

* launch the Orchestrated dry run release :

```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="release"
export BRANCH="1.25.x"
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

* launch the Orchestrated release :

```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="release"
export BRANCH="1.25.x"
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


* launch the nexus staging :

```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="release"
export BRANCH="1.25.x"
export GIO_RELEASE_VERSION="1.25.27"
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

* then you can [launch the package bundle](/cicd-processes/apim/package-bundle-zips/)


* delete the s3 Buckets created on Clever Cloud, for the nexus staging :

```bash
export CICD_LIB_OCI_REPOSITORY_ORG=${CICD_LIB_OCI_REPOSITORY_ORG:-"quay.io/gravitee-lab"}
export CICD_LIB_OCI_REPOSITORY_NAME=${CICD_LIB_OCI_REPOSITORY_NAME:-"cicd-s3cmd"}
export S3CMD_CONTAINER_IMAGE_TAG=${S3CMD_CONTAINER_IMAGE_TAG:-"stable-latest"}
export S3CMD_DOCKER="${CICD_LIB_OCI_REPOSITORY_ORG}/${CICD_LIB_OCI_REPOSITORY_NAME}:${S3CMD_CONTAINER_IMAGE_TAG}"

docker pull "${S3CMD_DOCKER}"

# The s3cmd configuration files, which includes the credentials
mkdir -p ./.s3cmd

export SECRETHUB_ORG=graviteeio
export SECRETHUB_REPO=cicd

secrethub read --out-file ./.s3cmd/config "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/infra/zip-bundle-server/clever-cloud-s3/s3cmd/config"

# I need 1 volume : to map the s3cmd config file
docker run -itd --name devops-bubble -v $PWD/.s3cmd/config:/root/.s3cfg "${S3CMD_DOCKER}" bash

export S3_BUCKET_NAME="prepared-nexus-staging-gravitee-apim-4_1_5"
docker exec -it devops-bubble bash -c "s3cmd rb --recursive s3://${S3_BUCKET_NAME}"
export S3_BUCKET_NAME="prepared-nexus-staging-gravitee-apim-4_1_6"
docker exec -it devops-bubble bash -c "s3cmd rb --recursive s3://${S3_BUCKET_NAME}"
export S3_BUCKET_NAME="prepared-nexus-staging-gravitee-apim-4_1_7"
docker exec -it devops-bubble bash -c "s3cmd rb --recursive s3://${S3_BUCKET_NAME}"
export S3_BUCKET_NAME="prepared-nexus-staging-gravitee-apim-4_1_8"
docker exec -it devops-bubble bash -c "s3cmd rb --recursive s3://${S3_BUCKET_NAME}"
export S3_BUCKET_NAME="prepared-nexus-staging-gravitee-apim-4_1_9"
docker exec -it devops-bubble bash -c "s3cmd rb --recursive s3://${S3_BUCKET_NAME}"


export S3_BUCKET_NAME="prepared-nexus-staging-gravitee-apim-4_1_10"
docker exec -it devops-bubble bash -c "s3cmd rb --recursive s3://${S3_BUCKET_NAME}"
export S3_BUCKET_NAME="prepared-nexus-staging-gravitee-apim-4_1_11"
docker exec -it devops-bubble bash -c "s3cmd rb --recursive s3://${S3_BUCKET_NAME}"
export S3_BUCKET_NAME="prepared-nexus-staging-gravitee-apim-4_1_12"
docker exec -it devops-bubble bash -c "s3cmd rb --recursive s3://${S3_BUCKET_NAME}"
export S3_BUCKET_NAME="prepared-nexus-staging-gravitee-apim-4_1_13"
docker exec -it devops-bubble bash -c "s3cmd rb --recursive s3://${S3_BUCKET_NAME}"
export S3_BUCKET_NAME="prepared-nexus-staging-gravitee-apim-4_1_14"
docker exec -it devops-bubble bash -c "s3cmd rb --recursive s3://${S3_BUCKET_NAME}"
export S3_BUCKET_NAME="prepared-nexus-staging-gravitee-apim-4_1_15"
docker exec -it devops-bubble bash -c "s3cmd rb --recursive s3://${S3_BUCKET_NAME}"

```



## Preps

To prepare `1.25.27` support release, I have to execute the following tasks :

* update the `.circleci/config.yml` for the `git@github.com:gravitee-io/release.git` repo, on all its branches
  * `git add --all && git commit -m "feat.(cicd-pipeline): maven and git release, with nexus staging and package bundle" && git push -u origin HEAD`
  * git branches : `master`, and all `*.*.x` git branches and `3.0.0-beta`

* update the `.circleci/config.yml` for the following github repo/branches :
  * `git@github.com:gravitee-io/gravitee-gateway`, for git branches :
    * `1.25.x`
  * `git@github.com:gravitee-io/gravitee-management-rest-api`, for git branches :
    * `1.25.x`
  * `git@github.com:gravitee-io/gravitee-management-webui`, for git branches :
    * `1.25.x`
* for all 3 same repos, pull a new branch from `master`, named `feature/cicd-pipeline` :
  * `git checkout master && git checkout -b feature/cicd-pipeline`
  * `git add --all && git commit -m "feat.(cicd-pipeline): maven and git release, with nexus staging" && git push -u origin HEAD`
  * and create a PR from `feature/cicd-pipeline` to `master`
  * We test on support release `1.25.27`, and if test pass, PR is merged into `master`
  * and people will all have to rebase on `master` to get the new pipeline defintion on their git branch
  * Text of the PR :

<pre>
  New Pipeline Definition, to support "_nexus staging_" new CI CD Operation. So this pipeline brings support for the automation of the following CI CD Operations :
  * maven and git release : maven and git release, `mvn deploy` to private artifactory
  * nexus staging : mvn deploys to nexus staging to publish the artifacts to public Sonatype Nexus maven repository.

  Note :
  * We will test this pipeline definition with support release `1.25.27`
  * when merged in `master`, everyone will get the new pipeline definition on their brach by git rebasing from `master`

</pre>


Create secrethub secrets in the `graviteeio` secrethub org :

* the nexus staging `settings.xml` :

```bash
export SECRETHUB_ORG=graviteeio
export SECRETHUB_REPO=cicd


# those usename and passwords can be
# found in [secrethub read --out-file ./jenkins.release.settings.xml graviteeio/cicd/graviteebot/infra/maven/release/jenkins/settings.xml]
export NEXUS_STAGING_BOT_USER_NAME=inyourdreams;)
export NEXUS_STAGING_BOT_USER_PWD=inyourdreams;)
export GRAVITEEBOT_GPG_PASSPHRASE=$(secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/gpg/passphrase")

# ---
#
cat << EOF >./settings.nexus-staging.xml
<?xml version="1.0" encoding="UTF-8"?>
<!--

    Copyright (C) 2015 The Gravitee team (http://gravitee.io)

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

            http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

-->
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 http://maven.apache.org/xsd/settings-1.0.0.xsd">
  <pluginGroups></pluginGroups>
  <proxies></proxies>
  <servers>
    <server>
      <id>sonatype-nexus-staging</id>
      <username>${NEXUS_STAGING_BOT_USER_NAME}</username>
      <password>${NEXUS_STAGING_BOT_USER_PWD}</password>
    </server>
    <server>
      <!-- as of https://maven.apache.org/plugins/maven-gpg-plugin/usage.html -->
      <id>gpg.passphrase</id>
      <passphrase>${GRAVITEEBOT_GPG_PASSPHRASE}</passphrase>
    </server>
  </servers>
  <!--
  <activeProfiles>
  <activeProfile>gravitee-release</activeProfile>
  </activeProfiles>
  -->
</settings>
EOF

secrethub write --in-file ./settings.nexus-staging.xml "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/infra/maven/settings.nexus-staging.xml"
secrethub read --out-file ./test.settings.nexus-staging.xml "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/infra/maven/settings.nexus-staging.xml"

cat ./test.settings.nexus-staging.xml
rm ./test.settings.nexus-staging.xml

```
* the `s3cmd` config file (containing credentials) :

```bash
export SECRETHUB_ORG=graviteeio
export SECRETHUB_REPO=cicd

secrethub mkdir --parents "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/infra/zip-bundle-server/clever-cloud-s3/s3cmd/"

# Replace the value of CLEVER_CLOUD_DOWNLOAD_LINK_URI with the value you have copied from Clever Cloud Portal Web UI
export CLEVER_CLOUD_DOWNLOAD_LINK_URI="https://cellar-addon-clevercloud-customers.services.clever-cloud.com/s3cfg?token=skWwuXX24netSl%2BQ2rOeXLkd9wsMEEMO0xC6Ht%2FrewDqJN1sjnxbP9heWslE0QFw1mCjFrVuLPdjp039YexRT%2BktRdK6r%2BGze0UDs%2FHyjj2e0eu1AJ%2Biq4p3sd1C7G2jKEJENPmC0UYEBKTxSKodqg%3D%3D%7CIpFcG4Y4C%2FHeKmqh%2FYetW4KlVj9vg0br"
mkdir -p ./.s3cmd
touch ./.s3cmd/config
curl -o ./.s3cmd/config ${CLEVER_CLOUD_DOWNLOAD_LINK_URI}

# storing in the secret manager, the s3cmd configuration file, which includes the credentials, so is a secret file.
secrethub write --in-file ./.s3cmd/config "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/infra/zip-bundle-server/clever-cloud-s3/s3cmd/config"

rm -fr ./.s3cmd

export SECRETHUB_ORG=graviteeio
export SECRETHUB_ORG=gravitee-lab
export SECRETHUB_REPO=cicd

secrethub read --out-file ./.s3cmd.config.test "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/infra/zip-bundle-server/clever-cloud-s3/s3cmd/config"
cat ./.s3cmd.config.test
rm ./.s3cmd.config.test
```


Finally, I will prepare a new `git@github.com:gravitee-io/gravitee-parent.git`, version `19.1` :
* which adds just the `gio-release` maven profile
* git operations :

```bash
git add --all && git commit -m "feat.(cicd): added [gio-release] maven profile used by Circle CI cicd for private artifactory" && git push -u origin HEAD
git tag -s 19.1 -m "[gio-release] maven profile used by Circle CI cicd for private artifactory"
git push -u origin --tags

```
















## Design notes

### Idea for the future implementation

The idea :
* the `nexus-staging` process is meant to be de-correlated, in terms of events, from therelease process : the nexus-staging
* the `nexus-staging` process, like the release process performs operations that will necesarily fail after having succcessfully been completed a first time :
  * the `release` process creates git tags, and once a git tag has been created, the process, while resuming, must not try and create again the same git tag, because it  already exists, and the process will therefore necessarily fail. This is why the resume release feature must "remember" which component has successfully been released, and which has not : to resume the release process only on those components for which the `release` has not yet completed successfully (for each of those components, either the release process has never been started yet, or it has failed)
  * the `nexus-staging` process similarly, performs one operation which can only be done once, successfully : when a given maven artifact, of a given version, has successfully been published to the Nexus public maven repository, it is immutable and trying to publish it again will fail for sure. This is why an orchestrated process which publishes the maven artifacts made from multiple Gravitee Dev github repositories, like the [Gravitee APIM Product Orchestrated Release](/cicd-processes/apim/orchestrated-release/), must "remember" for which Gravitee dev repos, the "Nexus Staging" has already successfully completed.
  * Therefore, the _Orchestrated Nexus Staging_ Process will be implemented extremely similarly to the [Gravitee APIM Product Orchestrated Release](/cicd-processes/apim/orchestrated-release/) :
    * it will trigger a Circle CI Pipeline workflow named `nexus_staging` for each Gravitee Dev repo involved in the release
    * it will use a `nexus-staging.json` file versioned in a git repo https://gihub.com/gravitee-io/nexus-staging, to "remember" which repo the "nexus staging" has successfully completed :  and will "Resume Nexus Staging" safely, without trying to publish again any maven artifacts which has already successfully been published to the Nexus public maven reppsitory, using the `nexus-staging.json` file last commmit on the involved git branch.
    * the `Gravitee CI CD Orchestrator` will run into the Circle CI pipeline defined in the https://gihub.com/gravitee-io/nexus-staging git repo.
  * Now, the last thing we need to know, is how a given [Gravitee APIM Product Orchestrated Release](/cicd-processes/apim/orchestrated-release/) process, will be related to a given [Gravitee APIM Product Orchestrated Nexus Staging](/cicd-processes/apim/orchestrated-nexus-staging/) process :
    * When a [Gravitee APIM Product Orchestrated Release](/cicd-processes/apim/orchestrated-release/) process, reelasing a Gravitee APIM version number `X.Y.Z`, will successfully complete as a whole, it will then push one git commit into the https://github.com/gravitee-io/nexus-stating repo
    * this git commit will :
      * modify only one file, the `nexus-staging.json`
      * the new content of the `nexus-staging.json`, will be exactly be the  exact content of the `release.json` in the https://githhub.com/gravitee-io/release repo, on the git tag `X.Y.Z_start` : in this state, all released `Gravitee` components are marked with the `-SNAPSHOT` suffix, for their `version` JSON property.
      * trigger the `nexus_staging` Circle CI Pipeline workflow, defined inthe https://github.com/gravitee-io/nexus-staging github repo. If it fails, then the user will be able to relaunch it using the Circle CI Web UI "re-run" button.

```Yaml
version: 2.1

parameters:
  gio_action:
    type: enum
    enum: [release, pr_build]
    default: pr_build
  dry_run:
    type: boolean
    default: true
    description: "Run in dry run mode?"
  maven_profile_id:
    type: string
    default: "gravitee-dry-run"
    description: "Maven ID of the Maven profile to use for a dry run ?"
  secrethub_org:
    type: string
    default: "gravitee-lab"
    description: "SecretHub Org to use to fetch secrets ?"
  secrethub_repo:
    type: string
    default: "cicd"
    description: "SecretHub Repo to use to fetch secrets ?"

orbs:
  gravitee: gravitee-io/gravitee@dev:1.0.4

workflows:
  version: 2.1
  pull_requests:
    when:
      equal: [ pr_build, << pipeline.parameters.gio_action >> ]
    jobs:
      - gravitee/pr-build:
          context: cicd-orchestrator
  release:
    # see https://circleci.com/docs/2.0/configuration-reference/#logic-statement-examples
    when:
      and:
        - equal: [ release, << pipeline.parameters.gio_action >> ]
        - not: << pipeline.parameters.dry_run >>
    jobs:
      # return to simple definition :
      - gravitee/release:
          context: cicd-orchestrator
          dry_run: << pipeline.parameters.dry_run >>
          secrethub_org: << pipeline.parameters.secrethub_org >>
          secrethub_repo: << pipeline.parameters.secrethub_repo >>
          maven_profile_id: << pipeline.parameters.maven_profile_id >>
  release_dry_run:
    # see https://circleci.com/docs/2.0/configuration-reference/#logic-statement-examples
    when:
      and:
        - equal: [ release, << pipeline.parameters.gio_action >> ]
        - << pipeline.parameters.dry_run >>
    jobs:
      # return to simple definition :
      - gravitee/release:
          context: cicd-orchestrator
          dry_run: << pipeline.parameters.dry_run >>
          secrethub_org: << pipeline.parameters.secrethub_org >>
          secrethub_repo: << pipeline.parameters.secrethub_repo >>
          maven_profile_id: << pipeline.parameters.maven_profile_id >>
# Nexus Staging
  nexus_staging:
    # see https://circleci.com/docs/2.0/configuration-reference/#logic-statement-examples
    # the gravitee cicd orchestrator will :
    # --> trigger this workflow on each pipeline, given a "nexus-staging.json",
    # --> in a repo versioning the "nexus-staging.json" , and a `.circleci/config.yaml` very siiar to that which versions the "release.json"
    when:
      and:
        - equal: [ nexus_staging, << pipeline.parameters.gio_action >> ]
        - not: << pipeline.parameters.dry_run >>
    jobs:
      # return to simple definition :
      # so maven profile id should be either
      # --> the old "gravitee-release", because it has the configuration for the nexus staging associated to a maven goal
      # --> or any other, becasue anyway the orb job will just execute a maven command to directly execute the maven nexus staging command
      - gravitee/nexus_staging:
          context: cicd-orchestrator
          dry_run: << pipeline.parameters.dry_run >>
          secrethub_org: << pipeline.parameters.secrethub_org >>
          secrethub_repo: << pipeline.parameters.secrethub_repo >>
          maven_profile_id: << pipeline.parameters.maven_profile_id >>
          git_release_tag: << pipeline.parameters.git_release_tag >>

  standalone_release_dry_run:
    # see https://circleci.com/docs/2.0/configuration-reference/#logic-statement-examples
    when:
      and:
        - equal: [ standalone_release_dry_run, << pipeline.parameters.gio_action >> ]
        - << pipeline.parameters.dry_run >>
    jobs:
      # The "standalone_gravitee_mvn_release" job will explicitly be defined in this ".circleci/config.yaml" :
      # -> it will execute Orb commands
      - standalone_gravitee_mvn_release:
          context: cicd-orchestrator
          dry_run: << pipeline.parameters.dry_run >>
          secrethub_org: << pipeline.parameters.secrethub_org >>
          secrethub_repo: << pipeline.parameters.secrethub_repo >>
          maven_profile_id: << pipeline.parameters.maven_profile_id >>
      - gravitee/nexus_staging:
          requires:
            - standalone_gravitee_mvn_release
          context: cicd-orchestrator
          dry_run: << pipeline.parameters.dry_run >>
          secrethub_org: << pipeline.parameters.secrethub_org >>
          secrethub_repo: << pipeline.parameters.secrethub_repo >>
          maven_profile_id: << pipeline.parameters.maven_profile_id >>
          git_release_tag: << pipeline.parameters.git_release_tag >>

```


## Design of the gravitee Orb

A new Gravitee Circle CI Orb Job will be implemented and used in every Gravitee dev repository 's `.circleci/config.yml` :
* it will be named `gravitee/nexus_staging`
* it will take the 4 `dry_run`, `secrethub_org`, `secrethub_repo`, `maven_profile_id` Orb Job parameters, just like the `gravitee/release` Orb Job :
  * `dry_run` : a nexus staging can be exeucted in dryrun mode (define then what happens, perhaps just outputin what artifact will be published, also just download the artifact from the private artifactory, to check that it is properly resolved, but this time from the gravitee-dry-run artifactory maven repository, not the gravitee-relase, thanks to the `settings.xml` configuration resolved differentlyin dry run mode... also jsut checkout the login to the maven nexus repository, without any other further operation against the nexus staging maven repo)
  * `secrethub_org` : to resolve required secrets from the secret manager such as the nexus credentials
  * `secrethub_repo` : to resolve required secrets from the secret manager such as the nexus credentials
  * `maven_profile_id` : the maven profile to use to run all maven commands.
* it will take one additional Orb Job parameter, named `git_release_tag` :
  * the git tag marking the git release,
  * which will have as default value the `"LAST_GIT_TAG_ON_CURRENT_BRANCH"` : this will make this Orb Job reusable also for the [Gravitee APIM Product Standalone Nexus Staging](/cicd-processes/apim/standalone-nexus-staging/) process. Indeed, if this Orb job paramter  is the `"LAST_GIT_TAG_ON_CURRENT_BRANCH"` string, then the pipeline will determine the name of the last git tag on the current git branch.
  * the orchestrator will "know" which value to  use for each component, absed on the `version` JSON property for each component in the `nexus-staging.json` (those `components` which `version` JSON property is  marked with the `-SNAPSHOT` suffix)
* it will :
  * git checkout the git tag based on the value of the `git_release_tag` Orb Job Parameter.
  * execute a first maven command, to "just download the maven artifact from the private artifactory" : some maven plugins allow to do that, without running anything but downloading the maven artifact
  * it will execute  second maven command to execute the maven `nexus-staging` plugin

## Misc. Characteristics
