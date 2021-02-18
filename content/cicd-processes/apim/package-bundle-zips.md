---
title: "Package Bundle (Zips)"
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "CI/CD Processes"
menu: apim_processes
menu_index: 3
product: "Gravitee APIM"
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: apim-processes
---

## Process Description

Build the zip files and deploy them to https://download.gravitee.io




## How to run

* launch the package bundle for a given Gravitee.io Release :


```bash
export CCI_TOKEN=<your Circle CI Token>
export GRAVITEE_RELEASE_VERSION="3.3.0"
export ORG_NAME="gravitee-io"
export REPO_NAME="release"
export BRANCH="3.3.x"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"publish_bundles\",
        \"gio_release_version\": \"${GRAVITEE_RELEASE_VERSION}\"
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```


## Migrate the legacy https://download.gravitee.io


* To migrate all legacy https://downloads.gravitee.io to the new s3 Bucket `ccc` :

```bash
export CICD_LIB_OCI_REPOSITORY_ORG=${CICD_LIB_OCI_REPOSITORY_ORG:-"quay.io/gravitee-lab"}
export CICD_LIB_OCI_REPOSITORY_NAME=${CICD_LIB_OCI_REPOSITORY_NAME:-"cicd-s3cmd"}
export S3CMD_CONTAINER_IMAGE_TAG=${S3CMD_CONTAINER_IMAGE_TAG:-"stable-latest"}
export S3CMD_DOCKER="${CICD_LIB_OCI_REPOSITORY_ORG}/${CICD_LIB_OCI_REPOSITORY_NAME}:${S3CMD_CONTAINER_IMAGE_TAG}"

docker pull "${S3CMD_DOCKER}"

# ---
# this is where all the files that you want to send (or sync) to
# the s3 bucket are on the VM filesystem
export ABSOLUTE_PATH_OF_LEGACY_CONTENT=/opt/dist/dist.gravitee.io/


# The s3cmd configuration files, which includes the credentials
mkdir -p ./.s3cmd

export SECRETHUB_ORG=graviteeio
export SECRETHUB_REPO=cicd

secrethub read --out-file ./.s3cmd/config "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/infra/zip-bundle-server/clever-cloud-s3/s3cmd/config"

# I need 2 volumes : one to map the s3cmd config file, one for the bucket
docker run -itd --name devops-bubble -v $PWD/.s3cmd/config:/root/.s3cfg -v /opt/dist/dist.gravitee.io:/gio/devops/bucket "${S3CMD_DOCKER}" bash
export S3_BUCKET_NAME="gravitee-releases-downloads"
docker exec -it devops-bubble bash -c "s3cmd sync --acl-public /gio/devops/bucket/ s3://${S3_BUCKET_NAME}/"

```
