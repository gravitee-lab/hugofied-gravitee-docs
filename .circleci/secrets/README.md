# Secrets Management



```bash
export SECRETHUB_ORG=gravitee-lab
export SECRETHUB_REPO=cicd


export GITHUB_CLIENT_ID=inyourdreams;)
export GITHUB_CLIENT_SECRET=inyourdreams;)

secrethub mkdir --parents "${SECRETHUB_ORG}/${SECRETHUB_REPO}/gravitee-docs/oauth"
echo "${GITHUB_CLIENT_ID}" | secrethub write "${SECRETHUB_ORG}/${SECRETHUB_REPO}/gravitee-docs/oauth/github_client_id"
echo "${GITHUB_CLIENT_SECRET}" | secrethub write "${SECRETHUB_ORG}/${SECRETHUB_REPO}/gravitee-docs/oauth/github_client_secret"

secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/gravitee-docs/oauth/github_client_id"
secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/gravitee-docs/oauth/github_client_secret"

export HEROKU_API_KEY=inyourdreams;)

secrethub mkdir --parents "${SECRETHUB_ORG}/${SECRETHUB_REPO}/gravitee-docs/heroku"
echo "${HEROKU_API_KEY}" | secrethub write "${SECRETHUB_ORG}/${SECRETHUB_REPO}/gravitee-docs/heroku/api-token"

secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/gravitee-docs/heroku/api-token"
```
