---
title: "Octokit Github Client"
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "Circle CI and Docker"
menu: circle_docker
menu_index: 3
product: "Gravitee APIM"
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: circle-docker
---

## The Octokit Lib

Blablabla

### Create a Pull request


```bash

echo "# ----------------------------------------"
echo "# --> create the pull request         : --"
echo "# ----------------------------------------"
export GH_ORG_NAME=gravitee-io
export GH_REPO_NAME=gravitee-docs

export URL_ENCODED_PR_SRC_BRANCH=$(echo "${PR_SOURCE_BRANCH}" | sed "s#\/#%2F#g")
export URL_ENCODED_PR_TRGT_BRANCH=$(echo "${PR_TARGET_BRANCH}" | sed "s#\/#%2F#g")

echo "# ----------------------------------------"
echo "PR_SOURCE_BRANCH=[${PR_SOURCE_BRANCH}]"
echo "URL_ENCODED_PR_SRC_BRANCH=[${URL_ENCODED_PR_SRC_BRANCH}]"
echo "PR_TARGET_BRANCH=[${PR_TARGET_BRANCH}]"
echo "URL_ENCODED_PR_TRGT_BRANCH=[${URL_ENCODED_PR_TRGT_BRANCH}]"
echo "# ----------------------------------------"
echo "JSon Payload of Github REST API will be : "
echo "# ----------------------------------------"
echo "{\"title\": \"Continuous Deployment APIM [${GIO_RELEASE_VERSION}]\", \"body\": \"Continuous Deployment APIM [${GIO_RELEASE_VERSION}]\", \"head\" : \"${PR_SOURCE_BRANCH}\", \"base\" : \"${PR_TARGET_BRANCH}\" }"
echo "# ----------------------------------------"


# export GRAVITEEBOT_GH_API_TOKEN="wrongone"
# export GIO_RELEASE_VERSION="1.25.27"
# export PR_SOURCE_BRANCH="wrongone"
# export PR_TARGET_BRANCH="master"


docker pull node:12.21.0-buster

# docker run -u root -itd --name gio_pr_spawner -w /home/node/app -v $PWD:/home/node/app node:12.21.0-buster sh
docker run -u root -itd --name gio_pr_spawner -w /home/node/app node:12.21.0-buster sh

# docker exec -it gio_pr_spawner sh -c 'npx express-generator-typescript ephemeral  && cd ephemeral && npm install --save @octokit/core @octokit/core octokit-plugin-create-pull-request @octokit/request'
docker exec -it gio_pr_spawner sh -c 'npx express-generator-typescript ephemeral  && cd ephemeral && npm install --save @octokit/core @octokit/request @octokit/rest'

# cd ephemeral
export WHATEVER=$(mktemp -d -t "whatever-XXXXXXXXXX")

# --- #
# https://octokit.github.io/rest.js/v18#pulls-create
# https://octokit.github.io/rest.js/v18#authentication

cat << EOF >${WHATEVER}/new.index.ts

import { Octokit } from "@octokit/rest";
// const { Octokit } = require("@octokit/rest");

const myOctokit = new Octokit({
  auth: "${GRAVITEEBOT_GH_API_TOKEN}",
});

// sends request with `Authorization: token mypersonalaccesstoken123` header
// const { data } = await myOctokit.request("/user");

// https://octokit.github.io/rest.js/v18#pulls-create
export async function getUser() {

  return await myOctokit.request("/user");
}

export async function createPullRequest() {

    return await myOctokit.pulls.create({
      owner: "gravitee-io",
      repo: "gravitee-docs",
      head: "${PR_SOURCE_BRANCH}",
      base: "${PR_TARGET_BRANCH}",
      title: "Continuous Deployment APIM [${GIO_RELEASE_VERSION}]",
      body: "Hi! I am the ${GRAVITEEBOT_GH_USERNAME} bot, performing Continuous Deployment of The Gravitee Docs in the APIM [${GIO_RELEASE_VERSION}] Release process. The [${PR_SOURCE_BRANCH}] git branch was created from the [${PR_SOURCE_BRANCH_ROOT}] git branch, and When you will merge it into the [${PR_TARGET_BRANCH}] git branch, the deployment will automatically be triggered to Clever Cloud.",
      draft: false
    });
}


const authenticatedUser = getUser()

console.log("authenticatedUser = " + authenticatedUser);

const prNumber = createPullRequest();

console.log("created PR is of number = " + prNumber);

EOF

echo ""

docker exec -it gio_pr_spawner sh -c 'pwd && ls -allh . && cd ephemeral && rm ./src/index.ts && mkdir gravitee-docs/'

docker exec -it gio_pr_spawner sh -c 'cd ephemeral && sed -i "s#// \"noImplicitAny\": true#\"noImplicitAny\": false#g" tsconfig.json'

docker cp ${WHATEVER}/new.index.ts gio_pr_spawner:/home/node/app/ephemeral/src
docker cp ./_config.yml gio_pr_spawner:/home/node/app/ephemeral/gravitee-docs/


echo "check content of src/index.ts inside container : "
docker exec -it gio_pr_spawner sh -c 'cd ephemeral && ls -allh ./'
docker exec -it gio_pr_spawner sh -c 'cd ephemeral && ls -allh ./src'
docker exec -it gio_pr_spawner sh -c 'cd ephemeral && ls -allh . && cp ./src/new.index.ts ./src/index.ts'
docker exec -it gio_pr_spawner sh -c 'cd ephemeral && ls -allh ./src/new.index.ts'
docker exec -it gio_pr_spawner sh -c 'cd ephemeral && ls -allh ./src/index.ts'
docker exec -it gio_pr_spawner sh -c 'cd ephemeral && rm ./src/new.index.ts'
docker exec -it gio_pr_spawner sh -c 'cd ephemeral && cat ./src/index.ts'
echo "check content of [/home/node/app/ephemeral/gravitee-docs/_config.yml] inside container : "
docker exec -it gio_pr_spawner sh -c 'cd ephemeral && ls -allh ./gravitee-docs/ && cat /home/node/app/ephemeral/gravitee-docs/_config.yml'

docker exec -it gio_pr_spawner sh -c 'cd ephemeral && npm i -g typescript && npm i && tsc && npm run build && npm start'



```
