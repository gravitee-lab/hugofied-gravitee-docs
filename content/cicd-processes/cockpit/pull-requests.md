---
title: "Gravitee Cockpit Pull Requests"
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "CI/CD Processes"
menu: cockpit_processes
menu_index: 12
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: cockpit-processes
---

## Process Description

* A Pull Request is opened,
* Every commit on the source branch of the pull request triggers a Circle Ci Pipeline execution.
* The triggered Circle Ci Pipeline execution, executes only one unique workflow, named `pull_requests`
* The Circle Ci Pipeline workflow, named `pull_requests`, executes those steps :
  * builds the maven in its `-SNAPSHOT` version, without updating anything in the `pom.xml`
  * deploys to _nexus sonatype snapshots public repository_
  * the above 2 tasks are performed with one command : `mvn -s ./settings.xml clean deploy`
  * using the `settings.xml` comes from secrethub, and contains the whole configuration needed to deploy to _nexus sonatype snapshots public repository_.

## Setting up the Circle CI `./.circleci/config.yml`

To set up the process, you will have to add 3 things in your `./.circleci/config.yml` :
* a Circle CI pipeline job, named `build_n_deploy_snapshot_to_nexus` in the below example
* a Circle CI pipeline workflow, named `pull_requests` in the below example
* Two Circle CI Orbs :
  * `slack: circleci/slack@4.2.1`
  * and `secrethub: secrethub/cli@1.0.0`


The Circle CI Config in your project will look like this :

```Yaml
version: 2.1

parameters:
  gio_action:
    type: enum
    enum: [release, pull_request]
    default: pull_request
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
  secrethub: secrethub/cli@1.0.0
  slack: circleci/slack@4.2.1
  gravitee: gravitee-io/gravitee@dev:1.0.4

jobs:
  build_n_deploy_snapshot_to_nexus:
    docker:
      - image: circleci/openjdk:11.0.3-jdk-stretch
    resource_class: xlarge
    steps:
      - attach_workspace:
          at: /tmp
      - checkout
      - restore_cache:
          keys:
            - gio-<replace this with the name of your github repository>-dependencies-{{ checksum "pom.xml" }}
            - gio-<replace this with the name of your github repository>-dependencies
      - secrethub/install
      - run:
          name: Maven Package and deploy to nexus snapshots
          command: |
                    export SECREHUB_ORG="graviteeio"
                    export SECREHUB_REPO="cicd"
                    secrethub read --out-file ./settings.xml ${SECREHUB_ORG}/${SECREHUB_REPO}/graviteebot/infra/maven/settings.dev.snaphots.xml
                    # cat ./settings.xml
                    mvn -s ./settings.xml clean deploy
      # ---
      # To use Slack nofifications :
      # => On Circle CI, in project settings, add SLACK_DEFAULT_CHANNEL env. var : the name of the slack channelwhere you want to receive notifiations
      # => On Circle CI, in project settings, add SLACK_ACCESS_TOKEN env. var : ask a slack Adminuser to give your OAUTH Token
      # ---
      # - slack/notify:
          # event: fail
          # template: basic_fail_1
      - save_cache:
          paths:
            - ~/.m2
          key: gio-<replace this with the name of your github repository>-dependencies-{{ checksum "pom.xml" }}
          when: always
      - run:
          name: Save test results
          command: |
            mkdir -p ~/test-results/junit/
            find . -type f -regex ".*/target/surefire-reports/.*xml" -exec cp {} ~/test-results/junit/ \;
          when: always
      - store_test_results:
          path: ~/test-results
      - store_artifacts:
          # --- example "path" for https://github.com/gravitee-io/gravitee-cockpit-connectors :
          # path: /home/circleci/project/gravitee-cockpit-connectors-core/target/
          # ---
          # So below say in your maven projects, the "target/" folder for your
          # root "pom.xml" builds some artifacts like a jar file :
          path: /home/circleci/project/target/
          # destination: artifacts
      # ---
      # Use the below step If you want to perist any file at the end of
      # the build process
      # Then this will make the persisted files, available for download, after
      # pipeline finished execution, with a curl
      # ---
      # - persist_to_workspace:
          # root: some/folder/from/your/maven/project/root/
          # paths:
            # - ./*.zip

workflows:
  version: 2.1
  pull_requests:
    when:
      equal: [ pull_request, << pipeline.parameters.gio_action >> ]
    jobs:
      - build_n_deploy_snapshot_to_nexus:
          context: cicd-orchestrator

  mvn_release:
    when:
      and:
        - equal: [ release, << pipeline.parameters.gio_action >> ]
        - not: << pipeline.parameters.dry_run >>
    jobs:
      - gravitee/release:
          context: cicd-orchestrator
          dry_run: << pipeline.parameters.dry_run >>
          secrethub_org: << pipeline.parameters.secrethub_org >>
          secrethub_repo: << pipeline.parameters.secrethub_repo >>
          maven_profile_id: << pipeline.parameters.maven_profile_id >>
  release_dry_run:
    when:
      and:
        - equal: [ release, << pipeline.parameters.gio_action >> ]
        - << pipeline.parameters.dry_run >>
    jobs:
      - gravitee/release:
          context: cicd-orchestrator
          dry_run: << pipeline.parameters.dry_run >>
          secrethub_org: << pipeline.parameters.secrethub_org >>
          secrethub_repo: << pipeline.parameters.secrethub_repo >>
          maven_profile_id: << pipeline.parameters.maven_profile_id >>

```

