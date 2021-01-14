# Secrets Management

```bash
jbl@poste-devops-jbl-16gbram:~/someops$ export SECRETHUB_ORG=gravitee-lab
jbl@poste-devops-jbl-16gbram:~/someops$ export SECRETHUB_REPO=cicd
jbl@poste-devops-jbl-16gbram:~/someops$ secrethub mkdir --parents "${SECRETHUB_ORG}/${SECRETHUB_REPO}/gravitee-docs/heroku"
Created a new directory at gravitee-lab/cicd/gravitee-docs/heroku
jbl@poste-devops-jbl-16gbram:~/someops$ echo "<here the obfuscated Heroku API Token value>" | secrethub write "${SECRETHUB_ORG}/${SECRETHUB_REPO}/gravitee-docs/heroku/api-token"
Writing secret value...
Write complete! The given value has been written to gravitee-lab/cicd/gravitee-docs/heroku/api-token:1
jbl@poste-devops-jbl-16gbram:~/someops$
```
export JSON_PAYLOAD="{
  \"FOO\": \"bar\",
  \"BAZ\": \"qux\"
}"

curl -iv -n -X PATCH https://api.heroku.com/apps/${HEROKU_APP_ID}/config-vars \
  -H "Authorization: Bearer ${HEROKU_API_KEY}" \
  -d "${JSON_PAYLOAD}" \
  -H "Content-Type: application/json" \
  -H "Accept: application/vnd.heroku+json; version=3"
