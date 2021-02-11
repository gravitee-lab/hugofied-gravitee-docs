---
title: "Standalone Release"
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

For any reason, the Gravitee Dev Team must be able to run a full release process (and next [a nexus staging process](/cicd-processes/apim/standalone-nexus-staging/) ), for just one Github repo.

One important question here, is : by which mean, will a Gravitee Dev Team member, trigger such a process ?


On the other hand, as I presented the [Gravitee APIM Product Orchestrated Release](/cicd-processes/apim/orchestrated-release/) first new CI CD major feature, I explained that this process has to be triggered by sending an HTTP Request to the circle CI API, and demoed that using a simple `curl` command. On this occasion, the Gravitee dEv team made brought to my attention two points :
* that it is unfriendly, to have to trigger such a process using a `curl`, along with requirng a secret : the Circle CI API Token, to authenticate to the Circle CI API.
* that `Jenkins` allows triggering any Pipeline, through its Web UI, and that this same _"Gravitee APIM Product multi-repo Release process"_, in the Legacy CI CD System, was indeed triggered using the Jenkins Web UI : much more user friendly way, than using a rather complex `curl` command.     

Now, The [Gravitee APIM Product Orchestrated Release](/cicd-processes/apim/orchestrated-release/) cannot be triggered from the Circle CI Web UI, because :
* This process requires pipelines parameters, which values _have_ to vary, at least to be able to specify the "dry-run mode" (do you want to trigger a relase n dry run mode, or not?)
* The Circle CI Web UI does not allow triggering Pipelines by specifying pipeline parameters values : When using Web UI, the Pipeline parameters values have to be their default value.

Finally, as we discussed those considerations, important indeed, we considered two different means, to trigger a Circle CI Pipeline. But there are three, and the not considered during this duiscussion, third mean to trigger A Circle CI Pipeline, ertinaly is none the less : you can also trigger a Circle CI by any git event (pushing a git commit, pushing a git tag, pushing a new git commit to the source branch of an opened Pull/Merge Request, etc...).

I now want to higlight this point of view, which is fundamental, in the way Circle CI conceptualizes a Ci CD System :
The CICD System watches you, you do not watch the CICD System. And it wathces you through what you do on your git repos.  You don't have to tell the CICD System what ithas to do, it infers that from what you have done on yoru git repo.




### The Example Release scenario

Let's explain The release process by an example scenario :
* We want to release Gravitee APIM version `3.9.4`
* So we have to edit the `release.json` on the `3.9.x` git branch of the https://github.com/gravitee-io/release repo. :
  * For each component you want to release, set the `version` property to the version in your `pom.xml`, on the source git branch of your pull request

Example `release.json` on the `3.9.x` git branch of the https://github.com/gravitee-io/release repo :

```JSon
{
    "name": "Gravitee.io",
    "version": "3.9.4-SNAPSHOT",
    "buildTimestamp": "2020-10-15T07:19:32+0000",
    "scmSshUrl": "git@github.com:gravitee-io",
    "scmHttpUrl": "https://github.com/gravitee-io/",
    "components": [
        {
            "name": "graviteek-cicd-test-maven-project-g1",
            "version": "4.1.32-SNAPSHOT"
        },
        {
            "name": "graviteek-cicd-test-maven-project-g2",
            "version": "4.2.67-SNAPSHOT"
        },
        {
            "name": "graviteek-cicd-test-maven-project-g3",
            "version": "4.3.17-SNAPSHOT"
        },
        {
            "name": "gravitee-common",
            "version": "1.18.0"
        },
        {
            "name": "gravitee-repository",
            "version": "1.18.0"
        },
        {
            "name": "gravitee-expression-language",
            "version": "2.86.95-SNAPSHOT"
        },
        {
            "name": "gravitee-service-discovery-api",
            "version": "1.25.4"
        },
        {
            "name": "gravitee-notifier-api",
            "version": "1.51.7"
        }
      ],
      "buildDependencies": [
          [
              "graviteek-cicd-test-maven-project-g1"
          ],
          [
              "graviteek-cicd-test-maven-project-g2"
          ],
          [
              "graviteek-cicd-test-maven-project-g3"
          ],
          [
              "gravitee-common"
          ],
          [
              "gravitee-repository",
              "gravitee-expression-language",
              "gravitee-service-discovery-api",
              "gravitee-notifier-api"
          ]
      ]
}
```



## How to: Perfom a Release


### Create a Circle CI personal API Token for your user


The Gravitee CI CD Orchestrator runs in a Circle CI Pipeline.

To Launch a Gravitee CI CD Orchestrator execution, we use the Circle CI API v2, to trigger a Circle CI Pipeline execution  of the Circle CI Pipeline of {{< html_link text="the release repo" link="https://github.com/gravitee-io/release" >}}.

The Circle CI API v2 authentication is Token based. That's why, to perfom a Gravitee Release, the first thing you need is a Circle CI personal API Token for your user.


