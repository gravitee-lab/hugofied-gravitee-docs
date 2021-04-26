

## The Gravitee Maven Archetypes

### Inventory

* https://github.com/gravitee-io/gravitee-policy-maven-archetype
* https://github.com/gravitee-io/gravitee-service-maven-archetype
* https://github.com/gravitee-io/gravitee-resource-maven-archetype


### Before you start : your need your Circle CI API Token

To execute every step of the release process, you will need something from circle CI : a Personal API Token.

Here is how you can get one :
* log into Circle CI at https://app.circleci.com with github authentication. Grant access to `gravitee-io` Github Org.
* Go to your Use settings menu : bottom left corner icon
* Then go to the  _**"Personal API Tokens"**_ menu, and click the "Create new Token" button.
* Keep the value of your token, you will need it at each step.


## Example 1 : The Gravitee Policy Maven Archetype

#### With dry run mode ON

```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-policy-maven-archetype"
# on a "*.*.x" branch for a support release
export BRANCH="9.3.x"
export BRANCH="0.1.x"
# on master branch for a major release
export BRANCH="master"
export BRANCH="cicd/circleci-pipeline-def"
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

When launched, no Nexus Staging Workflow will be triggered :

![Standalone Release Dry run](https://github.com/gravitee-io/gravitee-circleci-orbinoid/raw/develop/orb/src/scripts/nexus-staging/docker-executors/standalone/images/standalone_release_0.png)

#### With dry run mode OFF (immutable!)

```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-policy-maven-archetype"
# on a "*.*.x" branch for a support release
export BRANCH="9.3.x"
export BRANCH="0.1.x"
# on master branch for a major release
export BRANCH="cicd/circleci-pipeline-def"
export BRANCH="master"
# IMPORTANT ! Name of Maven profile defines in which Artifactory repo the mvn deploys sends
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

When launched, A Nexus Staging Workflow will be triggered, and will hold 2 jobs in a row :
* The Nexus staging with dry run mode on, which you will approve only when the `maven_n_git_release` job has successfully completed (because then the maven project will be available in an S3 Bucket, "frozen", ready to be used by the maven staging). When you will approve it, it will complete its execution without releasing your project to the Public Sonatype Nexus "Maven Central"
* The Nexus staging with dry run mode off, which you will approve only when Nexus staging with dry run mode on, has completed without error(s) (this ensures everything is fine for the nexus staging). When you will approve it, it will complete its execution without releasing your project to the Public Sonatype Nexus "Maven Central"

![Standalone Release Dry run mode off](https://github.com/gravitee-io/gravitee-circleci-orbinoid/raw/develop/orb/src/scripts/nexus-staging/docker-executors/standalone/images/standalone_release_1.png)

![Standalone Release Dry run mode off](https://github.com/gravitee-io/gravitee-circleci-orbinoid/raw/develop/orb/src/scripts/nexus-staging/docker-executors/standalone/images/standalone_release_2.png)

![Standalone Release Dry run mode off](https://github.com/gravitee-io/gravitee-circleci-orbinoid/raw/develop/orb/src/scripts/nexus-staging/docker-executors/standalone/images/standalone_release_3.png)

![Standalone Release Dry run mode off](https://github.com/gravitee-io/gravitee-circleci-orbinoid/raw/develop/orb/src/scripts/nexus-staging/docker-executors/standalone/images/standalone_release_4.png)
