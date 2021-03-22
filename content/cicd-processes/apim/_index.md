---
title: "Gravitee APIM CI/CD Processes"
date: 2020-12-16T00:44:23+01:00
draft: false
menu_index: 1
showChildrenInMenu : true
nav_menu: "CI/CD Processes"
type: apim-processes
---

In this page, you will find a full step by step procedure for APIM Release

## Process Description

Here are the steps :
* 0. [A kind of (magic) Release](#0-a-kind-of-magic-release)
* 1. [The Orchestrated Maven and Git release](#1-orchestrated-maven-and-git-release)
* can be run in parallel :
  * 2. [Package n publish zip bundles](#2-package-bundle)
  * 3. [nexus-staging](3-nexus-staging)
* can be run in parallel :
  * 4. [changelog](#4-changelog)
  * 5. [Docker images CE and EE](#5-docker-images)
  * 6. [Publish `rpm` packages](#6-rpm-packages)
  * 7. [continuous delivery of https://docs.gravitee.io](#7-publish-documentation)

  #### Before you start : your need your Circle CI API Token

  To execute every step of the release process, you will need something from circle CI : a Personal API Token.

  Here is how you can get one :
  * log into Circle CI at https://app.circleci.com with github authentication. Grant access to `gravitee-io` Github Org.
  * Go to your Use settings menu : bottom left corner icon
  * Then go to the  _**"Personal API Tokens"**_ menu, and click the "Create new Token" button.
  * Keep the value of your token, you will need it at each step.


  ## 0. A kind of (magic) Release

  You will release a given version of APIM.

  Releasing APIM is a process which consists of performing one process on a multitude of github repositories in the https://github.com/gravitee-io Github Organization.

  This one process to be performed on many repositories in the https://github.com/gravitee-io Github Organization, can itself, be called a release process.

  Now:
  * let us choose a given repository in the https://github.com/gravitee-io Github Organization,
  * and let's imagine we want to perform a given release  `A.B.C` be the release version number

  Whatever the release version number is, you will be in one of the two following cases :
  * If `C` is zero, then:
    * this release is a major release
    * and the source code which will be used to perform the release will will be the latest commit on the `master` git branch.
  * If `C` is not zero, then:
    * this is a support release.
    * and the source code which will be used to perform the release will be the latest commit on the `A.B.x` git branch.

  For example :
  * if release version number is `7.8.4`, then this is a support release , and the source code to use will be the latest commit on the `7.8.x` git branch.
  * if release version number is `11.5.0`, then this is a major release , and the source code to use will be the latest commit on the `master` git branch.

  Now that you know that, you have what you need to understand everything the release process does.

  The steps of the release process consists of:
  * running a few maven commands on the source code : those maven commands modify some files of the source code, mainly the `pom.xml` files.
  * then the modified source code is git committed and git pushed on the same git branch the source code orginated from.
  * and then a git tag is added on the git pushed commit. this git tag is named after the release version number.

  This first step consists of executing a new CI CD component, called the "Orchestrator" :
  * The Orchestrator is a software developed by the devops team, and designed to run in the Circle CI pipeline of the https://github.com/gravitee-io/release repository.
  * The Orchestrator as a software, knows how to perform the release process for each github repository, as described above.


  _**In all Below APIM release steps, we note `M.N.P` the release version number of the APIM release you need to perform.**_



  ## 1. Orchestrated Maven and git release

  Now, the Orchestrator has a GNU option, called "dry run mode".

  In this first step, you will :
  * Run the Orchestrator with dry run mode on:
    * with dry run mode on, no modifications will happen in any git repository
    * in the logs of this first execution, you will find the "execution plan". You will find it by searching the string `built_execution_plan_is` in the logs.
    * this execution plan gives the fill list of all github repositoruies which will be involved into the APIM release
    * communicate the execution plan to the dev or support team on slack, to confirm the list of github repositories involved int he APIM release.
  * Run the Orchestrator with dry run mode off :
    * this time the release process will git push the commit and the git tag
    * at the end of the process, all the maven artifacts (jars and zips), will be is a private ARtifafcory server owned by Gravitee, only accessible by the gravitee team members.



  * To run the orchestrated Maven and git release, with dry run mode on :

  ```bash
  # export CCI_TOKEN=<You Circle CI User Personal Token>

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
          \"gio_action\": \"release\"
      }

  }"

  curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
  curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
  ```

  Here below, you can see the execution plan displayed in the logs of the Orchestrator, for the `3.6.1` APIM release:

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


  ## 2. Package bundle

  #### Process overview

  * Running the package bundle requires the git tag to exist : so the maven and git release must be run with dry run mode off (Orchestrator invoked with GNU Option `--dry-run false`)

  The package Bundle Entreprise Edition fetches zips from https://download.gravitee.io. That's why we must:
  * first execute the package bundle for the Community Edition. The logs of the execution of this process, end by displaying the source code of two shell scripts :
    * the first only creates folders : copy the source code of this one in a shell script file named `./mkdirs.download.gravitee.io.sh`
    * the second only downloads the bundled zips : copy the source code of this one in a shell script file named `./script.download.gravitee.io.sh`
  * then execute those two shell scripts like this :

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
  # If [/opt/folder_for_test] has the expected tree structure, the proceed
  # ---
  # And the we can run again with the path of the foler actually served by the https://download.gravitee.io server
  # Can't check that but I thin k the path is :
  # export BASE_WWW_FOLDER="/opt/dist/download. .io"
  # ---
  #
  export BASE_WWW_FOLDER="/opt/dist/download.gravitee.io"
  ./script.download.gravitee.io.sh
  # we do not create the target folders inthe real www folder : they should already exist
  # this is why we do not execute the [./mkdirs.download.gravitee.io.sh] shell script against
  # the folder actually served as static content, by the https://download.gravitee.io server : those target folders are assumed to already exist

  ```

  * and finally run the packge bundle for the Entreprise Edition. You will need to ask the dev or support team the version of the components bundled with APIM Entrerpise Edition :
    * what is the version of Alert Engine
    * what is the the version of the Gravitee License
    * what is the version of Notifier Slack
    * what is the version of Notifier Webhook
    * what is the version of Notifier Email


  #### Now the `curl`s

  * To run the package bundle for the APIM Release `M.N.P`, without Entreprise Edition :

  ```bash
  export CCI_TOKEN=<your Circle CI Token>

  export GRAVITEE_RELEASE_VERSION="3.6.1"
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
          \"with_ee\": false
      }

  }"

  curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
  curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
  ```

  * To run the package bundle for the Release `M.N.P`, with Entreprise Edition, execute:

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

  Package bundle is completely idempotent : you can run as many times as you want, nothing will ever fail "because it was already done". And the result is always the exact same, unles you change either parameters, or soruce code of the package bundler (NodeJS Python or Circle CI Orb)

  ## 3. Nexus staging


  Once the Orchestrated maven and git release is complete, no maven artifact is published to the public nexus repository.

  The Nexus Staging process publishes all maven artifacts of a given APIM release verison, to the public Nexus repository.

  Beware : there is no dry run mode for this step

  ```bash
  # export CCI_TOKEN=<you circle ci token>
  export ORG_NAME="gravitee-io"
  export REPO_NAME="release"
  export GIO_RELEASE_VERSION="M.N.P"
  # if P is zero, than the git branch will be master
  export BRANCH="master"
  # if P is not zero, than the git branch will be M.N.x
  export BRANCH="M.N.x"

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

  * You may relaunch any nexus staging for any given repository :
    * using the Circle CI "re-run" button
    * or with a `curl`, for example, to (re-)launch the nexus staging for the https://github.com/gravitee-io/gravitee-reporter-file repository, for release version `M.N.P`. To do that, you will need to get what is the release version number for that repository, from the execution plan built at the _**"Orchestrated Maven and Git release"**_ step :

  ```bash
  export CCI_TOKEN=<you circle ci token>
  export ORG_NAME="gravitee-io"
  export REPO_NAME="gravitee-reporter-file"
  # if P is zero, than the git branch will be master
  export BRANCH="master"
  # if P is not zero, than the git branch will be M.N.x
  export BRANCH="M.N.x"
  export RELEASE_VERSION="M.N.P"
  export RELEASE_MAJOR_VERSION=$(echo "${RELEASE_VERSION}" | awk -F '.' '{print $1}')
  export RELEASE_MINOR_VERSION=$(echo "${RELEASE_VERSION}" | awk -F '.' '{print $2}')
  export RELEASE_PATCH_VERSION=$(echo "${RELEASE_VERSION}" | awk -F '.' '{print $3}')

  export JSON_PAYLOAD="{

      \"branch\": \"${BRANCH}\",
      \"parameters\":

      {
          \"gio_action\": \"nexus_staging\",
          \"secrethub_org\": \"graviteeio\",
          \"secrethub_repo\": \"cicd\",
          \"s3_bucket_name\": \"prepared-nexus-staging-gravitee-apim-${RELEASE_MAJOR_VERSION}_${RELEASE_MINOR_VERSION}_${RELEASE_PATCH_VERSION}\",
          \"maven_profile_id\": \"gravitee-release\"
      }

  }"

  curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
  curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
  ```





  ## 4. changelog

  This process requires that a Gihtub milestone has been created, and closed, in the https://github.com/gravitee-io/issues repo, and that its name is `APIM - ${GIO_RELEASE_VERSION}`, where `GIO_RELEASE_VERSION` is the released version of `APIM`

  The changelog process :
  * generates the CHANGELOG for a given release : it generates a text
  * adds it to a changelog text file, versioned in the https://github.com/gravitee-io/issues git repository
  * and git commits and push the mdofied changelog text file into  the https://github.com/gravitee-io/issues git repository

  * example for APIM Release `3.6.1`, with dry run mode on :

  ```bash
  export CCI_TOKEN=<your Circle CI Token>
  export GIO_MILESTONE_VERSION="APIM - 3.5.8"
  export GIO_MILESTONE_VERSION="APIM - 3.6.1"
  # https://github.com/gravitee-io/issues/milestones
  export RELEASE_VERSION="M.N.P"
  export RELEASE_MAJOR_VERSION=$(echo "${RELEASE_VERSION}" | awk -F '.' '{print $1}')
  export RELEASE_MINOR_VERSION=$(echo "${RELEASE_VERSION}" | awk -F '.' '{print $2}')
  export RELEASE_PATCH_VERSION=$(echo "${RELEASE_VERSION}" | awk -F '.' '{print $3}')
  export GIO_MILESTONE_VERSION="APIM - ${RELEASE_MAJOR_VERSION}.${RELEASE_MINOR_VERSION}.${RELEASE_PATCH_VERSION}"

  export ORG_NAME="gravitee-io"
  export REPO_NAME="issues"
  # always use the master git branch, regardless of the release version number
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

  * and with dry run mode off, when logged CHANGELOG modification is confirmed :

  ```bash
  export CCI_TOKEN=<your Circle CI Token>
  # https://github.com/gravitee-io/issues/milestones
  export GIO_MILESTONE_VERSION="APIM - 3.6.1"
  export RELEASE_VERSION="M.N.P"
  export RELEASE_MAJOR_VERSION=$(echo "${RELEASE_VERSION}" | awk -F '.' '{print $1}')
  export RELEASE_MINOR_VERSION=$(echo "${RELEASE_VERSION}" | awk -F '.' '{print $2}')
  export RELEASE_PATCH_VERSION=$(echo "${RELEASE_VERSION}" | awk -F '.' '{print $3}')
  export GIO_MILESTONE_VERSION="APIM - ${RELEASE_MAJOR_VERSION}.${RELEASE_MINOR_VERSION}.${RELEASE_PATCH_VERSION}"

  export ORG_NAME="gravitee-io"
  export REPO_NAME="issues"
  # always use the master git branch, regardless of the release version number
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

  ## 5. docker images

  This process :
  * Builds and publish to Dockerhub all Docker images, for Community ans Entreprise Edition.
  * Requires the package bundle step to be completed : it uses the https://download.gravitee.io service.


  * example for APIM Release `3.6.1`, with dry run mode on (no image is docker pushed to dockerhub) :

  ```bash
  # You, will just use your own Circle CI Token
  export CCI_TOKEN=<your circle ci personal api token>
  export ORG_NAME="gravitee-io"
  export REPO_NAME="gravitee-docker"
  export BRANCH="master"
  # always use the "feature/cicd-circle-image-builds" git branch, regardless of the release version number
  export BRANCH="feature/cicd-circle-image-builds"
  export GRAVITEEIO_VERSION="3.6.1"
  export RELEASE_VERSION="M.N.P"

  export JSON_PAYLOAD="{

      \"branch\": \"${BRANCH}\",
      \"parameters\":

      {
          \"gio_product\": \"apim_3x\",
          \"graviteeio_version\": \"${GRAVITEEIO_VERSION}\",
          \"tag_latest\": false,
          \"dry_run\": true
      }

  }"

  curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
  curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
  ```

  * example for APIM Release `3.6.1`, with dry run mode off (all images are docker pushed to dockerhub) :

  ```bash
  # You, will just use your own Circle CI Token
  export CCI_TOKEN=<your circle ci personal api token>
  export ORG_NAME="gravitee-io"
  export REPO_NAME="gravitee-docker"
  export BRANCH="master"
  # always use the "feature/cicd-circle-image-builds" git branch, regardless of the release version number
  export BRANCH="feature/cicd-circle-image-builds"
  export GRAVITEEIO_VERSION="3.6.1"
  export RELEASE_VERSION="M.N.P"

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

  About the `tag_latest` option :
  * Use it only for APIM major Releases
  * Never use it only for APIM support Releases


  ## 6. RPM Packages

  This process :
  * Builds and publish all RPM packages  to the _**Package Cloud**_ (Digital Ocean Service).
  * Requires the package bundle step to be completed : it uses the https://download.gravitee.io service.


  * example for APIM Release `3.6.1`,

  ```bash
  export GRAVITEE_RELEASE_VERSION="3.6.1"
  export GRAVITEE_RELEASE_VERSION="M.N.P"
  export ORG_NAME="gravitee-io"
  export REPO_NAME="release"
  # if P is zero, than the git branch will be master
  export BRANCH="master"
  # if P is not zero, than the git branch will be M.N.x
  export BRANCH="M.N.x"

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

  ## 7. Publish Documentation

  _**This process is still under development**_

  This process :
  * modifies the source code versioned in the https://github.com/gravitee-io/gravitee-docs
  * does this modification y crating a dedicated git bracnh, and a Pull Request, targeted to the `master` git branch.
  * if the Pull Request is accepted, the modification is merged into the master git branch, and the merge itnto master triggers a deployement of https://docs.gravitee.io


  * example for Release `3.6.1`, with dry run mode on  :

  ```bash
  export CCI_TOKEN=<your Circle CI Token>

  export ORG_NAME="gravitee-io"
  export REPO_NAME="release"
  export GRAVITEE_RELEASE_VERSION="3.6.1"
  export GRAVITEE_RELEASE_VERSION="M.N.P"
  export BRANCH="3.6.x"
  # if P is zero, than the git branch will be master
  export BRANCH="master"
  # if P is not zero, than the git branch will be M.N.x
  export BRANCH="M.N.x"
  export JSON_PAYLOAD="{

      \"branch\": \"${BRANCH}\",
      \"parameters\":

      {
          \"gio_action\": \"publish_docs\",
          \"gio_release_version\": \"${GRAVITEE_RELEASE_VERSION}\",
          \"dry_run\": true
      }

  }"

  curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
  curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
  ```

  * example for Release `3.6.1`, with dry run mode off  :

  ```bash
  export CCI_TOKEN=<your Circle CI Token>

  export ORG_NAME="gravitee-io"
  export REPO_NAME="release"
  export GRAVITEE_RELEASE_VERSION="3.6.1"
  export GRAVITEE_RELEASE_VERSION="M.N.P"
  export BRANCH="3.6.x"
  # if P is zero, than the git branch will be master
  export BRANCH="master"
  # if P is not zero, than the git branch will be M.N.x
  export BRANCH="M.N.x""
  export JSON_PAYLOAD="{

      \"branch\": \"${BRANCH}\",
      \"parameters\":

      {
          \"gio_action\": \"publish_docs\",
          \"gio_release_version\": \"${GRAVITEE_RELEASE_VERSION}\",
          \"dry_run\": true
      }

  }"

  curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
  curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
  ```
