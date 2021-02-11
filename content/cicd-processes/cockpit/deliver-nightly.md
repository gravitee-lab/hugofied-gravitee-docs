---
<<<<<<< HEAD
title: "Gravitee Cockpit Deliver Nightly Demo"
=======
title: "Cockpit Deliver Nightly Demo"
>>>>>>> 18ab699910d5cb101a38b1c05631235554fad70a
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

<<<<<<< HEAD
=======
## Rolling update of the Gravitee Cockpit on Azure AKS with Pulumi
>>>>>>> 18ab699910d5cb101a38b1c05631235554fad70a

Rolling update strategy problem :
* in our continuous deployment scenario, we have :
  * commits on master that produce a container image tag with the exact same tag
  * commits on master that produce different container images with different tags: example on commit on `master` produces the `3.0.0-nightly`, the next produces the `3.0.1-nightly`
* I may use a `kubectl rolling-update` with an `imagePullPolicy: Always` set with the `Helm` Chart's  values {{< html_link text="here" link="https://github.com/gravitee-io/helm-charts/blob/3a09fdf2a13318790e83f7b80e5484db2ce5be0d/cockpit/templates/api/api-deployment.yaml#L58" >}} and  {{< html_link text="there" link="https://github.com/gravitee-io/helm-charts/blob/cockpit/cockpit/templates/api/api-deployment.yaml#L58" >}}
* `pulumi preview --diff`
* use a `helm upgrade` with a pod strategy set to `Recreate` instead of the default `RollingUpdates` : https://kubernetes.io/docs/concepts/workloads/controllers/deployment/#strategy . There, the helm upgrade will updgrade a given helm release, from the currently deployed Cahrt version, to a new version of that chart, defined by the content of the localFolder (here because I am using a local folder to)


Will follow up https://github.com/pulumi/docs/issues/5012

<<<<<<< HEAD
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
=======

#### Idea  1 (stupid)

* I will use 2 docker iamge tags to rolling update the nightly demo : `3.0.0-nightly`, and `3.0.0-nightly-previous`
* then I will roll up `3.0.0-nightly` and `3.0.0-nightly-previous` tags :

```bash

# --
# Before this, the Circle CI pipeline finished docker build of [graviteeio/cockpit-management-api:3.0.0]
# --
docker pull graviteeio/cockpit-management-api:3.0.0-nightly
docker tag graviteeio/cockpit-management-api:3.0.0-nightly graviteeio/cockpit-management-api:3.0.0-nightly-previous
docker push graviteeio/cockpit-management-api:3.0.0-nightly-previous

docker rmi graviteeio/cockpit-management-api:3.0.0-nightly graviteeio/cockpit-management-api:3.0.0-nightly-previous
# --
# now we "nightly"-tag the newly built image ofGravitee Cockpit Management API
docker tag graviteeio/cockpit-management-api:3.0.0 graviteeio/cockpit-management-api:3.0.0-nightly
# And push it to Dockerhub
docker push graviteeio/cockpit-management-api:3.0.0-nightly


# --
# Before this, the Circle CI pipeline finished docker build of [graviteeio/cockpit-webui:3.0.0]
# --
docker pull graviteeio/cockpit-webui:3.0.0-nightly
docker tag graviteeio/cockpit-webui:3.0.0-nightly graviteeio/cockpit-webui:3.0.0-nightly-previous
docker push graviteeio/cockpit-webui:3.0.0-nightly-previous

docker rmi graviteeio/cockpit-webui:3.0.0-nightly graviteeio/cockpit-webui:3.0.0-nightly-previous
# --
# now we "nightly"-tag the newly built image ofGravitee Cockpit Web UI
docker tag graviteeio/cockpit-webui:3.0.0 graviteeio/cockpit-webui:3.0.0-nightly
# And push it to Dockerhub
docker push graviteeio/cockpit-webui:3.0.0-nightly
```

* Then I will :
  * pulumi up with the image tag `3.0.0-nightly-previous`
  * and pulumi up with the image tag `3.0.0-nightly`
  * Note this might work, But is kind of stupid to be doomed to `pulumi up` twice to "flip image tags" : to begin with it is twice too long

#### Idea 2 Using labels

Here is the idea :