### Details about the job steps


#### _**Job named `store_test_results`**_

* The `store_test_results` alows storing built artifacts to be able to retrieve them after the pipeline has finished its execution.
* below is a small script which will then retrieve all the files stored by `store_test_results`, for any project :

```bash
# --
# You get a Circle CI Token form your Circle CI "User Settings" menu => "Personal API Token" menu
export MY_CIRCLE_CI_TOKEN=<value of your Circle CI Personal API Token>
# --
export CCI_VCS_SLUG=gh
export GITHUB_ORG=gravitee-lab
export GITHUB_REPO_NAME=gravitee-cockpit-connectors
export CCI_PROJECT_SLUG="${CCI_VCS_SLUG}/${GITHUB_ORG}/${GITHUB_REPO_NAME}"
# ---
# In circle CI Web UI, the http link to the Pipeline exec is : https://app.circleci.com/pipelines/github/gravitee-lab/gravitee-cockpit-connectors/8/workflows/93333eaf-0acb-4bf7-843c-6bc0eb4fd6e7/jobs/8
# -
# export PIPELINE_EXEC_BUILD_NUMBER="8"
# So job build number is 8
export PIPELINE_EXEC_JOB_NUMBER="8"

curl -X GET "https://circleci.com/api/v2/project/${CCI_PROJECT_SLUG}/${PIPELINE_EXEC_JOB_NUMBER}/artifacts" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${MY_CIRCLE_CI_TOKEN}"
curl -X GET "https://circleci.com/api/v2/project/${CCI_PROJECT_SLUG}/${PIPELINE_EXEC_JOB_NUMBER}/artifacts" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${MY_CIRCLE_CI_TOKEN}" | jq .
curl -X GET "https://circleci.com/api/v2/project/${CCI_PROJECT_SLUG}/${PIPELINE_EXEC_JOB_NUMBER}/artifacts" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${MY_CIRCLE_CI_TOKEN}" | jq .items[].url | awk -F '"' '{print $2}' | tee ./my.artifacts.download.links.list

if [ -f ./amazons3.real.download.links.list ]; then
  rm ./amazons3.real.download.links.list
fi;

while read DWNLOAD_LINK; do
  curl -iv "${DWNLOAD_LINK}" | grep 'Location:' | awk '{print $2}' | tee -a ./amazons3.real.download.links.list
done <./my.artifacts.download.links.list

while read DWNLOAD_LINK; do
  wget "${DWNLOAD_LINK}"
done <./amazons3.real.download.links.list

# curl -X GET "https://circleci.com/api/v2/project/${CCI_PROJECT_SLUG}/${PIPELINE_EXEC_BUILD_NUMBER}/artifacts" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .

```

