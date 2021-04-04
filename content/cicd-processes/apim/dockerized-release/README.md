# Tests


## Circle CI Token

```bash
# It should be SECRETHUB_ORG=graviteeio, but Cirlce CI token is related to
# a Circle CI User, not an Org, so just reusing the same than for Gravtiee-Lab here, to work faster
# ---
SECRETHUB_ORG=gravitee-lab
SECRETHUB_REPO=cicd
# Nevertheless, I today think :
# Each team member should have his own personal secrethub repo in the [graviteeio] secrethub org.
# like this :
# a [graviteeio/${TEAM_MEMBER_NAME}] secrethub repo for each team member
# and the Circle CI Personal Access token stored with [graviteeio/${TEAM_MEMBER_NAME}/circleci/token]
# ---
export HUMAN_NAME=jblasselle
export CCI_TOKEN=$(secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/humans/${HUMAN_NAME}/circleci/token")
# You, will just use your own Circle CI Token
# export CCI_TOKEN=<your user circle ci token>
```

#### Tests on Gavitee Kubernetes repo

* Using the test workflow  :

```bash
export CCI_TOKEN=<your Circle CI Token>

export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-kubernetes"
export BRANCH="cicd/circleci_pipeline"
export S3_BUCKET_NAME="nexus-staging-gravitee-kubernetes-0_1_0"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"cicd_test\",
        \"s3_bucket_name\": \"${S3_BUCKET_NAME}\",
        \"dry_run\": true
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .

```

* Using the `mvn_release_dry_run` workflow  :

```bash
export CCI_TOKEN=<your Circle CI Token>

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

#### With dry run mode ON


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
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"standalone_release\",
        \"maven_profile_id\": \"${MAVEN_PROFILE_ID}\",
        \"dry_run\": true
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```

#### With dry run mode OFF (immutable!)


```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-kubernetes"
# on master branch for a major release
export BRANCH="master"
# on a "*.*.x" branch for a support release
export BRANCH="9.3.x"
export BRANCH="cicd/circleci_pipeline"
export MAVEN_PROFILE_ID="gravitee-dry-run"
export MAVEN_PROFILE_ID="gio-release"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"standalone_release\",
        \"maven_profile_id\": \"${MAVEN_PROFILE_ID}\",
        \"dry_run\": false
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```


#### And then the Standalone Nexus Staging (Community Edition Repositories Only)


```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-kubernetes"
# on master branch for a major release
export BRANCH="master"
# on a "*.*.x" branch for a support release
export BRANCH="9.3.x"
export BRANCH="cicd/circleci_pipeline"
export MAVEN_PROFILE_ID="gravitee-release"
export RELEASE_VERSION_NUMBER="0.1.0"
export S3_BUCKET_NAME="prepared-standalone-nexus-staging-${REPO_NAME}-${RELEASE_VERSION_NUMBER}"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"nexus_staging\",
        \"secrethub_org\": \"graviteeio\",
        \"secrethub_repo\": \"cicd\",
        \"s3_bucket_name\": \"${S3_BUCKET_NAME}\",
        \"maven_profile_id\": \"${MAVEN_PROFILE_ID}\"
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```

## Test the Pull Request Workflow without any `git` commit

* For the `gravitee-kubernetes` Community Edition github repo:

```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-kubernetes"
# on a "*.*.x" branch for a support release
export BRANCH="9.3.x"
export BRANCH="cicd/circleci_pipeline"

export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"pull_requests\"
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```

* For the `gravitee-license` Entreprise Edition github repo:

```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-license"
# on a "*.*.x" branch for a support release
export BRANCH="9.3.x"
export BRANCH="cicd/awesome_pr_builds"

export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"pull_requests\"
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```
