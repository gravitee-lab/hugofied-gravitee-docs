---
title: "Gravitee Cockpit Deliver Nightly Demo"
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "CI/CD Processes"
menu: cockpit_processes
menu_index: 13
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: cockpit-processes
---

## Process Description

* With every commit on the `master` branch of the {{< html_link text="gravitee-cockpit repo" link="https://github.com/gravitee-io/gravitee-cockpit" >}}, a process is triggered which :
  * runs the unit tests defined in the repo, with `mvn clean test`
  * runs the full maven build and deploys the resulting maven artifacts to {{< html_link text="the gravitee private artifactory" link="https://odbxikk7vo-artifactory.services.clever-cloud.com/webapp/#/home" >}}, with `mvn clean deploy`. Here the resulting artifacts are maven `SNAPSHOT`s, and in gravtiee 's private artifactory, they are deployed to  {{< html_link text="the gravitee-snapshots repository" link="https://odbxikk7vo-artifactory.services.clever-cloud.com/webapp/#/artifacts/browse/tree/General/gravitee-snapshots/com/graviteesource/cockpit" >}}
  * runs a step called __"Prepare Container Image Build"__, which uses the `Makefile` defined in the {{< html_link text="gravitee-cockpit repo" link="https://github.com/gravitee-io/gravitee-cockpit" >}}, to :
    * prepare the two `Dockerfile`s wich will be used to respectively build the {{< html_link text="container image of Gravitee Cockpit's Management API" link="https://hub.docker.com/r/graviteeio/cockpit-management-api" >}} and the  {{< html_link text="container image of Gravitee Cockpit 's Web UI" link="https://hub.docker.com/r/graviteeio/cockpit-webui" >}}.
    * prepare two folders, each of which will be used as the Docker build context, to respectively build the {{< html_link text="container image of Gravitee Cockpit's Management API" link="https://hub.docker.com/r/graviteeio/cockpit-management-api" >}} and the  {{< html_link text="container image of Gravitee Cockpit 's Web UI" link="https://hub.docker.com/r/graviteeio/cockpit-webui" >}}. Preparing those two folders, consists of creating files and eventually sufbfolders, in those two folders : the files required to run the docker builds.
  * runs a `dockerlint` on :
    * the `Dockerfile`s versioned in the {{< html_link text="gravitee-cockpit repo" link="https://github.com/gravitee-io/gravitee-cockpit" >}}
    * the `Dockerfile`s prepared in the previous __"Prepare Container Image Build"__ step
  * and finally runs the docker build and push to Docker Hub of the the {{< html_link text="container image of Gravitee Cockpit's Management API" link="https://hub.docker.com/r/graviteeio/cockpit-management-api" >}} and the  {{< html_link text="container image of Gravitee Cockpit 's Web UI" link="https://hub.docker.com/r/graviteeio/cockpit-webui" >}}. They are tagged with the semver version number, plus the `-nightly` suffix, e.g. `3.0.0-nightly`
  * __Work in progress__ Once the container images are ready on Dockerhub, a last phase will be triggered : the continuous deployment of the nightly Demo. This continuous deployment is performed :
    * using a git repo which defines the deployment target of the Gravitee Cockpit Nightly demo https://github.com/gravitee-lab/gravitee-cockpit-nightly-deployment (will become https://github.com/gravitee-io/gravitee-cockpit-nightly-deployment)
    * `pulumi config set cockpit-ui-oci-tag <newly released tag>`
    * gitops based
    * TODO : detailed schema of the mechanism

This continuous deployment:
* has a deployment target which is a Kubernetes Cluster provisioned in Azure AKS
* is performed using :
  * a `Helm` Chart currently defined in the `./cockpit/`, on the `cockpit` git branch of the {{< html_link text="Gravitee Helm Chart repo" link="https://github.com/gravitee-io/helm-charts/tree/cockpit/cockpit" >}},
  * and secret values currently defined in a {{< html_link text="temporary Gravitee repo named Cockpit Cloud" link="https://github.com/gravitee-io/cloud-cockpit" >}} : those values will, in the future, be securely stored with verisoning, in a secret manager, the `secrethub` used at Gravitee.io (consider it a SAAS offer for `HashiCorp Vault`).


Rolling update strategy problem :
* in our continuous deployment scenario, we have :
  * commits on master that produce a container image tag with the exact same tag
  * commits on master that produce different container images with different tags: example on commit on `master` produces the `3.0.0-nightly`, the next produces the `3.0.1-nightly`
* I may use a `kubectl rolling-update` with an `imagePullPolicy: Always` set with the `Helm` Chart's  values {{< html_link text="here" link="https://github.com/gravitee-io/helm-charts/blob/3a09fdf2a13318790e83f7b80e5484db2ce5be0d/cockpit/templates/api/api-deployment.yaml#L58" >}} and  {{< html_link text="there" link="https://github.com/gravitee-io/helm-charts/blob/cockpit/cockpit/templates/api/api-deployment.yaml#L58" >}}
* `pulumi preview --diff`
* use a `helm upgrade` with a pod strategy set to `Recreate` instead of the default `RollingUpdates` : https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy . There, the helm upgrade will updgrade a given helm release, from the currently deployed Cahrt version, to a new version of that chart, defined by the content of the localFolder (here because I am using a local folder to)


Will follow up https://github.com/pulumi/docs/issues/5012

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
  * no deployment target (zero infrastructure in any cloud provider)
  * but from the private docker registry, the development engineer can deploy on his own machine (watch Cicrlc CI and  trigger local deployment)
* when the manager wants to decide whether or not he accepts the pullrequest or not, he can launch the same process:
  * but then what happens is the same, but with a deployment in a cloud provider. (non dry-run)
  * actually, that process can be laucnhed every evening, and the manager gets the results everry morning.






## Misc. Cahracteristics