#### _**Job named `store_test_results`**_

* this step saves all the `JUnit` `xml` files generated for tests results,
* and when the pipeline execution is finished, you can download tests meta-data (not those `xml` files tests results themselves)

Example, for pipeline execution https://app.circleci.com/pipelines/github/gravitee-io/gravitee-cockpit-connectors/13/workflows/141480f4-9cd6-4d4a-9f68-00478ff52e1e/jobs/14 :

```bash
# --
# You get a Circle CI Token form your Circle CI "User Settings" menu => "Personal API Token" menu
export MY_CIRCLE_CI_TOKEN=<value of your Circle CI Personal API Token>
# ---
# In circle CI Web UI, the http link to the Pipeline exec is : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-cockpit-connectors/13/workflows/141480f4-9cd6-4d4a-9f68-00478ff52e1e/jobs/14
# -
# So build number is 13
export PIPELINE_EXEC_BUILD_NUMBER="13"
# -
# and repo name is
export GITHUB_REPO_NAME="gravitee-cockpit-connectors"
# ---
#
export MY_GITHUB_ORG="gravitee-io"

curl "https://circleci.com/api/v1.1/project/:vcs-type/${MY_GITHUB_ORG}/${GITHUB_REPO_NAME}/${PIPELINE_EXEC_BUILD_NUMBER}/tests" -H "Circle-Token: ${MY_CIRCLE_CI_TOKEN}"

# this one did not give me anything interesting here a priori, but I followed documentation
```


## Working with multiple Github Repositories / Pull requests

When this process is launched it assumes all `pom.xml` dependencies are all present in the _nexus sonatype snapshots public repository_.

So if you work with multiple repositories, with dependencies between them, you must work on them following their dependency order.

Example Scenario Given :

* You need to solve an issue, and identified that it requires to work on 3 different github repos :
  * https://github.com/gravitee-io/gravitee-repo-A : you build version `5.2.4-SNAPSHOT`
  * https://github.com/gravitee-io/gravitee-repo-B : you build version `2.2.7-SNAPSHOT`
  * and https://github.com/gravitee-io/gravitee-repo-C : you build version `3.4.3-SNAPSHOT`
* the `pom.xml` in https://github.com/gravitee-io/gravitee-repo-A , has in its `dependencies` : `gravitee-repo-B`, version `2.2.7-SNAPSHOT`
* the `pom.xml` in https://github.com/gravitee-io/gravitee-repo-B , has in its `dependencies` : `gravitee-repo-C`, version `3.4.3-SNAPSHOT`


Then, you must work like this :

* first you `git push` a `git` commit to your Pull Request source branch in https://github.com/gravitee-io/gravitee-repo-C :
  * Circle CI will build `gravitee-repo-C`, version `3.4.3-SNAPSHOT`, and deploy it to _nexus sonatype snapshots public repository_
  * so it is available for `gravitee-repo-B` build
* then you `git push` a `git` commit to your Pull Request source branch in https://github.com/gravitee-io/gravitee-repo-B :
  * Circle CI will build `gravitee-repo-B`, version `2.2.7-SNAPSHOT`, and deploy it to _nexus sonatype snapshots public repository_
  * so `gravitee-repo-B`, version `2.2.7-SNAPSHOT`, is available for `gravitee-repo-A` build
* finally you `git push` a `git` commit to your Pull Request source branch in https://github.com/gravitee-io/gravitee-repo-A :
  * Circle CI will build `gravitee-repo-A`, version `5.2.4-SNAPSHOT`, and deploy it to _nexus sonatype snapshots public repository_
  * and `gravitee-repo-A`, version `5.2.4-SNAPSHOT`, is available in _nexus sonatype snapshots public repository_
