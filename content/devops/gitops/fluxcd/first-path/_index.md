---
title: "Gravitee AM CI/CD Processes"
date: 2020-12-16T00:44:23+01:00
draft: false
menu_index: 1
showChildrenInMenu : true
nav_menu: "FluxCD: First Steps"
type: gitops-fluxcd
---

https://www.civo.com/learn/gitops-using-helm3-and-flux-for-an-node-js-and-express-js-microservice :
* but this aaproach seems outdated : ccc
* instead : https://toolkit.fluxcd.io/guides/helmreleases/

## Setup

0. _(on your workstation)_ Install `Kubectl`, and Helm 3
1. _(on your workstation)_ Install the whole Pulumi Stack
1. Create a Kubernetes Cluster :
  * with Pulumi (on Azure AKS)
  * or `k3d` (on your workstation)


#### 2. _(on your workstation)_ Install FluxCD CLI :


```bash
# binary installed to [/usr/local/bin]
curl -s https://toolkit.fluxcd.io/install.sh | sudo bash
```
#### 3. Create a GitHub repository for Flux : `gitops-gravitops`



#### 4. Install the `FluxCD` Gitops Toolkit

This mainly means runing the `bootstrap` command, and there are many different ways to run that bootstrap see https://toolkit.fluxcd.io/guides/installation/ )

```bash
# --- #
#
export GITHUB_TOKEN=<your-token>
export MY_GITOPS_BOT_GITHUB_USERNAME="Jean-Baptiste-Lasselle"
# The infra is a Cluster: what will be deployed to the cluster is an application called "lambda"
export GITOPS_GH_ORG_NAME="gravitee-lab"
export GITOPS_GH_REPO_NAME="lambda-staging-infra"

flux bootstrap github \
  --owner=${GITOPS_GH_ORG_NAME} \
  --repository=${GITOPS_GH_REPO_NAME} \
  --team=devops_team \
  --team=secops_team \
  --path=lambda-clusters/staging
  # --team=dev_team \

# When you specify a list of teams, those teams will be granted maintainer access to the repository.

```
to upgrade the fluxcd installed in your cluster, you just run again this bootstrap command (exactly the same), run :

```bash
# ---- #
# --- # Run again the bootstrap command, with same args
export GITHUB_TOKEN=<your-token>
export MY_GITOPS_BOT_GITHUB_USERNAME="Jean-Baptiste-Lasselle"
# The infra is a Cluster: what will be deployed to the cluster is an application called "lambda"
export GITOPS_GH_ORG_NAME="gravitee-lab"
export GITOPS_GH_REPO_NAME="lambda-staging-infra"

flux bootstrap github \
  --owner=${GITOPS_GH_ORG_NAME} \
  --repository=${GITOPS_GH_REPO_NAME} \
  --team=devops_team \
  --team=secops_team \
  --path=lambda-clusters/staging
  # --team=dev_team \

# --- # Then tell flux to sync itself
flux reconcile source git flux-system
# --- #  Check the upgrade actually happened
flux check
```
* You can uninstall `Flux` with:

```bash
flux uninstall --namespace=flux-system
# # If you've installed Flux in a namespace that you wish to preserve, you can skip the namespace deletion with:
# flux uninstall --namespace=infra --keep-namespace
```

#### 4. `Helm` / `FluxCD` Setup

Main doc Reference : https://toolkit.fluxcd.io/guides/helmreleases/

Helm Charts can be released with `FluxCD`, using either :
* an actual Helm Repository,
* or a git repository versioning the `Helm Chart`
* or an S3 Bucket publishing the Helm Chart

I will Choose using a git repository, and therefore I will use a `FluxCD` `CRD` named `GitRepository` :






```bash
# --- #
#   In the https://github.com/gravitee-lab/helm-charts git repository, there is :
# => The helm Chart of the "Kappa" Application, in the "./kappa" folder
# => The helm Chart of the "Lambda" Application, in the "./lambda" folder
# --- #
cat <<EOF >./lambda-helm-chart-repo.yaml
apiVersion: source.toolkit.fluxcd.io/v1beta1
kind: GitRepository
metadata:
  name: lambda-helm-repo
  namespace: flux-system
spec:
  interval: 1m
  url: https://github.com/gravitee-lab/helm-charts
  ref:
    branch: master
  ignore: |
    # exclude all
    /*
    # include charts directory
    !/charts/
EOF

```

