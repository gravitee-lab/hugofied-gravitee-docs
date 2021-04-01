---
title: "Full Release Process Tests"
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "CI/CD Processes"
menu: apim_processes
menu_index: 11
product: "Gravitee APIM"
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: apim-processes
---

## Process Description

Here I document the execution of the Nexus Staging phase only, for the APIM `3.5.9`

## Release 3.5.9 : the B.O.M.

```JSon
{
 "built_execution_plan_is": [
  [],
  [
   {
    "name": "gravitee-repository",
    "version": "3.5.2-SNAPSHOT"
   }
  ],
  [
   {
    "name": "gravitee-repository-test",
    "version": "3.5.3-SNAPSHOT"
   }
  ],
  [
   {
    "name": "gravitee-repository-mongodb",
    "version": "3.5.3-SNAPSHOT"
   },
   {
    "name": "gravitee-repository-jdbc",
    "version": "3.5.3-SNAPSHOT"
   }
  ],
  [],
  [],
  [],
  [],
  [
   {
    "name": "gravitee-gateway",
    "version": "3.5.9-SNAPSHOT",
    "since": "3.5.8"
   }
  ],
  [],
  [
   {
    "name": "gravitee-policy-jwt",
    "version": "1.17.1-SNAPSHOT"
   },
   {
    "name": "gravitee-elasticsearch",
    "version": "3.5.3-SNAPSHOT"
   }
  ],
  [
   {
    "name": "gravitee-management-rest-api",
    "version": "3.5.9-SNAPSHOT",
    "since": "3.5.8"
   },
   {
    "name": "gravitee-management-webui",
    "version": "3.5.9-SNAPSHOT",
    "since": "3.5.8"
   },
   {
    "name": "gravitee-portal-webui",
    "version": "3.5.9-SNAPSHOT",
    "since": "3.5.8"
   }
  ]
 ]
}
```


```bash
gravitee-repository
gravitee-repository-test
gravitee-repository-mongodb
gravitee-repository-jdbc
gravitee-gateway
gravitee-policy-jwt
gravitee-elasticsearch
gravitee-management-rest-api
gravitee-management-webui
gravitee-portal-webui
```


## Gravitee APIM 3.5.9 release

To get a Circlei CI Token, I personally use :

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

But you can get a Circle CI "Personal API Token" just using the Circle CI Web UI in your profile settings menu.


### 3. Nexus staging

beware, there is no dry run for this one

```bash
# export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="release"
export BRANCH="3.5.x"
export GIO_RELEASE_VERSION="3.5.9"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"nexus_staging\",
        \"gio_release_version\": \"${GIO_RELEASE_VERSION}\"
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```

#### Nexus staging results

* To indivudually relaunch the nexus staging with a `curl`, just for gravitee-gateway :

```bash
export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-gateway"
export BRANCH="3.5.x"
export GIO_RELEASE_VERSION="3.5.9"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"nexus_staging\",
        \"secrethub_org\": \"graviteeio\",
        \"secrethub_repo\": \"cicd\",
        \"s3_bucket_name\": \"prepared-nexus-staging-gravitee-apim-3_5_8\",
        \"maven_profile_id\": \"gravitee-release\"
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```

## Tests results

The GPG Signing key is https://keys.openpgp.org/search?q=870B61A8E14DC301

### First Execution results

When I first ran the nexus stagin, with the new `settings.xml` file, I had the following Pipeline executions :
* `gravitee-management-rest-api` `SUCCESS` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-management-rest-api/1005/workflows/d800ac00-05da-456c-951e-847ba4cd4f15/jobs/977
* `gravitee-portal-webui` `FAILURE` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-portal-webui/332/workflows/cbbb38da-1632-4e74-ac79-90f25dfb638b/jobs/306
* `gravitee-repository-mongodb` `FAILURE` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-repository-mongodb/173/workflows/68f6fb50-33f4-4108-a763-5fd1eb12b633/jobs/165
* `gravitee-repository-jdbc` `FAILURE` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-repository-jdbc/173/workflows/f72ffe09-6690-4eea-a6b2-35e3abc982c0/jobs/166
* `gravitee-gateway` `FAILURE` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-gateway/402/workflows/18b0fe7c-d00e-42f2-834e-601c9d27c921/jobs/377
* `gravitee-elasticsearch` `FAILURE` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-elasticsearch/114/workflows/c660123e-a07f-431c-93e7-afbfdaac2443/jobs/99

