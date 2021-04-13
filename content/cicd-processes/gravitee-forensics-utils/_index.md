---
title: "Gravitee Parent CI/CD Processes"
date: 2020-12-16T00:44:23+01:00
draft: false
menu_index: 7
showChildrenInMenu : true
nav_menu: "CI/CD Processes"
type: metacicd-processes
---

see also : https://github.com/gravitee-io/kb/wiki/CICD:-The-Forensics-Corner

#### Before you start : your need your Circle CI API Token

To execute every step of the release process, you will need something from circle CI : a Personal API Token.

Here is how you can get one :
* log into Circle CI at https://app.circleci.com with github authentication. Grant access to `gravitee-io` Github Org.
* Go to your Use settings menu : bottom left corner icon
* Then go to the  _**"Personal API Tokens"**_ menu, and click the "Create new Token" button.
* Keep the value of your token, you will need it at each step.


## Gravitee FOrensics Utils

Blabla todo

### Docker Nightly forensics

* To run the Docker Nightly forensics:

```bash
export CCI_TOKEN=<You Circle CI User Personal Token>

export ORG_NAME="gravitee-io"
export REPO_NAME="gravitee-docker"
export BRANCH="cicd/forensics-utils"
# description: "Used only for the Gravitee Parent Release Process: What will be the next snapshot version?"
export NIGHTLY_SNAPSHOT_VERSION="3.8.0-SNAPSHOT"
export JSON_PAYLOAD="{

    \"branch\": \"${BRANCH}\",
    \"parameters\":

    {
        \"gio_action\": \"apim_forensics\",
        \"nightly_snapshot_version\": \"${NIGHTLY_SNAPSHOT_VERSION}\"
    }

}"

curl -X GET -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/me | jq .
curl -X POST -d "${JSON_PAYLOAD}" -H 'Content-Type: application/json' -H 'Accept: application/json' -H "Circle-Token: ${CCI_TOKEN}" https://circleci.com/api/v2/project/gh/${ORG_NAME}/${REPO_NAME}/pipeline | jq .
```