Here I will use the git flow to control the versions of the Helm Chart I publish on `master` git branch : thanks to the git glow, all commits are releases.

In the case of a git repository like above, the bet thing will be to use a webhook and any commit on the master git branch will trigger the Helm Release :

* https://toolkit.fluxcd.io/guides/webhook-receivers/
* We wil then have a push stategy, instead of a pull strategy => this increases

Ok, so now that I have defined the `HelmRepository` from which the Helm Chart is pulled, then I need to create a FluxCD Kubernetes Custom Resource Definition named  `HelmRelease` :


```bash
# --- #
#   In the https://github.com/gravitee-lab/helm-charts git repository, there is :
# => The helm Chart of the "Kappa" Application, in the "./kappa" folder
# => The helm Chart of the "Lambda" Application, in the "./lambda" folder
# --- #
cat <<EOF >./lambda-helm-release.yaml
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: lambda
  namespace: default
  annotations:
    fluxcd.io/automated: "true"
    filter.fluxcd.io/chart-image: semver:~0.3
spec:
  interval: 5m
  chart:
    spec:
      chart: ./gravitee-lab-helm-charts/lambda/
      version: '4.0.x'
      sourceRef:
        # kind: <HelmRepository|GitRepository|Bucket>
        kind: GitRepository
        name: lambda-helm-repo
        namespace: flux-system
      interval: 1m
  values:
    replicaCount: 2
EOF

kubectl apply -f ./lambda-helm-release.yaml

```

Above :
* Instead of `kind: GitRepository`, we could have `kind: HelmRepository`, `kind: Bucket`
* If the Chart "source" (where `FluxCD` finds the Helm Chart) :
  * is a git repository, or a S3 Bucket, `chart: ./gravitee-lab-helm-charts/lambda/` gives a path within the S3 Bucket or the git reprository
  * is a Helm Repository, the `chart: <value here>` value must be the name of the Helm Chart in the Helm Repository.
  * the `chart: <value here>` value can also be The relative path the chart package can be found at in the `GitRepository` or `Bucket`, for example: `./charts/podinfo-1.2.3.tgz`
* The values can be redefined as shown above, but also can be redefined from a `Kubernetes` `ConfigMap` and from `Kubernetes` `Secret`s :

```bash
# --- #
#   In the https://github.com/gravitee-lab/helm-charts git repository, there is :
# => The helm Chart of the "Kappa" Application, in the "./kappa" folder
# => The helm Chart of the "Lambda" Application, in the "./lambda" folder
# --- #
cat <<EOF >./lambda-helm-release.yaml
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: lambda
  namespace: default
  annotations:
    fluxcd.io/automated: "true"
    filter.fluxcd.io/chart-image: semver:~0.3
spec:
  interval: 5m
  chart:
    spec:
      chart: ./gravitee-lab-helm-charts/lambda/
      version: '4.0.x'
      sourceRef:
        # kind: <HelmRepository|GitRepository|Bucket>
        kind: GitRepository
        name: lambda-helm-repo
        namespace: flux-system
      interval: 1m
    spec:
      valuesFrom:
      - kind: ConfigMap
        name: prod-env-values
        valuesKey: values-prod.yaml
      - kind: Secret
        name: prod-tls-values
        valuesKey: crt
        targetPath: tls.crt

EOF

```

For the values redefined above using `valuesFrom` :
* `valuesKey` is the Key in the  `Kubernetes` `ConfigMap` or from `Kubernetes` `Secret`
* the `targetPath` must be of the exact same format as when using the `--set <same as targetPath>=<value>` with the `helm` command line binary.
* The values set by the list defined in the `valuesFrom` are merged with the "next overrides previous" rule (so the last overrides all previous) :  this is why it is natural to specify first a ConfigMap for non secret values, and then Kubernetes Secrets to override Secrets values.

