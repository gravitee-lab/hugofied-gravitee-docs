#!/bin/bash

if [ "x${BASE_WWW_FOLDER}" == "x" ]; then
  echo "[BASE_WWW_FOLDER] env. var. is not set: set BASE_WWW_FOLDER to the path of the WWW folder served by the [https://download.gravitee.io] server"
  exit 3
fi;
export S3_BASE_URL=https://gravitee-releases-downloads.cellar-c2.services.clever-cloud.com

mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/distributions/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-github/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-git/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-bitbucket/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-gitlab/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-http/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/services/gravitee-gateway-services-ratelimit/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/services/gravitee-service-discovery-consul/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/reporters/gravitee-reporter-tcp/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/reporters/gravitee-reporter-elasticsearch/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/reporters/gravitee-reporter-file/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/repositories/gravitee-repository-gateway-bridge-http-server/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/repositories/gravitee-repository-mongodb/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/repositories/gravitee-repository-jdbc/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/repositories/gravitee-repository-elasticsearch/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/repositories/gravitee-repository-gateway-bridge-http-client/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/resources/gravitee-resource-cache/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/resources/gravitee-resource-oauth2-provider-generic/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/resources/gravitee-resource-oauth2-provider-am/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/service-discovery/gravitee-gateway-services-ratelimit/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/connectors/gravitee-cockpit-connectors-ws/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-ssl-enforcement/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-xml-threat-protection/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-retry/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-jws/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-generate-jwt/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-rest-to-soap/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-openid-connect-userinfo/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-jwt/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-regex-threat-protection/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-latency/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-spikearrest/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-json-validation/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-oauth2/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-keyless/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-json-threat-protection/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-request-content-limit/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-mock/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-html-json/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-xml-json/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-request-validation/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-resource-filtering/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-json-to-json/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-xml-validation/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-assign-content/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-http-signature/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-assign-attributes/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-callout-http/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-ipfiltering/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-role-based-access-control/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-groovy/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-ratelimit/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-transformheaders/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-url-rewriting/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-quota/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-override-http-method/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-apikey/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-xslt/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-json-xml/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-cache/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-transformqueryparams/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-dynamic-routing/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/components/gravitee-gateway/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/components/gravitee-management-rest-api/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/components/gravitee-portal-webui/
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/components/gravitee-management-webui
