---
title: "Gravitee AE Release"
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "CI/CD Processes"
menu: ae_processes
menu_index: 8
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: am-processes
---

## Process Description

* The `release.json` etc..


## How to: Perfom a Release

The Release process of the gravitee kubernetes repsoitory can be launcched by 2 means :
* either the Orchestrator launches it, in an ORchestrated release process of APIM
* or you want to perform the release on the gravitee-kubernetes repsoitory alone, out of any APIM release process:
  * Regarding the gravitee-kubernetes repository itself
* Or you can trigger it yoruself, using the exact same Circle CI API Clal the orchestrator uses : I called this the "Standalone release"

### Test the Orchestrated Release Process


* To indivudually (re-)launch the Release process with a `curl`, just for `gravitee-kubernetes`, and jsut as if it had been launched by the Orchestrator :
  * create the prepared-nexus-staging-gravitee-kubernetes-for-tests S3 Bucket : hum, use the `test_mode` "test mode" (set to true and s3 bucket automatically created at the beginning of the process ?). Oh no, create the bucket if and only if it does not already exist (so test if it exists with s3cmd)
  * and run :

```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-kubernetes"
export BRANCH="master"
export S3_BUCKET_NAME="prepared-nexus-staging-gravitee-apim-3_6_1"
export S3_BUCKET_NAME="prepared-nexus-staging-gravitee-kubernetes-3_6_1"
export S3_BUCKET_NAME="prepared-nexus-staging-gravitee-kubernetes-for-tests"

export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"release\",
        \"dry_run\": true,
        \"secrethub_org\": \"graviteeio\",
        \"secrethub_repo\": \"cicd\",
        \"s3_bucket_name\": \"prepared-nexus-staging-gravitee-apim-${S3_BUCKET_NAME}\",
        \"maven_profile_id\": \"gravitee-release\"
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```


### Launch the Standalone Release


* To indivudually (re-)launch the Release process with a `curl`, just for `gravitee-kubernetes` :

```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-kubernetes"
export BRANCH="master"
export S3_BUCKET_NAME="prepared-nexus-staging-gravitee-apim-3_6_1"
export S3_BUCKET_NAME="prepared-nexus-staging-gravitee-kubernetes-3_6_1"

export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"release\",
        \"dry_run\": true,
        \"secrethub_org\": \"graviteeio\",
        \"secrethub_repo\": \"cicd\",
        \"s3_bucket_name\": \"prepared-nexus-staging-gravitee-apim-${S3_BUCKET_NAME}\",
        \"maven_profile_id\": \"gravitee-release\"
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```






### Launch the Dry run

### Launch the Release

### Resume the Release


## Misc. Cahracteristics