#### Semantic Versioning of Helm Charts

First Dixit the `FluxCD` documentation :

>
> `Helm` repositories are the recommended source to retrieve `Helm` charts from, as they are lightweight in processing and make it possible to configure a semantic version selector for the chart version that should be released.
>


Ok, now here is what I want to try and test  :



_**TEST 1: semver Helm Chart**_

I use the semantic versioning notation `4.0.x`, and in my git repo :
* I release versions `4.0.2`, wait 3 minutes to see if `4.0.2` is deployed
* I then release versions `4.0.3`, wait 3 minutes to see if `4.0.3` is deployed


```bash
# --- #
#   In the https://github.com/gravitee-lab/helm-charts git repository, there is :
# => The helm Chart of the "Kappa" Application, in the "./kappa" folder
# => The helm Chart of the "Lambda" Application, in the "./lambda" folder
# --- #
cat <<EOF >./lambda-helm-release.yaml
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: lambda
  namespace: default
  annotations:
    fluxcd.io/automated: "true"
    filter.fluxcd.io/chart-image: semver:~0.3
spec:
  interval: 5m
  chart:
    spec:
      chart: ./gravitee-lab-helm-charts/lambda/
      version: '4.0.x'
      sourceRef:
        # kind: <HelmRepository|GitRepository|Bucket>
        kind: GitRepository
        name: lambda-helm-repo
        namespace: flux-system
      interval: 1m
  values:
    replicaCount: 2
EOF

kubectl apply -f ./lambda-helm-release.yaml

```

_**TEST 2: semver docker image**_


I use the semantic versioning notation `4.0.x`, and in my git repo :
* I release versions `4.0.7`, of my Helm Chart in the Git repo,
* I docker build and docker push the `quay.io/gravitee-lab/lambda:0.3.5` Docker image
* and then only create the `HelmRelease` like below
* I then docker build and docker push the `quay.io/gravitee-lab/lambda:0.3.6` Docker image : and I see f the docker image is rolled up



```bash
# --- #
#   In the https://github.com/gravitee-lab/helm-charts git repository, there is :
# => The helm Chart of the "Kappa" Application, in the "./kappa" folder
# => The helm Chart of the "Lambda" Application, in the "./lambda" folder
# --- #
cat <<EOF >./lambda-helm-release.yaml
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: lambda
  namespace: default
  annotations:
    fluxcd.io/automated: "true"
    filter.fluxcd.io/chart-image: semver:~0.3
spec:
  interval: 5m
  chart:
    spec:
      chart: ./gravitee-lab-helm-charts/lambda/
      version: '4.0.7'
      sourceRef:
        # kind: <HelmRepository|GitRepository|Bucket>
        kind: GitRepository
        name: lambda-helm-repo
        namespace: flux-system
      interval: 1m
  values:
    replicaCount: 2
    ingress:
      enabled: false
    image: quay.io/gravitee-lab/lambda:0.3.5
EOF

kubectl apply -f ./lambda-helm-release.yaml

```

Ok, but this kind of image automated update is wrong :
* It is incomlplete
* What I really want is setting up A complete workflow, different for staging cluster, and production cluster, like explained here : https://toolkit.fluxcd.io/guides/image-update/




Now, in this part, What the question is : Automated updates of HElm Chart version, How to manage that ? The answers in new Version of FluxCD is:
* Automatic updates should only happens on patch versions :
  * minor and major version by definition contain breaking changes
  * If not autmatic , how to manage upgrade minor or major version ? One question we may answer, and upgrade scripts for databases are the beginning of an answer there, to automate that, and that automation should happen with a Gravitee developed Kubernetes Operator
* Use version `4.0.x` sermver notation, and use a Real HElm Repository as source, not a git repository or an S3 Bucket :
  * Because real Helm Repositories have metadata that FluxCD can scan, ok
  * So I wil try and set up somethig like a ChartMuseum Service to tests, and will also try and use the Gravitee Helm Charts Repositories



#### Automatic container images workflows