The following failed because the component was already published to NExus Public (Maven Central) :
* `gravitee-policy-jwt` `FAILURE` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-policy-jwt/66/workflows/b108ee48-f00c-4942-9246-d97ebb4c3882/jobs/60
* `gravitee-repository-test` `FAILURE` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-repository-test/163/workflows/e4adc5b4-37ab-4167-a835-c0a19575cbc2/jobs/159
* `gravitee-management-webui` `FAILURE` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-management-webui/926/workflows/7df55699-ef6a-4650-a955-69f2d06c1c13/jobs/910
* `gravitee-repository` `FAILURE` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-repository/130/workflows/179ff856-1923-4b00-9310-03595fb41717/jobs/124


For this test suite, I am not interested in the following list of components, which have already successfully been publish to the Publuc Nexus  (Maven Central) :
* [`PUBLISHED`] - `gravitee-policy-jwt` : https://repo1.maven.org/maven2/io/gravitee/policy/gravitee-policy-jwt/1.17.1/
* [`PUBLISHED`] - `gravitee-repository` : https://repo1.maven.org/maven2/io/gravitee/repository/gravitee-repository/3.5.2/
* [`PUBLISHED`] - `gravitee-management-webui` : https://repo1.maven.org/maven2/io/gravitee/management/gravitee-management-webui/3.5.9/
* [`PUBLISHED`] - `gravitee-repository-test` : https://repo1.maven.org/maven2/io/gravitee/repository/gravitee-repository-test/3.5.3/


For all of those pipeline excutions, the error is ever caused by a dependency resolution problem :

* `gravitee-management-rest-api` `SUCCESS`:
  * resolution of dependencies : http://odbxikk7vo-artifactory.services.clever-cloud.com/nexus-and-non-dry-run-releases  cf. in logs `[INFO] Downloading from artifactory-gravitee-non-dry-run: http://odbxikk7vo-artifactory.services.clever-cloud.com/nexus-and-non-dry-run-releases/io/gravitee/gravitee-parent/19.2.1/gravitee-parent-19.2.1.pom`
* `gravitee-portal-webui` `FAILURE` :
  * resolution of dependencies : http://odbxikk7vo-artifactory.services.clever-cloud.com/nexus-and-non-dry-run-releases cf. in logs `[INFO] Downloading from artifactory-gravitee-non-dry-run: http://odbxikk7vo-artifactory.services.clever-cloud.com/nexus-and-non-dry-run-releases/io/gravitee/gravitee-parent/17.2/gravitee-parent-17.2.pom`
  * cause of the failure :  `Caused by: com.sonatype.nexus.staging.client.StagingRuleFailuresException: Staging rules failure!`
* `gravitee-repository-mongodb` `FAILURE` - resolution of dependencies :
  * resolution of dependencies : http://odbxikk7vo-artifactory.services.clever-cloud.com/nexus-and-non-dry-run-releases cf. in logs `[INFO] Downloading from artifactory-gravitee-non-dry-run: http://odbxikk7vo-artifactory.services.clever-cloud.com/nexus-and-non-dry-run-releases/io/gravitee/gravitee-parent/19.2.1/gravitee-parent-19.2.1.pom`
  * cause of the failure :  `Caused by: com.sonatype.nexus.staging.client.StagingRuleFailuresException: Staging rules failure!`
* `gravitee-repository-jdbc` `FAILURE` - resolution of dependencies :
  * resolution of dependencies : http://odbxikk7vo-artifactory.services.clever-cloud.com/nexus-and-non-dry-run-releases cf. in logs `[INFO] Downloading from artifactory-gravitee-non-dry-run: http://odbxikk7vo-artifactory.services.clever-cloud.com/nexus-and-non-dry-run-releases/io/gravitee/gravitee-parent/19.2.1/gravitee-parent-19.2.1.pom`
  * cause of the failure :  `Caused by: com.sonatype.nexus.staging.client.StagingRuleFailuresException: Staging rules failure!`
* `gravitee-gateway` `FAILURE` - resolution of dependencies :
  * resolution of dependencies : http://odbxikk7vo-artifactory.services.clever-cloud.com/nexus-and-non-dry-run-releases cf. in logs `[INFO] Downloading from artifactory-gravitee-non-dry-run: http://odbxikk7vo-artifactory.services.clever-cloud.com/nexus-and-non-dry-run-releases/io/gravitee/gravitee-parent/19.2.1/gravitee-parent-19.2.1.pom`
  * cause of the failure :  `Caused by: com.sonatype.nexus.staging.client.StagingRuleFailuresException: Staging rules failure!`
* `gravitee-policy-jwt` `FAILURE` - resolution of dependencies :
  * resolution of dependencies : http://odbxikk7vo-artifactory.services.clever-cloud.com/nexus-and-non-dry-run-releases cf. in logs `[INFO] Downloading from artifactory-gravitee-non-dry-run: http://odbxikk7vo-artifactory.services.clever-cloud.com/nexus-and-non-dry-run-releases/io/gravitee/gravitee-parent/17.2/gravitee-parent-17.2.pom`
  * cause of the failure :  `Caused by: com.sonatype.nexus.staging.client.StagingRuleFailuresException: Staging rules failure!`
