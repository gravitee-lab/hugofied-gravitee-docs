

To Heroku deploy the gravitee-docs , with the pokus, I need to set Heroku Config Vars for the `${HEROKU_APP_ID}` :

* CC_CLIENT_ID : this is a secret
* CCC_CLIENT_SECRET : this is a secret
* AUTHORIZED_GITHUB_ORG : this is just a configuration parameter

Okay, to automate Config Vars setup, I can use the Heroku REST API :
* https://devcenter.heroku.com/articles/platform-api-reference#config-vars
* mimic what I did with the `/formation` REST API Endpoint, and i'll be good I think.

```bash
export JSON_PAYLOAD="{
  \"FOO\": \"bar\",
  \"BAZ\": \"qux\"
}"

curl -n -X PATCH https://api.heroku.com/apps/$APP_ID_OR_NAME/config-vars \
  -d "${JSON_PAYLOAD}" \
  -H "Content-Type: application/json" \
  -H "Accept: application/vnd.heroku+json; version=3"
```

With all this, I think it should be unnecessary ti use a `Heroku.yml` file (which any would have been used with a git based deployment).