**Production CICD Workflow**

<ul>
<li>DEV: push a bug fix to the app repository</li>
<li>DEV: bump the patch version and release e.g. <code>v1.0.1</code></li>
<li>CI: build and push a container image tagged as <code>registry.domain/org/app:v1.0.1</code></li>
<li>CD: pull the latest image metadata from the app registry (Flux image scanning)</li>
<li>CD: update the image tag in the app manifest to <code>v1.0.1</code> (Flux cluster to Git reconciliation)</li>
<li>CD: deploy <code>v1.0.1</code> to production clusters (Flux Git to cluster reconciliation)</li>
</ul>

**Staging CICD Workflow**

<ul>
<li>DEV: push code changes to the app repository <code>main</code> branch</li>
<li>CI: build and push a container image tagged as <code>${GIT_BRANCH}-${GIT_SHA:0:7}-$(date +%s)</code></li>
<li>CD: pull the latest image metadata from the app registry (Flux image scanning)</li>
<li>CD: update the image tag in the app manifest to <code>main-2d3fcbd-1611906956</code> (Flux cluster to Git reconciliation)</li>
<li>CD: deploy <code>main-2d3fcbd-1611906956</code> to staging clusters (Flux Git to cluster reconciliation)</li>
</ul>





#### Integrations : Notifiactions to `Slack`, and Gihtub git commit status

Next I will consider configuring notificatios to slack :

* https://toolkit.fluxcd.io/guides/notifications/#define-a-provider


#### Other big Subject : FluxCD / HashiCorp Vault Integrations

Or `FluxCD` / `Secret Manager` integrations


#### FluxCD and ArgoCD

They are together creating one common thng : "gitops engine".

Why they decided that? it's because ArgoCD has features that FluxCD does not have, and FluxCD ahs features that ArgoCD does not have, e.g. :

One thing `ArcgoCD` has , and not Flux CD : "multi phase" apply, useful because of webhooks (so several yamlmanifest, but you have to wait i thik for a hook to ... see also hel m chart hooks ?)

`ArgoCD` does not do image automatic updates / container registry scanning

#### And Opening Subject : FluxCD and my company's Kubernetes Operator(s)


Ok, now what integrations can we think of, between automation brought by FluxCD, and Gravitee Kubernetes Operator ?

Example of question :

* Kappa develops the Kappa API
* Kappa has chosen Gravtiee as API Gateway
* Kappa Uses FluxCD to automate deployment of its API
* So FLuxCD should Use the Gravitee Kubernetes Operator/Controller to trigger automation of  ?
* Ok when automating Docker image update, FluxCD edits the Yaml delfinition of `kind: HelmRelease`
  * When a new patch version of a Gravitee CRD, FluxCD should also edits the Yaml delfinition of `kind: HelmRelease` of the Gravitee Helm Chart (which includes the CRDs by default) ?
  * Ok so within the Helm Chart of Graitee, we have the version of the Docker images, and well we will have the version of the CRDs? Actually somewhere whe I make it understood, this will be about the Kubernetes Operator (CRDs will be in Helm Chart of the Gravitee Kubernetes Operator, and there will be autoamted updates of CRDs patches)











#### `FluxCD` Transactional mechanism


* You make 5 commits, and then just one git push
* Then if on of the commits makes the deployment fail, then all 5 commits are cancelled


How can Flux Roll back an application ? :
* Deployement may happen wihtout errors, but the applciation is bad, it has bad metrics
* Flagger allows decisding, based on metrcs like prometheus metrics, to roll back the deployment

















```bash


cat <<EOF >./lambda-helm-release.yaml
apiVersion: helm.fluxcd.io/v1
kind: HelmRelease
metadata:
  name: expressjs-k8s
  annotations:
    fluxcd.io/automated: "true"
    filter.fluxcd.io/chart-image: semver:~0.3
spec:
  chart:
    repository: https://alexellis.github.io/expressjs-k8s/
    name: expressjs-k8s
    version: 0.1.1
  values:
    ingress:
      enabled: false
    image: alexellis2/service:0.3.5
EOF

```






