<!-- * The `release.json` etc.. -->
First, connect to Circle CI, with your Github user, and create a Circle CI personal API Token for your user :
* go to your Circle CI User settings menu :

{{< image alt="Create Circle CI personal Token step 1" width="100%" height="100%" src="/images/figures/cicd-processes/cci-tokens/personal/create_a_circleci_token_for_your_user_1.png" >}}

* go to your Circle CI User settings menu :

{{< image alt="Create Circle CI personal Token step 2" width="100%" height="100%" src="/images/figures/cicd-processes/cci-tokens/personal/create_a_circleci_token_for_your_user_2.png" >}}




### Launch the Dry run


* To launch the release of `Gravitee APIM` version `3.9.4`, execute  :

```bash

export CCI_TOKEN=<You Circle CI User Personal Token>

export ORG_NAME="gravitee-io"
export REPO_NAME="release"
export BRANCH="3.9.x"
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

Note that in dry run mode, the full release process is performed, exceptthat no git commit is `git pushed` to any git repo :
* In the dev repos
* In  {{< html_link text="the release repo" link="https://github.com/gravitee-io/release" >}}

### Launch the Release

* To launch the release of `Gravitee APIM` version `3.9.4`, execute  :

```bash

export CCI_TOKEN=<You Circle CI User Personal Token>

export ORG_NAME="gravitee-io"
export REPO_NAME="release"
export BRANCH="3.9.x"
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

Note that the only difference with the dry run, is the value of the `gio_action` pipeline parameter.

### Resume the Release

If any Pipeline execution fails, the whole release process fails.

The Gravitee CI/CD Orchestrator detects any Pipeline execution failure, and in such a case, the Orchestrator :
* waits until all pipelines complete their execution.
* updates the `release.json`, by removing the `-SNAPSHOT` suffix for all components whose Pipeline successfully completed their execution
* git commits and push the updated the `release.json`, to the {{< html_link text="the release repo" link="https://github.com/gravitee-io/release" >}} on the
* and finally stops.

If a release process that you launched failed, allyou have to do, toresumethe release process, is to laucnh again the release, with the exact same commandthat you used, to launch it in the first place.

Therefore, in our scenario, if you want to resume the release of `Gravitee APIM` version `3.9.4`, all you have to do is to eecute again :

```bash
export CCI_TOKEN=<You Circle CI User Personal Token>

export ORG_NAME="gravitee-io"
export REPO_NAME="release"
export BRANCH="3.9.x"
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

Finally, note that since the Gravitee CI CD ORchestrator relies on the persisted `release.json`, the Resume Release feature is not available in "dry run" mode.

### The Circle CI Pipeline in the release repo


In the https://github.com/gravitee-lab Test Github Org, the Circle CI Pipeline in the release repo is :

```Yaml
version: 2.1

parameters:
  gio_action:
    type: enum
    enum: [release, dry_release, blank]
    default: blank
orbs:
  secrethub: secrethub/cli@1.0.0
  gravitee: gravitee-io/gravitee@dev:1.0.4
jobs:
  empty_job:
    docker:
     - image: alpine
    resource_class: small
    working_directory: /mnt/ramdisk
    steps:
      - run:
          name: "This is a dummy empty job (isn't it ?)"
          command: echo "No task is executed."

  dry_run_orchestrator:
    machine:
      image: 'ubuntu-1604:201903-01'
    environment:
      GITHUB_ORG: ${GITHUB_ORG}
      SECRETHUB_ORG: gravitee-io
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
                    export GITHUB_ORG=gravitee-io
                    export SECRETHUB_ORG=graviteeio
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
                    docker run --name orchestrator ${ENV_VARS} ${DOCKER_VOLUMES} --restart no -it quay.io/gravitee-lab/cicd-orchestrator:stable-latest -s mvn_release --dry-run
                    exit "$?"
  run_orchestrator:
    machine:
      image: 'ubuntu-1604:201903-01'
    environment:
      GITHUB_ORG: ${GITHUB_ORG}
      SECRETHUB_ORG: gravitee-io
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
                    export GITHUB_ORG=gravitee-io
                    export SECRETHUB_ORG=graviteeio
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
                    docker run --name orchestrator ${ENV_VARS} ${DOCKER_VOLUMES} --restart no -it quay.io/gravitee-lab/cicd-orchestrator:stable-latest -s mvn_release --dry-run false
                    exit "$?"
