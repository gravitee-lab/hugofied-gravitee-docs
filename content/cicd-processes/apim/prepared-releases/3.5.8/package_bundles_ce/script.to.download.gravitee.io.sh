#!/bin/bash

if [ "x${BASE_WWW_FOLDER}" == "x" ]; then
  echo "[BASE_WWW_FOLDER] env. var. is not set: set BASE_WWW_FOLDER to the path of the WWW folder served by the [https://download.gravitee.io] server"
  exit 3
fi;
export S3_BASE_URL=https://gravitee-releases-downloads.cellar-c2.services.clever-cloud.com

mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/distributions/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/distributions/graviteeio-full-3.5.8.zip ${S3_BASE_URL}/graviteeio-apim/distributions/graviteeio-full-3.5.8.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-github/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-github/gravitee-fetcher-github-1.5.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-github/gravitee-fetcher-github-1.5.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-git/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-git/gravitee-fetcher-git-1.7.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-git/gravitee-fetcher-git-1.7.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-bitbucket/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-bitbucket/gravitee-fetcher-bitbucket-1.6.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-bitbucket/gravitee-fetcher-bitbucket-1.6.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-gitlab/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-gitlab/gravitee-fetcher-gitlab-1.10.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-gitlab/gravitee-fetcher-gitlab-1.10.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-http/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-http/gravitee-fetcher-http-1.11.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-http/gravitee-fetcher-http-1.11.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/services/gravitee-gateway-services-ratelimit/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/services/gravitee-gateway-services-ratelimit/gravitee-gateway-services-ratelimit-1.11.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/services/gravitee-gateway-services-ratelimit/gravitee-gateway-services-ratelimit-1.11.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/services/gravitee-service-discovery-consul/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/services/gravitee-service-discovery-consul/gravitee-service-discovery-consul-1.2.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/services/gravitee-service-discovery-consul/gravitee-service-discovery-consul-1.2.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/reporters/gravitee-reporter-elasticsearch/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/reporters/gravitee-reporter-elasticsearch/gravitee-reporter-elasticsearch-3.5.2.zip ${S3_BASE_URL}/graviteeio-apim/plugins/reporters/gravitee-reporter-elasticsearch/gravitee-reporter-elasticsearch-3.5.2.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/reporters/gravitee-reporter-file/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/reporters/gravitee-reporter-file/gravitee-reporter-file-2.0.2.zip ${S3_BASE_URL}/graviteeio-apim/plugins/reporters/gravitee-reporter-file/gravitee-reporter-file-2.0.2.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/repositories/gravitee-repository-gateway-bridge-http-server/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/repositories/gravitee-repository-gateway-bridge-http-server/gravitee-repository-gateway-bridge-http-server-3.5.4.zip ${S3_BASE_URL}/graviteeio-apim/plugins/repositories/gravitee-repository-gateway-bridge-http-server/gravitee-repository-gateway-bridge-http-server-3.5.4.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/repositories/gravitee-repository-mongodb/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/repositories/gravitee-repository-mongodb/gravitee-repository-mongodb-3.5.2.zip ${S3_BASE_URL}/graviteeio-apim/plugins/repositories/gravitee-repository-mongodb/gravitee-repository-mongodb-3.5.2.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/repositories/gravitee-repository-jdbc/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/repositories/gravitee-repository-jdbc/gravitee-repository-jdbc-3.5.2.zip ${S3_BASE_URL}/graviteeio-apim/plugins/repositories/gravitee-repository-jdbc/gravitee-repository-jdbc-3.5.2.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/repositories/gravitee-repository-elasticsearch/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/repositories/gravitee-repository-elasticsearch/gravitee-repository-elasticsearch-3.5.2.zip ${S3_BASE_URL}/graviteeio-apim/plugins/repositories/gravitee-repository-elasticsearch/gravitee-repository-elasticsearch-3.5.2.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/repositories/gravitee-repository-gateway-bridge-http-client/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/repositories/gravitee-repository-gateway-bridge-http-client/gravitee-repository-gateway-bridge-http-client-3.5.4.zip ${S3_BASE_URL}/graviteeio-apim/plugins/repositories/gravitee-repository-gateway-bridge-http-client/gravitee-repository-gateway-bridge-http-client-3.5.4.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/resources/gravitee-resource-cache/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/resources/gravitee-resource-cache/gravitee-resource-cache-1.4.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/resources/gravitee-resource-cache/gravitee-resource-cache-1.4.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/resources/gravitee-resource-oauth2-provider-generic/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/resources/gravitee-resource-oauth2-provider-generic/gravitee-resource-oauth2-provider-generic-1.15.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/resources/gravitee-resource-oauth2-provider-generic/gravitee-resource-oauth2-provider-generic-1.15.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/resources/gravitee-resource-oauth2-provider-am/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/resources/gravitee-resource-oauth2-provider-am/gravitee-resource-oauth2-provider-am-1.12.2.zip ${S3_BASE_URL}/graviteeio-apim/plugins/resources/gravitee-resource-oauth2-provider-am/gravitee-resource-oauth2-provider-am-1.12.2.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/service-discovery/gravitee-gateway-services-ratelimit/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/service-discovery/gravitee-gateway-services-ratelimit/gravitee-gateway-services-ratelimit-1.11.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/service-discovery/gravitee-gateway-services-ratelimit/gravitee-gateway-services-ratelimit-1.11.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-ssl-enforcement/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-ssl-enforcement/gravitee-policy-ssl-enforcement-1.2.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-ssl-enforcement/gravitee-policy-ssl-enforcement-1.2.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-xml-threat-protection/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-xml-threat-protection/gravitee-policy-xml-threat-protection-1.2.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-xml-threat-protection/gravitee-policy-xml-threat-protection-1.2.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-retry/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-retry/gravitee-policy-retry-1.0.1.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-retry/gravitee-policy-retry-1.0.1.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-jws/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-jws/gravitee-policy-jws-1.3.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-jws/gravitee-policy-jws-1.3.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-generate-jwt/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-generate-jwt/gravitee-policy-generate-jwt-1.5.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-generate-jwt/gravitee-policy-generate-jwt-1.5.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-rest-to-soap/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-rest-to-soap/gravitee-policy-rest-to-soap-1.11.1.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-rest-to-soap/gravitee-policy-rest-to-soap-1.11.1.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-openid-connect-userinfo/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-openid-connect-userinfo/gravitee-policy-openid-connect-userinfo-1.4.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-openid-connect-userinfo/gravitee-policy-openid-connect-userinfo-1.4.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-jwt/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-jwt/gravitee-policy-jwt-1.16.1.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-jwt/gravitee-policy-jwt-1.16.1.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-regex-threat-protection/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-regex-threat-protection/gravitee-policy-regex-threat-protection-1.2.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-regex-threat-protection/gravitee-policy-regex-threat-protection-1.2.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-latency/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-latency/gravitee-policy-latency-1.3.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-latency/gravitee-policy-latency-1.3.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-spikearrest/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-spikearrest/gravitee-policy-spikearrest-1.11.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-spikearrest/gravitee-policy-spikearrest-1.11.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-json-validation/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-json-validation/gravitee-policy-json-validation-1.6.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-json-validation/gravitee-policy-json-validation-1.6.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-oauth2/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-oauth2/gravitee-policy-oauth2-1.15.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-oauth2/gravitee-policy-oauth2-1.15.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-keyless/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-keyless/gravitee-policy-keyless-1.3.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-keyless/gravitee-policy-keyless-1.3.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-json-threat-protection/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-json-threat-protection/gravitee-policy-json-threat-protection-1.2.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-json-threat-protection/gravitee-policy-json-threat-protection-1.2.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-request-content-limit/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-request-content-limit/gravitee-policy-request-content-limit-1.7.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-request-content-limit/gravitee-policy-request-content-limit-1.7.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-mock/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-mock/gravitee-policy-mock-1.12.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-mock/gravitee-policy-mock-1.12.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-html-json/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-html-json/gravitee-policy-html-json-1.6.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-html-json/gravitee-policy-html-json-1.6.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-xml-json/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-xml-json/gravitee-policy-xml-json-1.7.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-xml-json/gravitee-policy-xml-json-1.7.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-request-validation/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-request-validation/gravitee-policy-request-validation-1.11.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-request-validation/gravitee-policy-request-validation-1.11.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-resource-filtering/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-resource-filtering/gravitee-policy-resource-filtering-1.8.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-resource-filtering/gravitee-policy-resource-filtering-1.8.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-json-to-json/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-json-to-json/gravitee-policy-json-to-json-1.6.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-json-to-json/gravitee-policy-json-to-json-1.6.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-xml-validation/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-xml-validation/gravitee-policy-xml-validation-1.1.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-xml-validation/gravitee-policy-xml-validation-1.1.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-assign-content/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-assign-content/gravitee-policy-assign-content-1.6.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-assign-content/gravitee-policy-assign-content-1.6.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-assign-attributes/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-assign-attributes/gravitee-policy-assign-attributes-1.5.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-assign-attributes/gravitee-policy-assign-attributes-1.5.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-callout-http/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-callout-http/gravitee-policy-callout-http-1.12.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-callout-http/gravitee-policy-callout-http-1.12.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-ipfiltering/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-ipfiltering/gravitee-policy-ipfiltering-1.6.1.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-ipfiltering/gravitee-policy-ipfiltering-1.6.1.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-role-based-access-control/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-role-based-access-control/gravitee-policy-role-based-access-control-1.1.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-role-based-access-control/gravitee-policy-role-based-access-control-1.1.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-groovy/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-groovy/gravitee-policy-groovy-1.12.1.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-groovy/gravitee-policy-groovy-1.12.1.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-ratelimit/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-ratelimit/gravitee-policy-ratelimit-1.11.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-ratelimit/gravitee-policy-ratelimit-1.11.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-transformheaders/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-transformheaders/gravitee-policy-transformheaders-1.8.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-transformheaders/gravitee-policy-transformheaders-1.8.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-url-rewriting/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-url-rewriting/gravitee-policy-url-rewriting-1.4.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-url-rewriting/gravitee-policy-url-rewriting-1.4.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-quota/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-quota/gravitee-policy-quota-1.11.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-quota/gravitee-policy-quota-1.11.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-override-http-method/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-override-http-method/gravitee-policy-override-http-method-1.3.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-override-http-method/gravitee-policy-override-http-method-1.3.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-apikey/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-apikey/gravitee-policy-apikey-2.2.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-apikey/gravitee-policy-apikey-2.2.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-xslt/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-xslt/gravitee-policy-xslt-1.6.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-xslt/gravitee-policy-xslt-1.6.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-cache/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-cache/gravitee-policy-cache-1.9.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-cache/gravitee-policy-cache-1.9.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-transformqueryparams/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-transformqueryparams/gravitee-policy-transformqueryparams-1.6.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-transformqueryparams/gravitee-policy-transformqueryparams-1.6.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-dynamic-routing/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-dynamic-routing/gravitee-policy-dynamic-routing-1.11.0.zip ${S3_BASE_URL}/graviteeio-apim/plugins/policies/gravitee-policy-dynamic-routing/gravitee-policy-dynamic-routing-1.11.0.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/components/gravitee-gateway/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/components/gravitee-gateway/graviteeio-gateway-3.5.8.zip ${S3_BASE_URL}/graviteeio-apim/components/gravitee-gateway/graviteeio-gateway-3.5.8.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/components/gravitee-management-rest-api/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/components/gravitee-management-rest-api/gravitee-management-rest-api-3.5.8.zip ${S3_BASE_URL}/graviteeio-apim/components/gravitee-management-rest-api/gravitee-management-rest-api-3.5.8.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/components/gravitee-portal-webui/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/components/gravitee-portal-webui/gravitee-portal-webui-3.5.8.zip ${S3_BASE_URL}/graviteeio-apim/components/gravitee-portal-webui/gravitee-portal-webui-3.5.8.zip
mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/components/gravitee-management-webui/
wget -O ${BASE_WWW_FOLDER}/graviteeio-apim/components/gravitee-management-webui/gravitee-management-webui-3.5.8.zip ${S3_BASE_URL}/graviteeio-apim/components/gravitee-management-webui/gravitee-management-webui-3.5.8.zip
