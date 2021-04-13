---
title: "Gravitee Kubernetes Pull Requests"
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "CI/CD Processes"
menu: apim_processes
menu_index: 9
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: apim-processes
---

## Process Description

This process :
* Is triggered on pull requests events
* Builds the SNAPSHOT version of the Gravitee Kubernetes APIM Controller
* Publishes the SNAPSHOT version of the Gravitee Kubernetes APIM Controller to the `gravitee-snapshots` repository in Gravitee's private Artifactory,
* Publishes the SNAPSHOT version of the Gravitee Kubernetes APIM Controller to nexus staging,

This process was tested operational with [this pipeline execution](https://app.circleci.com/pipelines/github/gravitee-io/gravitee-kubernetes/78/workflows/46958989-79eb-4085-bb95-445f69d8026d/jobs/161)
