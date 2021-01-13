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
