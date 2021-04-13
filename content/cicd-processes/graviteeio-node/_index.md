---
title: "Gravitee Kubernetes CI/CD Processes"
date: 2020-12-16T00:44:23+01:00
draft: false
menu_index: 7
showChildrenInMenu : true
nav_menu: "CI/CD Processes"
type: ae-processes
---

## Graviteeio Node Releases

The Release process of the gravitee kubernetes repository can be launched by 2 means :
* (Not available yet) Either you release it within an APIM release (Gravitee APIM Orchestrated release CICD Process) :
  * Then the Orchestrator launches it, in an Orchestrated release process of APIM
  * Or you can trigger it yoruself, using the exact same Circle CI API call the orchestrator uses : I called this the "Standalone release"
* Or you want to perform the release on the gravitee-kubernetes repository alone, out of any APIM release process:
  * Regarding the gravitee-kubernetes repository itself