4. Create the `HelmRepository` CRD into the Kuebrentes Cluster :

```bash

cat <<EOF >./helm-repository-crd.yaml
apiVersion: source.toolkit.fluxcd.io/v1beta1
kind: HelmRepository
metadata:
  name: podinfo
  namespace: flux-system
spec:
  # --- #
  # The interval defines at which interval the
  # Helm repository index is fetched, and should be at least 1m
  # --- #
  # this is a pull based approach. It's possible to go push based, using https://toolkit.fluxcd.io/guides/webhook-receivers/
  interval: 1m
  url: https://stefanprodan.github.io/podinfo

EOF

kubectl apply -f ./helm-repository-crd.yaml

```

4. Install the HelmRelease Kubernetes Custom Resource Definition (or CRD) :

```bash
```

3. Use Github API Token to setup FluxCD link between cluster and repo :

```bash

# Verify that my staging cluster satisfies the prerequisites
kubectl cluster-info
flux check --pre

export SECRETHUB_ORG=graviteeio
export SECRETHUB_REPO=cicd
# FluxCD bootstrap: creates the git repository if one doesn't exist
# can be done with Gitlab as well as Github
export GRAVITEEBOT_GH_API_TOKEN=$(secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/github_personal_access_token")
export GRAVITEEBOT_GH_USERNAME=graviteeio

export GITHUB_TOKEN=${GRAVITEEBOT_GH_API_TOKEN}
export GITHUB_USER=${GRAVITEEBOT_GH_USERNAME}

# this one below will use a personal git repository of the Github User
# flux bootstrap github \
  # --owner=${GITHUB_USER} \
  # --repository=fleet-infra \
  # --branch=main \
  # --path=./clusters/my-cluster \
  # --personal

# But what we want is a git repository in the gravitee-lab Organization
export GITHUB_ORG="gravitee-lab"
export GIT_BRANCH="master"
export GIT_REPO_NAME="gitops-gravitops"


flux bootstrap github \
  --owner=${GITHUB_ORG} \
  --repository=gitops-gravitops \
  --branch=${GIT_BRANCH} \
  --team=devops \
  --team=devsecops \
  # --team=<team3-slug> \
  --path=./clusters/gravitops-cluster


export WHEREIWORK=$(mktemp -d -t "whereiwork-XXXXXXXXXX")
git clone gti@github.com:${GITHUB_ORG}/${GIT_REPO_NAME} ${WHEREIWORK}

cd ${WHEREIWORK}

git checkout ${GIT_BRANCH}

# the below flux command justs generates a yaml manifest to deploy to the cluster
flux create source git gravitops_podinfo \
  --url=https://github.com/stefanprodan/podinfo \
  --branch=master \
  --interval=30s \
  --export > ./clusters/gravitops-cluster/podinfo-source.yaml

git add -A && git commit -m "Add podinfo GitRepository" && git push -u origin master

git checkout -b staging && git push -u origin HEAD

echo "So here what I can do is render the Gravitee Helm into Yaml to integrate into FluxCD "
echo "But What I want is that it generates the CRDs from gravtiee-kubernetes"

# to be continued :
# https://toolkit.fluxcd.io/get-started/#deploy-podinfo-application



```


#### Future of GRavitee CRDs?

Well we should have CRDs to create Alert Engine Alerts for example, so many ideas...

To all those tresources, there should be prometheus metrics associated (prometheus exporters)



# The gravitee nightly with gitops

Refiare Toutes les nigtly en mode gitops





####


faire fluxcd flagger canary A/B testing

autre gros objectif  :
* dans https://github.com/stefanprodan/gitops-istio : remplacer istio par gravitee , faire le comparatif
* est-ce que gravitee supporte blue green / canary / comparatif à istio/ quels implementations futures pour aller dans ce sens ? graavitee kubernetes là dedans ?

* Comment on peut fair du canary / du blue green déployments d'appli microservices, alors que les API  sont gérées par Gravitee ?
* est-ce que CRD GRavitee Kuernetes peret de faire du blue green, du canary avec vos APIs ?