* `gravitee-elasticsearch` `FAILURE` - resolution of dependencies :
  * resolution of dependencies : http://odbxikk7vo-artifactory.services.clever-cloud.com/nexus-and-non-dry-run-releases cf. in logs `[INFO] Downloading from artifactory-gravitee-non-dry-run: http://odbxikk7vo-artifactory.services.clever-cloud.com/nexus-and-non-dry-run-releases/io/gravitee/gravitee-parent/17.2/gravitee-parent-17.2.pom`
  * cause of the failure :  `Caused by: com.sonatype.nexus.staging.client.StagingRuleFailuresException: Staging rules failure!`
* `gravitee-repository` `FAILURE` - resolution of dependencies :
  * resolution of dependencies : http://odbxikk7vo-artifactory.services.clever-cloud.com/nexus-and-non-dry-run-releases cf. in logs `[INFO] Downloaded from artifactory-gravitee-non-dry-run: http://odbxikk7vo-artifactory.services.clever-cloud.com/nexus-and-non-dry-run-releases/io/gravitee/gravitee-parent/19.2.1/gravitee-parent-19.2.1.pom`
  * cause of the failure :  `Caused by: com.sonatype.nexus.staging.client.StagingRuleFailuresException: Staging rules failure!`
  * note that this component has actually already successfully been released : https://repo1.maven.org/maven2/io/gravitee/repository/gravitee-repository/3.5.2/
* `gravitee-management-webui` `FAILURE` - resolution of dependencies :
  * resolution of dependencies : http://odbxikk7vo-artifactory.services.clever-cloud.com/nexus-and-non-dry-run-releases cf. in logs `[INFO] Downloading from artifactory-gravitee-non-dry-run: http://odbxikk7vo-artifactory.services.clever-cloud.com/nexus-and-non-dry-run-releases/io/gravitee/gravitee-parent/17.2/gravitee-parent-17.2.pom`
  * cause of the failure :  `Caused by: com.sonatype.nexus.staging.client.StagingRuleFailuresException: Staging rules failure!`
* `gravitee-repository-test` `FAILURE` - resolution of dependencies :
  * resolution of dependencies : http://odbxikk7vo-artifactory.services.clever-cloud.com/nexus-and-non-dry-run-releases cf. in logs `[INFO] Downloading from artifactory-gravitee-non-dry-run: http://odbxikk7vo-artifactory.services.clever-cloud.com/nexus-and-non-dry-run-releases/io/gravitee/gravitee-parent/19.2.1/gravitee-parent-19.2.1.pom`
  * cause of the failure :  `Caused by: com.sonatype.nexus.staging.client.StagingRuleFailuresException: Staging rules failure!`
  * note that this component has actually already successfully been released : https://repo1.maven.org/maven2/io/gravitee/repository/gravitee-repository-test/3.5.3/

The logs even in debug mode, do not provide any information on what Nexus staging rules might be not complied with...




### Second Execution results

* `gravitee-portal-webui` `FAILURE` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-portal-webui/333/workflows/56a43b7e-b02e-477d-a8a4-174a9a74f733/jobs/307
* `gravitee-repository-mongodb` `FAILURE` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-repository-mongodb/174/workflows/c3838143-917a-4732-ab16-a66b8a01fc0d/jobs/166
* `gravitee-repository-jdbc` `FAILURE` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-repository-jdbc/174/workflows/40cc2009-20a0-4f42-a8f3-57c293d4ec97/jobs/167
* `gravitee-gateway` `FAILURE` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-gateway/405/workflows/ce0879af-e746-402b-99d6-3d7318846302/jobs/380
* `gravitee-elasticsearch` `FAILURE` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-elasticsearch/115/workflows/afa229b4-2bc1-452c-9e52-7f063732cc94/jobs/100

The following failed because the component was already published to Nexus Public (Maven Central) :

* `gravitee-management-rest-api` `FAILURE` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-management-rest-api/1006/workflows/dafd6ff4-0070-437e-845d-1891310ca4e8/jobs/978
* `gravitee-policy-jwt` `FAILURE` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-policy-jwt/67/workflows/f3d7b364-b213-444f-8e6f-c7023da9a633/jobs/61
* `gravitee-repository` `FAILURE` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-repository/131/workflows/4cba63c5-2481-4cef-b92d-a1985c487f8e/jobs/125
* `gravitee-management-webui` `FAILURE` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-management-webui/927/workflows/b704de13-a169-457a-8a8a-264611dea085/jobs/911
* `gravitee-repository-test` `FAILURE` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-repository-test/164/workflows/08a19f2d-b20a-4291-be2f-76326a2e2529/jobs/160


