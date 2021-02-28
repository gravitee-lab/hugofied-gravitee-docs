---
title: "Circle CI and SNAPSHOTS"
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

The following `.circleci/config.yml` shows an example of how to implement the pull request workflow (packaging publishing maven SNAPSHOTs) :
* the workflow named `build_snapshot_n_nexus` does the following :
  * packages
  * `mvn deploy` to private artifactory
  * `mvn deploy` to nexus snapshots
  * https://gravitee-parent changed from https://github.com/gravitee-io/gravitee-parent/tree/19 to https://github.com/gravitee-io/gravitee-parent/tree/19.2
  * this Pipeline was validated with the https://github.com/gravitee-io/gravitee-cockpit-connectors repository

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
  secrethub: secrethub/cli@1.0.0
  slack: circleci/slack@4.2.1
  gravitee: gravitee-io/gravitee@dev:1.0.4

jobs:
  secrethub:
    docker:
      - image: 'cimg/base:stable'
    environment:
      MAVEN_SETTINGS: 'secrethub://graviteeio/cicd/graviteebot/infra/maven/dry-run/artifactory/settings.dev.xml'
    steps:
      - secrethub/exec:
          command: echo $MAVEN_SETTINGS > /tmp/.circleci.settings.xml
      - persist_to_workspace:
          root: /tmp
          paths:
            - .circleci.settings.xml

  build_snapshot_n_nexus_job:
    docker:
      - image: circleci/openjdk:11.0.3-jdk-stretch
    resource_class: xlarge
    steps:
      - attach_workspace:
          at: /tmp
      - checkout
      - restore_cache:
          keys:
            - gio-cockpit-connectors-dependencies-{{ checksum "pom.xml" }}
            - gio-cockpit-connectors-dependencies
      - secrethub/install
      - run:
          name: Maven Package and deploy to Artifactory
          command: |
                    export SECREHUB_ORG="graviteeio"
                    export SECREHUB_REPO="cicd"
                    mvn -s /tmp/.circleci.settings.xml -P gio-dev clean deploy
      - run:
          name: Maven Package and deploy to nexus snapshots
          command: |
                    export SECREHUB_ORG="graviteeio"
                    export SECREHUB_REPO="cicd"
                    mvn -s /tmp/.circleci.settings.xml clean deploy
      # ---
      # To use Slack nofifications :
      # => On Circle CI, in project settings, add SLACK_DEFAULT_CHANNEL env. var : the name of the slack channel where you want to receive notifications
      # => On Circle CI, in project settings, add SLACK_ACCESS_TOKEN env. var : ask a slack Adminuser to give your OAUTH Token
      # ---
      # - slack/notify:
          # event: fail
          # template: basic_fail_1
      - save_cache:
          paths:
            - ~/.m2
          key: gio-cockpit-connectors-dependencies-{{ checksum "pom.xml" }}
          when: always
      - run:
          name: Save test results
          command: |
            mkdir -p ~/test-results/junit/
            find . -type f -regex ".*/target/surefire-reports/.*xml" -exec cp {} ~/test-results/junit/ \;
          when: always
      - store_test_results:
          path: ~/test-results
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
  build_snapshot_n_nexus:
    jobs:
      - secrethub:
          context: cicd-orchestrator
      - build_snapshot_n_nexus_job:
          context: cicd-orchestrator
          requires:
            - secrethub

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