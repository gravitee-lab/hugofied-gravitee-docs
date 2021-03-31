---
title: "Gravitee AM Pull Requests"
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "CI/CD Processes"
menu: am_processes
menu_index: 11
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: am-processes
---

## Process Description

* Every time a pull request event occurs :
  * The `SNAPSHOT` is maven built by the `build_snapshot_job` Circle CI Job
  * The `SNAPSHOT` maven artefacts are published to Gravitee's private Artifactory, in the `gravitee-snapshots` repository, by the `publish_snapshot_to_private_artifactory_job` Circle CI Job
  * If A Gravitee Team member (a human), gives his approval to the `publish_snapshot_to_nexus_approval` Circle CI Job, then the `publish_snapshot_to_nexus_job` is executed, to publish the snapshot to nexus snapshots.


Jobs Structure :


<pre>
  secrethub
      |
     \|/
      .
  build_snapshot_job
      |
      |----------------------------------------->  publish_snapshot_to_private_artifactory_job
      |
     \|/
      .
  publish_snapshot_to_nexus_approval
      |
     \|/
      .
  publish_snapshot_to_nexus_job
</pre>
