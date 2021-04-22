

https://github.com/gravitee-io/gravitee-policy-traffic-shadowing

Will release `1.1.0` from `master`


## Standalone release

### Standalone Maven and Git Release

#### With Dry run mode ON

* Will release `1.1.0` from `master` :

```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-policy-traffic-shadowing"
# on master branch for a major release
export BRANCH="master"
# IMPORTANT ! Name of Maven profile defines in which Artifactory repo the mvn deploys sends
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


#### With Dry Run mode OFF

* Will release `1.1.0` from `master` :

```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-policy-traffic-shadowing"
# on master branch for a major release
export BRANCH="master"
# IMPORTANT ! Name of Maven profile defines in which Artifactory repo the mvn deploys sends
export MAVEN_PROFILE_ID="gravitee-dry-run"
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

### Standalone Package Bundle

https://github.com/gravitee-io/kb/wiki/CICD:-The-Standalone-Package-Bundle

* Example to package bundle for the `1.1.0` release of https://github.com/gravitee-io/gravitee-policy-traffic-shadowing :

```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-policy-traffic-shadowing"
export BRANCH="master"
export GIO_RELEASE_VERSION="1.1.0"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"package_bundle\",
        \"package_bundle_version\": \"${GIO_RELEASE_VERSION}\",
        \"dry_run\": true
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```

* With dry run mode off :

```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-policy-traffic-shadowing"
export BRANCH="master"
export GIO_RELEASE_VERSION="1.1.0"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"package_bundle\",
        \"package_bundle_version\": \"${GIO_RELEASE_VERSION}\",
        \"dry_run\": false
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```
