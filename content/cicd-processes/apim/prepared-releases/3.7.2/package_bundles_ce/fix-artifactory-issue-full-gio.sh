#!/bin/bash

if [ "x${BASE_WWW_FOLDER}" == "x" ]; then
  echo "[BASE_WWW_FOLDER] env. var. is not set: set BASE_WWW_FOLDER to the path of the WWW folder served by the [https://download.gravitee.io] server"
  exit 3
fi;

# wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/components/gravitee-management-webui/gravitee-management-webui-3.0.16.zip https://repo1.maven.org/maven2/io/gravitee/management/gravitee-management-webui/3.0.16/gravitee-management-webui-3.0.16.zip
# wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/components/gravitee-management-webui/gravitee-management-webui-3.0.16.zip.sha1 https://repo1.maven.org/maven2/io/gravitee/management/gravitee-management-webui/3.0.16/gravitee-management-webui-3.0.16.zip.sha1
# wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/components/gravitee-management-webui/gravitee-management-webui-3.0.16.zip.md5 https://repo1.maven.org/maven2/io/gravitee/management/gravitee-management-webui/3.0.16/gravitee-management-webui-3.0.16.zip.md5


wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/distributions/graviteeio-full-3.0.16.zip https://gravitee-releases-downloads.cellar-c2.services.clever-cloud.com/graviteeio-apim/distributions/graviteeio-full-3.0.16.zip
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/distributions/graviteeio-full-3.0.16.zip.sha1 https://gravitee-releases-downloads.cellar-c2.services.clever-cloud.com/graviteeio-apim/distributions/graviteeio-full-3.0.16.zip.sha1
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/distributions/graviteeio-full-3.0.16.zip.md5 https://gravitee-releases-downloads.cellar-c2.services.clever-cloud.com/graviteeio-apim/distributions/graviteeio-full-3.0.16.zip.md5
