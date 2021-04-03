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
