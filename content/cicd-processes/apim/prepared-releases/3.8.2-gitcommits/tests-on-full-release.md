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


## Release 3.8.1 : the B.O.M.

```JSon
{
 "built_execution_plan_is": [
  [],
  [
   {
    "name": "gravitee-repository",
    "version": "3.8.1-SNAPSHOT",
    "since": "3.8.0"
   }
  ],
  [
   {
    "name": "gravitee-repository-test",
    "version": "3.8.1-SNAPSHOT",
    "since": "3.8.0"
   }
  ],
  [
   {
    "name": "gravitee-repository-mongodb",
    "version": "3.8.1-SNAPSHOT",
    "since": "3.8.0"
   },
   {
    "name": "gravitee-repository-jdbc",
    "version": "3.8.1-SNAPSHOT",
    "since": "3.8.0"
   },
   {
    "name": "gravitee-repository-gateway-bridge-http",
    "version": "3.8.1-SNAPSHOT",
    "since": "3.8.0"
   }
  ],
  [],
  [],
  [],
  [],
  [
   {
    "name": "gravitee-gateway",
    "version": "3.8.1-SNAPSHOT",
    "since": "3.8.0"
   }
  ],
  [],
  [
   {
    "name": "gravitee-policy-jwt",
    "version": "1.18.1-SNAPSHOT",
    "since": "3.8.0"
   }
  ],
  [
   {
    "name": "gravitee-management-rest-api",
    "version": "3.8.1-SNAPSHOT",
    "since": "3.8.0"
   },
   {
    "name": "gravitee-management-webui",
    "version": "3.8.1-SNAPSHOT",
    "since": "3.8.0"
   },
   {
    "name": "gravitee-portal-webui",
    "version": "3.8.1-SNAPSHOT",
    "since": "3.8.0"
   }
  ]
 ]
}
```

git clones :

```bash
export OPS_HOME=$(pwd)

git clone git@github.com:gravitee-io/release
cd release
git checkout 3.8.x
cd ${OPS_HOME}



git clone git@github.com:gravitee-io/gravitee-repository
cd gravitee-repository
git checkout 3.8.x
cd ${OPS_HOME}
# "version": "3.8.1-SNAPSHOT"

git clone git@github.com:gravitee-io/gravitee-repository-test
cd gravitee-repository-test
git checkout 3.8.x
cd ${OPS_HOME}
# "version": "3.8.1-SNAPSHOT"


git clone git@github.com:gravitee-io/gravitee-repository-mongodb
cd gravitee-repository-mongodb
git checkout 3.8.x
cd ${OPS_HOME}
# "version": "3.8.1-SNAPSHOT"



git clone git@github.com:gravitee-io/gravitee-repository-jdbc
cd gravitee-repository-jdbc
git checkout 3.8.x
cd ${OPS_HOME}
# "version": "3.8.1-SNAPSHOT"

git clone git@github.com:gravitee-io/gravitee-repository-gateway-bridge-http
cd gravitee-repository-gateway-bridge-http
git checkout 3.8.x
cd ${OPS_HOME}
# "version": "3.8.1-SNAPSHOT"


git clone git@github.com:gravitee-io/gravitee-gateway
cd gravitee-gateway
git checkout 3.8.x
cd ${OPS_HOME}
# "version": "3.8.1-SNAPSHOT"



git clone git@github.com:gravitee-io/gravitee-policy-jwt
cd gravitee-policy-jwt
git checkout 1.18.x
cd ${OPS_HOME}
# "version": "1.18.1-SNAPSHOT"


git clone git@github.com:gravitee-io/gravitee-management-rest-api
cd gravitee-management-rest-api
git checkout 3.8.x
cd ${OPS_HOME}
# "version": "3.8.1-SNAPSHOT"

git clone git@github.com:gravitee-io/gravitee-management-webui
cd gravitee-management-webui
git checkout 3.8.x
cd ${OPS_HOME}
# "version": "3.8.1-SNAPSHOT"

git clone git@github.com:gravitee-io/gravitee-portal-webui
cd gravitee-portal-webui
git checkout 3.8.x
cd ${OPS_HOME}
# "version": "3.8.1-SNAPSHOT"

```

### 3. Nexus staging

beware, there is no dry run for this one

```bash
# export CCI_TOKEN=<you circle ci token>
export ORG_NAME="gravitee-io"
export REPO_NAME="release"
export BRANCH="3.8.x"
export GIO_RELEASE_VERSION="3.8.1"
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
