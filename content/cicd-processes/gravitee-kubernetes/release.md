---
title: "Gravitee Kubernetes Release"
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "CI/CD Processes"
menu: apim_processes
menu_index: 8
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: apim-processes
---

## Process Description

* The `release.json` etc..

## How to: Perfom a Release


The Release process of the gravitee kubernetes repository can be launched by 2 means :
* Either you release it within an APIM release (Gravitee APIM Orchestrated release CICD Process) :
  * Then the Orchestrator launches it, in an Orchestrated release process of APIM
  * Or you can trigger it yoruself, using the exact same Circle CI API call the orchestrator uses : I called this the "Standalone release"
* Or you want to perform the release on the gravitee-kubernetes repository alone, out of any APIM release process:
  * Regarding the gravitee-kubernetes repository itself


### Test the Orchestrated Release Process

#### With dry run mode ON

* To indivudually (re-)launch the Release process with a `curl`, just for `gravitee-kubernetes`, and just as if it had been launched by the Orchestrator :
  * create the `nexus-staging-gravitee-kubernetes-0_1_0` S3 Bucket : hum, use the `test_mode` "test mode" (set to true and s3 bucket automatically created at the beginning of the process ?). Oh no, create the bucket if and only if it does not already exist (so test if it exists with s3cmd)
  * and run :

```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-kubernetes"
# on master branch for a major release
export BRANCH="master"
# on a "*.*.x" branch for a support release
export BRANCH="9.3.x"
export BRANCH="cicd/circleci_pipeline"
export MAVEN_PROFILE_ID="gio-release"
export MAVEN_PROFILE_ID="gravitee-dry-run"
export S3_BUCKET_NAME="nexus-staging-gravitee-kubernetes-0_1_0"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"release\",
        \"maven_profile_id\": \"${MAVEN_PROFILE_ID}\",
        \"s3_bucket_name\": \"${S3_BUCKET_NAME}\",
        \"dry_run\": true
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```

#### With dry run mode OFF (immutable!)


* To indivudually (re-)launch the Release process with a `curl`, just for `gravitee-kubernetes`, and just as if it had been launched by the Orchestrator :
  * create the `nexus-staging-gravitee-kubernetes-0_1_0` S3 Bucket : hum, use the `test_mode` "test mode" (set to true and s3 bucket automatically created at the beginning of the process ?). Oh no, create the bucket if and only if it does not already exist (so test if it exists with s3cmd)
  * and run :

```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-kubernetes"
# on master branch for a major release
export BRANCH="master"
# on a "*.*.x" branch for a support release
export BRANCH="9.3.x"
export BRANCH="cicd/circleci_pipeline"
export S3_BUCKET_NAME="nexus-staging-gravitee-kubernetes-0_1_0"
export MAVEN_PROFILE_ID="gravitee-dry-run"
export MAVEN_PROFILE_ID="gio-release"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"release\",
        \"maven_profile_id\": \"${MAVEN_PROFILE_ID}\",
        \"s3_bucket_name\": \"${S3_BUCKET_NAME}\",
        \"dry_run\": false
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
# on master branch for a major release
export BRANCH="master"
# on a "*.*.x" branch for a support release
export BRANCH="9.3.x"
export BRANCH="cicd/circleci_pipeline"
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
        \"s3_bucket_name\": \"${S3_BUCKET_NAME}\",
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