workflows:
  version: 2.1
  # Blank process invoked when pull requests events are triggered
  blank:
    when:
      equal: [ blank, << pipeline.parameters.gio_action >> ]
    jobs:
      - empty_job:
          context: cicd-orchestrator
  # Release Process DRY RUN
  dry_release_process:
    when:
      equal: [ dry_release, << pipeline.parameters.gio_action >> ]
    jobs:
      - dry_run_orchestrator:
          context: cicd-orchestrator
          filters:
            branches:
              # ---
              # Will run only when git commits are pushed to a release branch
              # Therefore, will be triggered when a pull request, with target branch being
              # a release branch, is accepted
              only:
                - 1.20.x
                - 1.25.x
                - 1.29.x
                - 1.30.x
                - 3.0.0-beta
                - 3.0.x
                - 3.1.x
                - 3.2.x
                - 3.4.x
                - 3.5.x
                - 3.6.x
                - 3.7.x
                - 3.8.x
                - 3.9.x
                - 4.0.x
                - 4.1.x
                - 4.2.x
                - 4.3.x
                - 4.4.x
                - master # ? as discussed ? if un-commented, any new pushed commit to master will trigger a Release Process DRY RUN
  release_process:
    when:
      equal: [ release, << pipeline.parameters.gio_action >> ]
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
                - 1.20.x
                - 1.25.x
                - 1.29.x
                - 1.30.x
                - 3.0.0-beta
                - 3.0.x
                - 3.1.x
                - 3.2.x
                - 3.4.x
                - 3.5.x
                - 3.6.x
                - 3.7.x
                - 3.8.x
                - 3.9.x
                - 4.0.x
                - 4.1.x
                - 4.2.x
                - 4.3.x
                - 4.4.x
                - master # ? as discussed ? if un-commented, any new pushed commit to master will trigger a Release Process DRY RUN

```


In the https://github.com/gravitee-lab Test Github Org, the Circle CI Pipeline in the release repo is :

```Yaml
version: 2.1

parameters:
  gio_action:
    type: enum
    enum: [release, dry_release, blank]
    default: blank
orbs:
  secrethub: secrethub/cli@1.0.0
  gravitee: gravitee-io/gravitee@dev:1.0.4
jobs:
  empty_job:
    docker:
     - image: alpine
    resource_class: small
    working_directory: /mnt/ramdisk
    steps:
      - run:
          name: "This is a dummy empty job (isn't it ?)"
          command: echo "No task is executed."

  dry_run_orchestrator:
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
                    docker run --name orchestrator ${ENV_VARS} ${DOCKER_VOLUMES} --restart no -it quay.io/gravitee-lab/cicd-orchestrator:stable-latest -s mvn_release --dry-run
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
                    docker run --name orchestrator ${ENV_VARS} ${DOCKER_VOLUMES} --restart no -it quay.io/gravitee-lab/cicd-orchestrator:stable-latest -s mvn_release --dry-run false
                    exit "$?"
workflows:
  version: 2.1
  # Blank process invoked when pull requests events are triggered
  blank:
    when:
      equal: [ blank, << pipeline.parameters.gio_action >> ]
    jobs:
      - empty_job:
          context: cicd-orchestrator
  # Release Process DRY RUN
  dry_release_process:
    when:
      equal: [ dry_release, << pipeline.parameters.gio_action >> ]
    jobs:
      - dry_run_orchestrator:
          context: cicd-orchestrator
          filters:
            branches:
              # ---
              # Will run only when git commits are pushed to a release branch
              # Therefore, will be triggered when a pull request, with target branch being
              # a release branch, is accepted
              only:
                - 1.20.x
                - 1.25.x
                - 1.29.x
                - 1.30.x
                - 3.0.0-beta
                - 3.0.x
                - 3.1.x
                - 3.2.x
                - 3.4.x
                - 3.5.x
                - 3.6.x
                - 3.7.x
                - 3.8.x
                - 3.9.x
                - 4.0.x
                - 4.1.x
                - 4.2.x
                - 4.3.x
                - 4.4.x
                - master # ? as discussed ? if un-commented, any new pushed commit to master will trigger a Release Process DRY RUN
  release_process:
    when:
      equal: [ release, << pipeline.parameters.gio_action >> ]
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
                - 1.20.x
                - 1.25.x
                - 1.29.x
                - 1.30.x
                - 3.0.0-beta
                - 3.0.x
                - 3.1.x
                - 3.2.x
                - 3.4.x
                - 3.5.x
                - 3.6.x
                - 3.7.x
                - 3.8.x
                - 3.9.x
                - 4.0.x
                - 4.1.x
                - 4.2.x
                - 4.3.x
                - 4.4.x
                - master # ? as discussed ? if un-commented, any new pushed commit to master will trigger a Release Process DRY RUN

```


## Misc. Cahracteristics


## A demo On gravitee-lab


As I developed the resume release feature, I had to prepare a set of tests (test suite).

Now, to run the tests, I execute :

* Test 1, on branch `4.1.x` of the release repo :

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

export ORG_NAME="gravitee-lab"
export REPO_NAME="graviteek-release-test-suite-1"
export BRANCH="4.1.x"
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

* Test 4, on branch `4.4.x` of the release repo :

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

export ORG_NAME="gravitee-lab"
export REPO_NAME="graviteek-release-test-suite-1"
export BRANCH="4.4.x"
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



* a quick test on master branch (to test prepare next release with minor version/ new support branch creation ) :

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

export ORG_NAME="gravitee-lab"
export REPO_NAME="graviteek-release-test-suite-1"
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
