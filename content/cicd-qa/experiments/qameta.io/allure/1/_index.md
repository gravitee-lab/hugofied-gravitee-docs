
* Repository Subject of the experiment: https://github.com/gravitee-io/graviteeio-access-management.git
* CICD Process  of the experiment: Gravite AM Release Process

* Part 1 :
  * no `pom.xml` modifications,
  * generate the Allure Report, from test results data
  * and publish it to s3
* Part 1 :
  * `pom.xml` modifications, to integrate Allure Reports into the `mvn clean test` Build Process,
  * generate the Allure Report,
  * and publish it to s3

## Experiment Part 1

* launch the release dry run, on the git branch created to test qa workflow :

```bash
# export CCI_TOKEN=<You Circle CI User Personal Token>

export ORG_NAME="gravitee-io"
export REPO_NAME="graviteeio-access-management"
# For example, for the 3.6.3 AM release, the git branch was 3.6.x
export BRANCH="master"
export BRANCH="cicd/qa-workflow"

# description: "The semver version number of the SAML2 identity provider plugin to bundle with GRavitee AM Entreprise Edition"
export ID_PROVIDER_SAML_VERSION="1.1.1"
export ID_PROVIDER_CAS_VERSION="1.0.0"
export GRAVITEE_LICENSE_VERSION="1.1.0"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"release\",
        \"ee_id_provider_saml_version\": \"${ID_PROVIDER_SAML_VERSION}\",
        \"ee_id_provider_cas_version\": \"${ID_PROVIDER_CAS_VERSION}\",
        \"ee_gravitee_license_version\": \"${GRAVITEE_LICENSE_VERSION}\",
        \"dry_run\": true
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```


## Experiment Part 2

















## Tech References

* https://www.clever-cloud.com/blog/engineering/2020/06/24/deploy-cellar-s3-static-site/
