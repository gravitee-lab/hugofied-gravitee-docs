---
title: "Gravitee AM CI/CD Processes"
date: 2020-12-16T00:44:23+01:00
draft: false
menu_index: 1
showChildrenInMenu : true
nav_menu: "FLuxCD: First Steps"
type: gitops-fluxcd
---



## Setup

0. Install Kubectl
1. Install the whole Pulumi Stack
1. Create a Kuerbetes Cluster with Pulumi
2. Install FLuxCD CLI :

```bash
# binary installed to [/usr/local/bin]
curl -s https://toolkit.fluxcd.io/install.sh | sudo bash
```
3. Use Github API Tkone to setup FluxCD link between cluster and repo :

```bash

# Verify that my staging cluster satisfies the prerequisites
kubectl cluster-info
flux check --pre


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
  --team=secops \
  # --team=<team3-slug> \
  --path=./clusters/graviops-cluster


export WHEREIWORK=$(mktemp -d -t "whereiwork-XXXXXXXXXX")
git clone gti@github.com:${GITHUB_ORG}/${GIT_REPO_NAME} ${WHEREIWORK}

cd ${WHEREIWORK}

git checkout ${GIT_BRANCH}

# the below flux command justs generates a yaml manifest to deploy to the cluster
flux create source git gravitops_podinfo \
  --url=https://github.com/stefanprodan/podinfo \
  --branch=master \
  --interval=30s \
  --export > ./clusters/graviops-cluster/podinfo-source.yaml

git add -A && git commit -m "Add podinfo GitRepository" && git push -u origin master

git checkout -b staging && git push -u origin HEAD

echo "So here waht I can do is render the Gravitee Helm into Yaml to integrate into FluxCD "
echo "But What I want is that it generates the CRDs from gravtiee-kubernetes"

# to be continued :
# https://toolkit.fluxcd.io/get-started/#deploy-podinfo-application



```