* We add a new label to the `kind: Deployment` `Helm` template for, named `app.gravitee.io/git_commit_id` :
  * for Gravitee Cockpit Management API, to add in `cockpit/templates/api/api-deployment.yaml`, at the [pod spec level](https://github.com/gravitee-io/helm-charts/blob/3a09fdf2a13318790e83f7b80e5484db2ce5be0d/cockpit/templates/api/api-deployment.yaml#L33)
  * for Gravitee Cockpit Web UI, to add in `cockpit/templates/ui/ui-deployment.yaml`, at the [pod spec level](https://github.com/gravitee-io/helm-charts/blob/3a09fdf2a13318790e83f7b80e5484db2ce5be0d/cockpit/templates/ui/ui-deployment.yaml#L31)
* We add a new parameter in the `values.yaml` file, named `api.git_commit_id` : it has no default value (setting its value with `--set` is required), and sets the value of the `app.gravitee.io/git_commit_id: "{{ .Values.api.git_commit_id }}"` pod label in `cockpit/templates/api/api-deployment.yaml`.
* We add a new parameter in the `values.yaml` file, named `ui.git_commit_id` : it has no default value (setting its value with `--set` is required), and sets the value of the `app.gravitee.io/git_commit_id: "{{ .Values.ui.git_commit_id }}"` pod label in `cockpit/templates/ui/ui-deployment.yaml`.

Ok, so I will have to fork the https://github.com/gravitee-io/helm-charts/ to modify the Cockpit Helm Chart

* In the Circle CI Pipeline, The `Pulumi` recipe sets the value of `api.git_commit_id` and the `ui.git_commit_id` Helm deployment, on the fly with the GIT_COMMIT_ID (SHA), obtianed fromthe lastcommit on `master` branch
* For the `GIT_COMMIT_ID`, I will use `git rev-parse --short=15 HEAD` to get the 15 first digits of the commit HASH, instead of the 7 first digits obtained with `git rev-parse --short HEAD`

* We will set the pod strategy to `Recreate` if `ImagePullPolicy: Always` is not enough

Finally I will use the new stack config parameter `graviteeio:git_commit_id`, to set the value in the stack, and trigger a change in the pulumi stack, to an update :

```bash
export LOCAL_CHART_FOLDER=./.cockpit.charts/
export DOCKER_IMAGE_TAG="3.0.0-nightly"
export API_DOCKER_IMAGE_TAG=$(docker images | grep "graviteeio/cockpit-management-api" | awk '{print $2}')
export UI_DOCKER_IMAGE_TAG=$(docker images | grep "graviteeio/cockpit-management-api" | awk '{print $2}')
if ! [ "${API_DOCKER_IMAGE_TAG}" == "${UI_DOCKER_IMAGE_TAG}" ]; then
  echo "Cockpit UI and Management API Docker images have different tags, we have a problem."
  exit 7
fi;
export DOCKER_IMAGE_TAG=${API_DOCKER_IMAGE_TAG}

export GIT_COMMIT_ID="$(git rev-parse --short=15 HEAD)"
echo "GIT_COMMIT_ID=[${GIT_COMMIT_ID}]"
pulumi config -s "${PULUMI_STACK_NAME}" set graviteeio:localChartFolder "${LOCAL_CHART_FOLDER}"
pulumi config -s "${PULUMI_STACK_NAME}" set graviteeio:docker_image_tag "${DOCKER_IMAGE_TAG}"
pulumi config -s "${PULUMI_STACK_NAME}" set graviteeio:api_git_commit_id "${GIT_COMMIT_ID}"
```

Everytime the pipeline is triggered :
* the pulumi stack config will be updated with the docker image tag and the git commit id, modifying every time, at least because of the git commit id in the `Pulumi.${PULUMI_STACK_NAME}.yaml` file
* and a git commit with the modified `Pulumi.${PULUMI_STACK_NAME}.yaml` file, will be pushed to https://github.com/gravitee-lab/gravitee-cockpit-nightly-deployment, and then:
  * either the Circle CI Pipeline in the https://github.com/gravitee-lab/gravitee-cockpit-nightly-deployment repo, triggered by the pushed commit, executes the `pulumi up --yes -s ${PULUMI_STACK_NAME}`
  * or we have an additional approve workflow, which will git clone the git@github.com:gravitee-lab/gravitee-cockpit-nightly-deployment repo, `git checkout master`, and executes the `pulumi up --yes -s ${PULUMI_STACK_NAME}`

Antoher more refined, and more gitops-complant, and wost-saving, workflow would be :
* create a new git branch named `deployment-${GIT_COMMIT_ID}`, from `master`, in the https://github.com/gravitee-lab/gravitee-cockpit-nightly-deployment repo,
* push the git commit to the  `deployment-${GIT_COMMIT_ID}` git branch,
* create a Pull Request from the  `deployment-${GIT_COMMIT_ID}` git branch, tothe `master`, in the https://github.com/gravitee-lab/gravitee-cockpit-nightly-deployment
* the PR is accepted, and the CircleCI Pipeline , in the https://github.com/gravitee-lab/gravitee-cockpit-nightly-deployment repo, on `master`, triggers a Circle CI workflow which executes the pulumi up with the updated `Pulumi.${PULUMI_STACK_NAME}.yaml`

## Misc. notes on the `Pulumi`

The `Gravitee Cockpit` uses MTLS to communicate with `Gravitee APIM` and `Gravitee AM` :
* Through websocket
* The `Gravitee Cockpit` exposes the websocket server
* `Gravitee APIM` and `Gravitee AM` ar equiped with a websocket client, and they establish a websocket connection, with Mutual TLS (MTLS) authentication, with the `Gravitee Cockpit`

Helm Charts :
* Nginx :
  * ccc
  * ccc
* Gravitee Cockpit Helm Chart :
  * a `Helm` Chart currently defined in the `./cockpit/`, on the `cockpit` git branch of the {{< html_link text="Gravitee Helm Chart repo" link="https://github.com/gravitee-io/helm-charts/tree/cockpit/cockpit" >}},
  * and secret values currently defined in a {{< html_link text="temporary Gravitee repo named Cockpit Cloud" link="https://github.com/gravitee-io/cloud-cockpit" >}} : those values will, in the future, be securely stored with verisoning, in a secret manager, the `secrethub` used at Gravitee.io (consider it a SAAS offer for `HashiCorp Vault`).
>>>>>>> 18ab699910d5cb101a38b1c05631235554fad70a
