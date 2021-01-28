---
title: "Test Accessing the current Cockpit Cluster"
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "Standard Operations"
menu: devops_gitops_cicd
menu_index: 21
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: devops-gitops-cicd
---


## Test overview

For this test,I have created a cluster, and just waant to test if other Active Directory Users can have access to it with `kubectl`

* First You wil docker build a container image "with every thing you need inside, zero  requirement on your machine, but docker"
* Then you will login into Azure Active Directory
* After that, you will retireve the KubeConfig fromAzure
* And Finally have a look inside of the cluster.

To do all this, you need to be given only one information, which is not a "very secret one" :  the AKS Cluster name, which is for this test, `aksClusterb49b690` (cute).

Bonus:the cluster here has 2 Ingress Cntrollers, completeley independent, each in its own K8S namespace, and each its own public IP Address


## Test commands

* Build the container image :

```bash
export DESIRED_VERSION="AKS_RBAC_EPISODE1"
# folder must be empty, path is up to you
export UR_PROJECT_HOME=$(pwd)/cockpit-on-aks-testing-rbac-az-ad-integration

git clone git@github.com:gravitee-lab/cockpit-on-azure-aks.git ${UR_PROJECT_HOME}
cd ${UR_PROJECT_HOME}

git checkout "${DESIRED_VERSION}"


cd docs/issues-n-tips/4.sharing-aks-kubeconfig/

docker build -t graviteeio/kubectl:azure-0.0.1 .
docker run -itd --name devops-bubble graviteeio/kubectl:azure-0.0.1
```

* Login into Azure Active Directory :

```bash
# container, this will work anyway,just as if on your own machine
docker exec -it devops-bubble bash -c 'az login --use-device-code'
docker exec -it devops-bubble bash -c 'export PATH="${PATH}:${HOME}/bin" && az account list'
docker exec -it devops-bubble bash -c 'ls -allh ~/.azure'
```

* Retrieve the KubeConfig fromAzure :

```bash
export AKS_CLUSTER_NAME="aksClusterb49b690"
docker exec -it devops-bubble bash -c  "export AKS_CLUSTER_RESOURCE_GROUP=\$(az aks list | jq --arg CLUSTER_NAME ${AKS_CLUSTER_NAME} '.[]|select(.name == \$CLUSTER_NAME)' | jq .resourceGroup | awk -F '\"' '{print \$2}') && echo AKS_CLUSTER_RESOURCE_GROUP=\${AKS_CLUSTER_RESOURCE_GROUP}"
export AKS_CLUSTER_RESOURCE_GROUP=$(docker exec -it devops-bubble bash -c  "az aks list | jq --arg CLUSTER_NAME ${AKS_CLUSTER_NAME} '.[]|select(.name == \$CLUSTER_NAME)' | jq .resourceGroup | awk -F '\"' '{print \$2}'" | awk -F '\r' '{print $1}')
docker exec -it devops-bubble bash -c  "az aks get-credentials --resource-group ${AKS_CLUSTER_RESOURCE_GROUP} --name ${AKS_CLUSTER_NAME}"

```

* And now Have a look inside of the cluster :

```bash
# A look into the default namespace
docker exec -it devops-bubble bash -c  "kubectl get all"
# Check extra Args and NodeSelectors etc...
docker exec -it devops-bubble bash -c  "kubectl describe pods -l app=nginx-ingress-nginx-ingress"

```
