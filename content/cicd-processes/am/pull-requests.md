---
title: "Gravitee AM Pull Requests"
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "CI/CD Processes"
menu: am_processes
menu_index: 8
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: am-processes
---

## Process Description

* The description of what happens when a (multi) pull request CICD Process is launched



## Idea for the furture implementation

basically the same as a release, only :
* instead of infering a git branch name from the `version` property of each component, being valued with somethinglike `5.4.x` (then the target branch is )
* a new `JSON` property for each `component`, named `pull-request`, allows to specify the developer 's pull request soruce git branch name
* then the release is perform basedon those pull request soruce git branch name

```JSon
{
    "name": "Gravitee.io",
    "version": "7.10.0-SNAPSHOT",
    "buildTimestamp": "2020-10-15T07:19:32+0000",
    "scmSshUrl": "git@github.com:gravitee-io",
    "scmHttpUrl": "https://github.com/gravitee-io/",
    "components": [
        {
            "name": "graviteek-cicd-test-maven-project-g1",
            "version": "4.1.32-SNAPSHOT",
            "pull-request": "pr-1589-spikearrest"
        },
        {
            "name": "graviteek-cicd-test-maven-project-g2",
            "version": "4.2.67-SNAPSHOT",
            "pull-request": "pr-84-json-weirdo"
        },
        {
            "name": "graviteek-cicd-test-maven-project-g3",
            "version": "4.3.17-SNAPSHOT",
            "pull-request": "pr-753-gdpr-scar"
        },
        {
            "name": "gravitee-common",
            "version": "1.18.0"
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



Process pattern :
* perform a dry run for each commit on a pull request :
  * the docker push happens on a private docker registry
  * no deployement target (zero infrastructure in any cloud provider)
  * but from the private docker registry, the development engineer can deploy on his own machine (watch Cicrlc CI and  trigger local deployment)
* when the manager wants to decide whether or not he accepts the pullrequest or not, he can launch the same process:
  * but then what happens is the same, but with a deployement in a cloud provider. (non dry-run)
  * actually, that process can be laucnhed every evening, and the manager gets the results everry morning.






## Misc. Cahracteristics
