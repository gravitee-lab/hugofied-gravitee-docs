---
title: "SSH Git cloning"
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "Circle CI and Docker"
menu: circle_docker
menu_index: 3
product: "Gravitee APIM"
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: circle-docker
---

## This topic is not solved yet

The following `.circleci/config.yml` shows the problem, that using the same SSH Public / Private Key Pair, is an issur when using `secrethub://path/to/secret` technique :
* the default workflow named `cicd_test` :
  * tries and fails to use an SSH Key Pair which is proved to be valid by the `dry_run_orchestrator` job
  * is triggered everytime you git push a new git commit
* The `dry_nexus_staging_process` workflow
```Yaml
version: 2.1

parameters:
  gio_action:
    type: enum
    enum: [release, dry_nexus_staging, nexus_staging, cicd_test, blank]
    default: cicd_test
  gio_product_version:
    type: string
    default: "78.15.42"
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
      GIO_PRODUCT_VERSION: << pipeline.parameters.gio_product_version >>
      RELEASE_REPO: git@github.com:gravitee-lab/release-with-nexus-staging-test1
      SECRETHUB_ORG: gravitee-lab
      SECRETHUB_REPO: cicd
      GIT_SSH_PUB_KEY: 'secrethub://gravitee-lab/cicd/graviteebot/git/ssh/public_key'
      GIT_SSH_PRV_KEY: 'secrethub://gravitee-lab/cicd/graviteebot/git/ssh/private_key'
    steps:
      # secrethub cannot be installed directly into a docker image
      # So git_config orb cannot be used as is into a docker container.
      #
      # - secrethub/install
      # - gravitee/git_config:
          # secrethub_org: $SECRETHUB_ORG
          # secrethub_repo: $SECRETHUB_REPO
      - secrethub/exec:
          command: |
                    mkdir -p /tmp/graviteebot/.secrets/.ssh.gravitee.io
                    echo $GIT_SSH_PUB_KEY > /tmp/graviteebot/.secrets/.ssh.gravitee.io/id_rsa.pub
                    echo $GIT_SSH_PRV_KEY > /tmp/graviteebot/.secrets/.ssh.gravitee.io/id_rsa
                    ssh-keygen -R github.com
                    mkdir -p ~/.ssh
                    touch ~/.ssh/known_hosts
                    chmod 700 -R ~/.ssh/
                    ssh-keyscan -H github.com >> ~/.ssh/known_hosts
                    chmod 700 /tmp/graviteebot/.secrets/.ssh.gravitee.io
                    chmod 644 /tmp/graviteebot/.secrets/.ssh.gravitee.io/id_rsa.pub
                    chmod 600 /tmp/graviteebot/.secrets/.ssh.gravitee.io/id_rsa
                    ssh-add -D
                    # cat /tmp/graviteebot/.secrets/.ssh.gravitee.io/id_rsa
                    # ssh-add /tmp/graviteebot/.secrets/.ssh.gravitee.io/id_rsa
                    ssh -Ti /tmp/graviteebot/.secrets/.ssh.gravitee.io/id_rsa git@github.com || true
                    exit 0
      - run:
          name: "This is a dummy empty job (isn't it ?)"
          command: |
                    echo "value of GIO_PRODUCT_VERSION = [$GIO_PRODUCT_VERSION]"
                    echo "value of GIO_PRODUCT_VERSION = [${GIO_PRODUCT_VERSION}]"
                    echo "value of RELEASE_REPO = [${RELEASE_REPO}]"
                    echo "value of SECRETHUB_ORG = [${SECRETHUB_ORG}]"
                    echo "value of SECRETHUB_REPO = [${SECRETHUB_REPO}]"
                    # export OPS_HOME=$(pwd)
                    # echo "Current diectory: [$(pwd)]"
                    # git clone ${RELEASE_REPO} ${HOME}/retrieved-release-repo
                    # export LOCAL_RELEASE_REPO=${HOME}/retrieved-release-repo
      - persist_to_workspace:
          root: /tmp
          paths:
            - graviteebot

  cicd_test_job2:
    docker:
     - image: 'cimg/base:stable'
    resource_class: medium
    # working_directory: /mnt/ramdisk
    environment:
      GIO_PRODUCT_VERSION: << pipeline.parameters.gio_product_version >>
      RELEASE_REPO: git@github.com:gravitee-lab/release-with-nexus-staging-test1
    steps:
      - attach_workspace:
          at: /tmp
      - run:
          name: "Git SSH config"
          command: |
                    # mkdir -p /tmp/graviteebot/.secrets/.ssh.gravitee.io
                    # echo $GIT_SSH_PUB_KEY > /tmp/graviteebot/.secrets/.ssh.gravitee.io/id_rsa.pub
                    # echo $GIT_SSH_PRV_KEY > /tmp/graviteebot/.secrets/.ssh.gravitee.io/id_rsa
                    echo "check [/tmp]"
                    ls -allh /tmp
                    echo "check [/tmp/graviteebot]"
                    ls -allh /tmp/graviteebot
                    echo "check [/tmp/graviteebot/.secrets/.ssh.gravitee.io]"
                    ls -allh /tmp/graviteebot/.secrets/.ssh.gravitee.io
                    # --
                    mkdir -p ~/.ssh
                    chmod 700 ~/.ssh
                    touch ~/.ssh/known_hosts
                    ssh-keygen -R github.com
                    ssh-keyscan -H github.com >> ~/.ssh/known_hosts
                    chmod 700 /tmp/graviteebot/.secrets/.ssh.gravitee.io
                    chmod 644 /tmp/graviteebot/.secrets/.ssh.gravitee.io/id_rsa.pub
                    chmod 600 /tmp/graviteebot/.secrets/.ssh.gravitee.io/id_rsa
                    ssh-add -D
                    # cat /tmp/graviteebot/.secrets/.ssh.gravitee.io/id_rsa
                    # ssh-add /tmp/graviteebot/.secrets/.ssh.gravitee.io/id_rsa
                    ssh -Ti /tmp/graviteebot/.secrets/.ssh.gravitee.io/id_rsa git@github.com || true


      - run:
          name: "This is a dummy empty job (isn't it ?)"
          command: |
                    echo "value of GIO_PRODUCT_VERSION = [$GIO_PRODUCT_VERSION]"
                    echo "value of GIO_PRODUCT_VERSION = [${GIO_PRODUCT_VERSION}]"
                    echo "value of RELEASE_REPO = [${RELEASE_REPO}]"
                    echo "value of SECRETHUB_ORG = [${SECRETHUB_ORG}]"
                    echo "value of SECRETHUB_REPO = [${SECRETHUB_REPO}]"
                    export OPS_HOME=$(pwd)
                    echo "Current diectory: [$(pwd)]"
                    git clone ${RELEASE_REPO} ${HOME}/retrieved-release-repo
                    export LOCAL_RELEASE_REPO=${HOME}/retrieved-release-repo


  dry_run_orchestrator:
    machine:
      image: 'ubuntu-1604:201903-01'
    environment:
      GITHUB_ORG: ${GITHUB_ORG}
      GIO_PRODUCT_VERSION: << pipeline.parameters.gio_product_version >>
      RELEASE_REPO: git@github.com:gravitee-lab/release-with-nexus-staging-test1
      SECRETHUB_ORG: gravitee-lab
      SECRETHUB_REPO: cicd
    steps:
      - checkout
      - secrethub/install
      # - secrethub/install
      - gravitee/git_config:
          secrethub_org: gravitee-lab
          secrethub_repo: cicd
      - run:
          name: "SSH test git config"
          command: |
                    echo "check [${HOME}/.ssh.gravitee.io/]"
                    ls -allh ${HOME}/.ssh.gravitee.io/
                    echo "check [${HOME}/.ssh.gravitee.io/id_rsa]"
                    ls -allh ${HOME}/.ssh.gravitee.io/id_rsa
                    echo "check [${HOME}/.ssh.gravitee.io/id_rsa.pub]"
                    ls -allh ${HOME}/.ssh.gravitee.io/id_rsa.pub
                    ssh -Ti ~/.ssh.gravitee.io/id_rsa git@github.com || true
      - run:
          name: "Retieving Release.json"
          command: |
                    export OPS_HOME=$(pwd)
                    echo "Current diectory: [$(pwd)]"
                    git clone ${RELEASE_REPO} ${HOME}/retrieved-release-repo
                    export LOCAL_RELEASE_REPO=${HOME}/retrieved-release-repo

      - run:
          name: "Docker pull"
          command: |
                    exit 1
                    docker pull quay.io/gravitee-lab/cicd-orchestrator:stable-latest
      - run:
          name: "Running the Gio CICD Orchestrator as docker container"
          command: |
                    echo "Checking pipeline env. : "
                    ls -allh
                    export GITHUB_ORG=gravitee-lab
                    export SECRETHUB_ORG=gravitee-lab
                    export SECRETHUB_REPO=cicd
                    echo "GITHUB_ORG=${GITHUB_ORG}"
                    echo "SECRETHUB_ORG=${SECRETHUB_ORG}"
                    echo "SECRETHUB_REPO=${SECRETHUB_REPO}"
                    # checking docker image pulled in previous step is there
                    docker images
                    # --> .secrets.json is used by Gravitee CI CD Orchestrator to authenticate to Circle CI
                    CCI_SECRET_FILE=$PWD/.secrets.json
                    secrethub read --out-file ${CCI_SECRET_FILE} ${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/circleci/api/.secret.json
                    secrethub read ${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/circleci/secrethub-svc-account/token > ./.secrethub.credential
                    ls -allh ${CCI_SECRET_FILE}
                    # Docker volumes to map pipeline checked out git tree, .env file and .secrets.json files inside the docker container
                    # export DOCKER_VOLUMES="-v $PWD:/graviteeio/cicd/pipeline -v $PWD/.env:/graviteeio/cicd/.env -v $PWD/.secrets.json:/graviteeio/cicd/.secrets.json"
                    export DOCKER_VOLUMES="-v $PWD:/graviteeio/cicd/pipeline -v $PWD/.secrets.json:/graviteeio/cicd/.secrets.json -v $PWD/.secrethub.credential:/graviteeio/cicd/.secrethub.credential"
                    export ENV_VARS="--env GH_ORG=${GITHUB_ORG} --env SECRETHUB_ORG=${SECRETHUB_ORG} --env SECRETHUB_REPO=${SECRETHUB_REPO}"
                    docker run --name orchestrator ${ENV_VARS} ${DOCKER_VOLUMES} --restart no -it quay.io/gravitee-lab/cicd-orchestrator:stable-latest -s mvn_nexus_staging --dry-run
                    exit "$?"
  run_orchestrator:
    machine:
      image: 'ubuntu-1604:201903-01'
    environment:
      GITHUB_ORG: ${GITHUB_ORG}
      SECRETHUB_ORG: gravitee-lab
      SECRETHUB_REPO: cicd
    steps:
      - checkout
      - secrethub/install
      - run:
          name: "Docker pull"
          command: |
                    docker pull quay.io/gravitee-lab/cicd-orchestrator:stable-latest
      - run:
          name: "Running the Gio CICD Orchestrator as docker container"
          command: |
                    echo "Checking pipeline env. : "
                    ls -allh
                    export GITHUB_ORG=gravitee-lab
                    export SECRETHUB_ORG=gravitee-lab
                    export SECRETHUB_REPO=cicd
                    echo "GITHUB_ORG=${GITHUB_ORG}"
                    echo "SECRETHUB_ORG=${SECRETHUB_ORG}"
                    echo "SECRETHUB_REPO=${SECRETHUB_REPO}"
                    # checking docker image pulled in previous step is there
                    docker images
                    # --> .secrets.json is used by Gravitee CI CD Orchestrator to authenticate to Circle CI
                    CCI_SECRET_FILE=$PWD/.secrets.json
                    secrethub read --out-file ${CCI_SECRET_FILE} ${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/circleci/api/.secret.json
                    secrethub read ${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/circleci/secrethub-svc-account/token > ./.secrethub.credential
                    ls -allh ${CCI_SECRET_FILE}
                    # Docker volumes to map pipeline checked out git tree, .env file and .secrets.json files inside the docker container
                    # export DOCKER_VOLUMES="-v $PWD:/graviteeio/cicd/pipeline -v $PWD/.env:/graviteeio/cicd/.env -v $PWD/.secrets.json:/graviteeio/cicd/.secrets.json"
                    export DOCKER_VOLUMES="-v $PWD:/graviteeio/cicd/pipeline -v $PWD/.secrets.json:/graviteeio/cicd/.secrets.json -v $PWD/.secrethub.credential:/graviteeio/cicd/.secrethub.credential"
                    export ENV_VARS="--env GH_ORG=${GITHUB_ORG} --env SECRETHUB_ORG=${SECRETHUB_ORG} --env SECRETHUB_REPO=${SECRETHUB_REPO}"
                    docker run --name orchestrator ${ENV_VARS} ${DOCKER_VOLUMES} --restart no -it quay.io/gravitee-lab/cicd-orchestrator:stable-latest -s mvn_nexus_staging --dry-run false
                    exit "$?"
workflows:
  version: 2.1
  # Blank process invoked when pull requests events are triggered
  # blank:
    # when:
      # equal: [ blank, << pipeline.parameters.gio_action >> ]
    # jobs:
      # - empty_job:
          # context: cicd-orchestrator
  # Release Process DRY RUN
  cicd_test_wf:
    when:
      equal: [ cicd_test, << pipeline.parameters.gio_action >> ]
    jobs:
      - cicd_test_job:
          context: cicd-orchestrator
      - cicd_test_job2:
          requires:
            - cicd_test_job
          context: cicd-orchestrator
  dry_nexus_staging_process:
    when:
      equal: [ dry_nexus_staging, << pipeline.parameters.gio_action >> ]
    jobs:
      - dry_run_orchestrator:
          context: cicd-orchestrator
          filters:
            tags:
              only:
                - /^[0-9]+.[0-9]+.[0-9]+/
  nexus_staging_process:
    when:
      equal: [ nexus_staging, << pipeline.parameters.gio_action >> ]
    jobs:
      - run_orchestrator:
          context: cicd-orchestrator
          # one cannot filters branches when conditonal workflows ?
          filters:
            branches:
              # ---
              # Will run only when git commits are pushed to master branch
              # Therefore, will be triggered when a pull request is accepted, with target branch being
              # the master branch.
              only:
                - /^[0-9]+.[0-9]+.x/
                - master # ? as discussed ? if un-commented, any new pushed commit to master will trigger a Release Process DRY RUN

```


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
