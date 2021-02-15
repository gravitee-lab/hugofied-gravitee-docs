---
title: "SSH Git cloning"
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "Circle CI and Docker"
menu: circle_docker
menu_index: 2
product: "Gravitee APIM"
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: circle-docker
---


## How do I SSH git clone a repo into a Circle CI Docker Executor ?


* Assume :
  * you work  in a gravitee repo named `gravitee-repo-iworkon`, so https://github.com/gravitee-io/gravitee-repo-iworkon
  * you work on a git branch named `mygitworkbranch`

* On the `mygitworkbranch` git branch of the https://github.com/gravitee-io/gravitee-repo-iworkon repo, add a `./.circleci/config.yml`, with this content :

```Yaml
version: 2.1

parameters:
  gio_action:
    type: enum
    enum: [cicd_test, blank]
    default: blank
  desired_version:
    type: string
    default: $DESIRED_VERSION
orbs:
  secrethub: secrethub/cli@1.0.0
  gravitee: gravitee-io/gravitee@dev:1.0.4
jobs:
  # empty_job:
    # docker:
     # - image: alpine
    # resource_class: small
    # working_directory: /mnt/ramdisk
    # steps:
      # - run:
          # name: "This is a dummy empty job (isn't it ?)"
          # command: echo "No task is executed."
  cicd_test_job:
    docker:
     - image: 'cimg/base:stable'
    resource_class: medium
    # working_directory: /mnt/ramdisk
    environment:
      DESIRED_VERSION: << pipeline.parameters.desired_version >>
      YOUR_GITHUB_REPO: git@github.com:gravitee-lab/release-with-nexus-staging-test1
      # SECRETHUB_ORG: gravitee-lab
      SECRETHUB_ORG: graviteeio
      SECRETHUB_REPO: cicd
      GIT_SSH_PUB_KEY: 'secrethub://gravitee-lab/cicd/graviteebot/git/ssh/public_key'
      GIT_SSH_PRV_KEY: 'secrethub://gravitee-lab/cicd/graviteebot/git/ssh/private_key'
    steps:
      - secrethub/exec:
          command: |
                    mkdir -p /tmp/graviteebot/.secrets/.ssh.gravitee.io
                    echo $GIT_SSH_PUB_KEY > /tmp/graviteebot/.secrets/.ssh.gravitee.io/id_rsa.pub
                    echo $GIT_SSH_PRV_KEY > /tmp/graviteebot/.secrets/.ssh.gravitee.io/id_rsa
                    ssh-keygen -R github.com
                    mkdir -p ~/.ssh
                    chmod 700 ~/.ssh
                    ssh-keyscan -H github.com >> ~/.ssh/known_hosts
                    ssh -Ti /tmp/graviteebot/.secrets/.ssh.gravitee.io/id_rsa git@github.com || true
                    exit 0
      - run:
          name: "Here you git clone"
          command: |
                    echo "value of DESIRED_VERSION = [$DESIRED_VERSION]"
                    echo "value of DESIRED_VERSION = [${DESIRED_VERSION}]"
                    echo "value of YOUR_GITHUB_REPO = [${YOUR_GITHUB_REPO}]"
                    echo "value of SECRETHUB_ORG = [${SECRETHUB_ORG}]"
                    echo "value of SECRETHUB_REPO = [${SECRETHUB_REPO}]"
                    export OPS_HOME=$(pwd)
                    echo "Current diectory: [$(pwd)]"
                    git clone ${YOUR_GITHUB_REPO} ${HOME}/retrieved-release-repo
                    export LOCAL_RELEASE_REPO=${HOME}/retrieved-release-repo

workflows:
  version: 2.1
  cicd_test_wf:
    when:
      equal: [ cicd_test, << pipeline.parameters.gio_action >> ]
    jobs:
      - cicd_test_job:
          context: cicd-orchestrator

```
* Then you can trigger the `cicd_test_job` like this (and you will see the git clone happening) :

```bash
export CCI_TOKEN=<your circle ci token>

# export ORG_NAME="gravitee-lab"
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-repo-iworkon"
export BRANCH="mygitworkbranch"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
      \"gio_action\": \"cicd_test\",
      \"desired_version\": \"45.59.86\"
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .

```
