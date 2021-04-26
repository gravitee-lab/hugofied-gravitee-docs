#!/bin/bash

if [ "x${BASE_WWW_FOLDER}" == "x" ]; then
  echo "[BASE_WWW_FOLDER] env. var. is not set: set BASE_WWW_FOLDER to the path of the WWW folder served by the [https://download.gravitee.io] server"
  exit 3
fi;

wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/components/gravitee-management-webui/gravitee-management-webui-3.0.16.zip https://repo1.maven.org/maven2/io/gravitee/management/gravitee-management-webui/3.0.16/gravitee-management-webui-3.0.16.zip
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/components/gravitee-management-webui/gravitee-management-webui-3.0.16.zip.sha1 https://repo1.maven.org/maven2/io/gravitee/management/gravitee-management-webui/3.0.16/gravitee-management-webui-3.0.16.zip.sha1
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/components/gravitee-management-webui/gravitee-management-webui-3.0.16.zip.md5 https://repo1.maven.org/maven2/io/gravitee/management/gravitee-management-webui/3.0.16/gravitee-management-webui-3.0.16.zip.md5




# wget https://repo1.maven.org/maven2/io/gravitee/management/gravitee-management-webui/3.0.16/gravitee-management-webui-3.0.16.zip
# wget https://repo1.maven.org/maven2/io/gravitee/management/gravitee-management-webui/3.0.16/gravitee-management-webui-3.0.16.zip.sha1
# wget https://repo1.maven.org/maven2/io/gravitee/management/gravitee-management-webui/3.0.16/gravitee-management-webui-3.0.16.zip.md5
# https://download.gravitee.io/graviteeio-apim/components/gravitee-management-webui/gravitee-management-webui-3.0.16.zip


# ---
# And I must re-package the gravitee Fulll !!! grrrr
# ---
# wget https://download.gravitee.io/graviteeio-apim/components/gravitee-management-webui/gravitee-management-webui-3.0.16.zip
# wget https://download.gravitee.io/graviteeio-apim/components/gravitee-management-webui/gravitee-management-webui-3.0.16.zip.sha1
# wget https://gravitee-releases-downloads.cellar-c2.services.clever-cloud.com/graviteeio-apim/distributions/graviteeio-full-3.0.16.zip.sha1
# wget https://gravitee-releases-downloads.cellar-c2.services.clever-cloud.com/graviteeio-apim/distributions/graviteeio-full-3.0.16.zip


export TEMP_WORK_DIR=$(mktemp -d -t "temp_pack_dir-XXXXXXXXXX")

mkdir -p ${TEMP_WORK_DIR}/downloads/
mkdir -p ${TEMP_WORK_DIR}/work/graviteeio-full-3.0.16

cd ${TEMP_WORK_DIR}/downloads/
wget https://download.gravitee.io/graviteeio-apim/components/gravitee-management-webui/gravitee-management-webui-3.0.16.zip
wget https://download.gravitee.io/graviteeio-apim/components/gravitee-management-webui/gravitee-management-webui-3.0.16.zip.sha1
sha1sum -c gravitee-management-webui-3.0.16.zip.sha1
unzip gravitee-management-webui-3.0.16.zip
ls -allh gravitee-management-webui-3.0.16/
# ---
wget https://gravitee-releases-downloads.cellar-c2.services.clever-cloud.com/graviteeio-apim/distributions/graviteeio-full-3.0.16.zip.sha1
wget https://gravitee-releases-downloads.cellar-c2.services.clever-cloud.com/graviteeio-apim/distributions/graviteeio-full-3.0.16.zip
sha1sum -c graviteeio-full-3.0.16.zip.sha1
unzip graviteeio-full-3.0.16.zip
ls -allh graviteeio-full-3.0.16/
# ---

# - Ok, now ready to re-package

# 1./ first, I retireve all the content of graviteeio-full-3.0.16/, as downloaded
cp -fR  ${TEMP_WORK_DIR}/downloads/graviteeio-full-3.0.16/* ${TEMP_WORK_DIR}/work/graviteeio-full-3.0.16/
# 2./ then I remove and recreate the folder which ahs the problem
rm -fr ${TEMP_WORK_DIR}/work/graviteeio-full-3.0.16/graviteeio-management-ui-3.0.16/
mkdir -p ${TEMP_WORK_DIR}/work/graviteeio-full-3.0.16/graviteeio-management-ui-3.0.16/
# 3./ finally I copy the good content
cp -fR ${TEMP_WORK_DIR}/downloads/gravitee-management-webui-3.0.16/* ${TEMP_WORK_DIR}/work/graviteeio-full-3.0.16/graviteeio-management-ui-3.0.16/

ls -allh ${TEMP_WORK_DIR}/work/graviteeio-full-3.0.16/

# zip -r temp.zip ${TEMP_WORK_DIR}/work/graviteeio-full-3.0.16/
# cd ${TEMP_WORK_DIR}/work/graviteeio-full-3.0.16/
cd ${TEMP_WORK_DIR}/work
zip -r ./graviteeio-full-3.0.16.zip ./graviteeio-full-3.0.16/

rm -fr ${TEMP_WORK_DIR}/work/graviteeio-full-3.0.16/
unzip ./graviteeio-full-3.0.16.zip
ls -allh  ${TEMP_WORK_DIR}/work/graviteeio-full-3.0.16/
# Finally compare reconstructed and downloaded
diff -qr  ${TEMP_WORK_DIR}/downloads/graviteeio-full-3.0.16/ ${TEMP_WORK_DIR}/work/graviteeio-full-3.0.16/
# --
cd ${TEMP_WORK_DIR}/work/
sha1sum graviteeio-full-3.0.16.zip > graviteeio-full-3.0.16.zip.sha1
md5sum graviteeio-full-3.0.16.zip > graviteeio-full-3.0.16.zip.md5
