# Content comparison between 3.5.7 and 3.7.0

Why ?

We have noticed that :
* https://download.gravitee.io/graviteeio-apim/distributions/graviteeio-full-3.7.0.zip is 10 MB bigger than
* https://download.gravitee.io/graviteeio-apim/distributions/graviteeio-full-3.5.7.zip

So we want a diff to check if here might be anything missing anywhere


```bash
export TEST_HOME=$(mktemp -d -t "content_comparison-XXXXXXXXXX")
cd ${TEST_HOME}

wget https://download.gravitee.io/graviteeio-apim/distributions/graviteeio-full-3.7.0.zip
wget https://download.gravitee.io/graviteeio-apim/distributions/graviteeio-full-3.5.7.zip

unzip graviteeio-full-3.5.7.zip
cp release.json release.3.5.7.json
unzip graviteeio-full-3.5.7.zip

diff -qr graviteeio-full-3.5.7/ graviteeio-full-3.7.0/

# Only in graviteeio-full-3.5.7/: graviteeio-gateway-3.5.7
# Only in graviteeio-full-3.7.0/: graviteeio-gateway-3.7.0
# Only in graviteeio-full-3.5.7/: graviteeio-management-ui-3.5.7
# Only in graviteeio-full-3.7.0/: graviteeio-management-ui-3.7.0
# Only in graviteeio-full-3.5.7/: graviteeio-portal-ui-3.5.7
# Only in graviteeio-full-3.7.0/: graviteeio-portal-ui-3.7.0
# Only in graviteeio-full-3.5.7/: graviteeio-rest-api-3.5.7
# Only in graviteeio-full-3.7.0/: graviteeio-rest-api-3.7.0


diff -qr graviteeio-full-3.5.7/graviteeio-gateway-3.5.7 graviteeio-full-3.7.0/graviteeio-gateway-3.7.0

```