More infos :

* `gravitee-repository` `FAILURE` - resolution of dependencies :
  * resolution of dependencies : http://odbxikk7vo-artifactory.services.clever-cloud.com/nexus-and-non-dry-run-releases cf. in logs `[INFO] Downloaded from artifactory-gravitee-non-dry-run: http://odbxikk7vo-artifactory.services.clever-cloud.com/nexus-and-non-dry-run-releases/io/gravitee/gravitee-parent/19.2.1/gravitee-parent-19.2.1.pom`
  * cause of the failure :  `Caused by: com.sonatype.nexus.staging.client.StagingRuleFailuresException: Staging rules failure!`
  * note that this component has actually already successfully been released : https://repo1.maven.org/maven2/io/gravitee/repository/gravitee-repository/3.5.2/

For this test suite, I am not interested in the following list of components, which have already successfully been publish to the Publuc Nexus  (Maven Central) :

* [`PUBLISHED`] - `gravitee-management-rest-api` :  https://repo1.maven.org/maven2/io/gravitee/rest/api/gravitee-rest-api/3.5.9/
* [`PUBLISHED`] - `gravitee-policy-jwt` : https://repo1.maven.org/maven2/io/gravitee/policy/gravitee-policy-jwt/1.17.1/
* [`PUBLISHED`] - `gravitee-repository` : https://repo1.maven.org/maven2/io/gravitee/repository/gravitee-repository/3.5.2/
* [`PUBLISHED`] - `gravitee-management-webui` : https://repo1.maven.org/maven2/io/gravitee/management/gravitee-management-webui/3.5.9/
* [`PUBLISHED`] - `gravitee-repository-test` : https://repo1.maven.org/maven2/io/gravitee/repository/gravitee-repository-test/3.5.3/

### Third test

I modified just a little thing in the `settings.xml` , and after that small modifications, I had new nexus staging success :


* `gravitee-repository-jdbc` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-repository-jdbc/175/workflows/2ac6ca57-cd15-43d7-91d2-865d96d81a2c/jobs/168
* `gravitee-elasticsearch` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-elasticsearch/116/workflows/97fbf198-e9a6-430f-af9b-13b7c280d8ff/jobs/101
* `gravitee-repository-mongodb` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-repository-mongodb/175/workflows/824aa984-dee0-4f5a-80ea-db42116a60e6/jobs/167
* `gravitee-portal-webui` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-portal-webui/334/workflows/df92559e-a2e4-4769-a213-975abf43ee2f/jobs/308
* `gravitee-gateway` : https://app.circleci.com/pipelines/github/gravitee-io/gravitee-gateway/406/workflows/e2c600e9-dc03-4535-ad64-f9275e608bf9/jobs/381


Ok, so it must have been this small anomaly in my settings.xml , which was the problem

## Expected Sonatype Nexus Maven Central Public URls of all components

Here is the list of expected raw URLs and their lastest verified state :

* [`MISSING`] - `gravitee-portal-webui` : https://repo1.maven.org/maven2/io/gravitee/portal/gravitee-portal-webui/3.5.9/
* [`MISSING`] - `gravitee-repository-mongodb` : https://repo1.maven.org/maven2/io/gravitee/repository/gravitee-repository-mongodb/3.5.3/
* [`MISSING`] - `gravitee-repository-jdbc` : https://repo1.maven.org/maven2/io/gravitee/repository/gravitee-repository-jdbc/3.5.3/
* [`MISSING`] - `gravitee-gateway` : https://repo1.maven.org/maven2/io/gravitee/gateway/gravitee-gateway/3.5.9/
* [`MISSING`] - `gravitee-elasticsearch` : https://repo1.maven.org/maven2/io/gravitee/elasticsearch/gravitee-elasticsearch/3.5.3/
* [`PUBLISHED`] - `gravitee-management-rest-api` :  https://repo1.maven.org/maven2/io/gravitee/rest/api/gravitee-rest-api/3.5.9/
* [`PUBLISHED`] - `gravitee-policy-jwt` : https://repo1.maven.org/maven2/io/gravitee/policy/gravitee-policy-jwt/1.17.1/
* [`PUBLISHED`] - `gravitee-repository` : https://repo1.maven.org/maven2/io/gravitee/repository/gravitee-repository/3.5.2/
* [`PUBLISHED`] - `gravitee-management-webui` : https://repo1.maven.org/maven2/io/gravitee/management/gravitee-management-webui/3.5.9/
* [`PUBLISHED`] - `gravitee-repository-test` : https://repo1.maven.org/maven2/io/gravitee/repository/gravitee-repository-test/3.5.3/
