---
title: "Standalone Nexus Staging"
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "CI/CD Processes"
menu: apim_processes
menu_index: 5
product: "Gravitee APIM"
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: apim-processes
---

## Process Description

* The description of what happens when a (multi) pull request CICD Process is launched


## Orchestrated Nexus Staging

### Idea for the future implementation

The idea :
* the `nexus-staging` process is meant to be de-correlated, in terms of events, from therelease process : the nexus-staging  
* the `nexus-staging` process, like the release process performs operations that are not idempotent :
  * the `release` process creates git tags, and once a git tag has been created, the process, while resuming, msut not try and create again a git tag which has already been created. This is why the resume release feature must "remember" which component has successfully been released, and which has not : to resume the release process only on those components for which the `release` has not yet completed successfully (for each of those components, either the release process has never been started yet, or it has failed)
  * the `nexus-staging` process similarly,

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

```

## Standalone Nexus Staging

When we perform the release process, just for one Gravitee Dev repo, we then also want to perform the nexus staging, just for that single repo

### Idea for the future implementation


## Design of the gravitee Orb


## Misc. Characteristics
