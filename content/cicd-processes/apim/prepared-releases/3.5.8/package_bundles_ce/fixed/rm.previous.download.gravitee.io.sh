#!/bin/bash

if [ "x${BASE_WWW_FOLDER}" == "x" ]; then
  echo "[BASE_WWW_FOLDER] env. var. is not set: set BASE_WWW_FOLDER to the path of the WWW folder served by the [https://download.gravitee.io] server"
  exit 3
fi;
export S3_BASE_URL=https://gravitee-releases-downloads.cellar-c2.services.clever-cloud.com

# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/distributions/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/distributions/graviteeio-full-3.5.8.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-github/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-github/gravitee-fetcher-github-1.5.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-git/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-git/gravitee-fetcher-git-1.7.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-bitbucket/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-bitbucket/gravitee-fetcher-bitbucket-1.6.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-gitlab/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-gitlab/gravitee-fetcher-gitlab-1.10.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-http/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-http/gravitee-fetcher-http-1.11.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/services/gravitee-gateway-services-ratelimit/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/services/gravitee-gateway-services-ratelimit/gravitee-gateway-services-ratelimit-1.11.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/services/gravitee-service-discovery-consul/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/services/gravitee-service-discovery-consul/gravitee-service-discovery-consul-1.2.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/reporters/gravitee-reporter-elasticsearch/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/reporters/gravitee-reporter-elasticsearch/gravitee-reporter-elasticsearch-3.5.2.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/reporters/gravitee-reporter-file/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/reporters/gravitee-reporter-file/gravitee-reporter-file-2.0.2.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/repositories/gravitee-repository-gateway-bridge-http-server/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/repositories/gravitee-repository-gateway-bridge-http-server/gravitee-repository-gateway-bridge-http-server-3.5.4.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/repositories/gravitee-repository-mongodb/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/repositories/gravitee-repository-mongodb/gravitee-repository-mongodb-3.5.2.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/repositories/gravitee-repository-jdbc/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/repositories/gravitee-repository-jdbc/gravitee-repository-jdbc-3.5.2.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/repositories/gravitee-repository-elasticsearch/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/repositories/gravitee-repository-elasticsearch/gravitee-repository-elasticsearch-3.5.2.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/repositories/gravitee-repository-gateway-bridge-http-client/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/repositories/gravitee-repository-gateway-bridge-http-client/gravitee-repository-gateway-bridge-http-client-3.5.4.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/resources/gravitee-resource-cache/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/resources/gravitee-resource-cache/gravitee-resource-cache-1.4.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/resources/gravitee-resource-oauth2-provider-generic/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/resources/gravitee-resource-oauth2-provider-generic/gravitee-resource-oauth2-provider-generic-1.15.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/resources/gravitee-resource-oauth2-provider-am/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/resources/gravitee-resource-oauth2-provider-am/gravitee-resource-oauth2-provider-am-1.12.2.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/service-discovery/gravitee-gateway-services-ratelimit/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/service-discovery/gravitee-gateway-services-ratelimit/gravitee-gateway-services-ratelimit-1.11.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-ssl-enforcement/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-ssl-enforcement/gravitee-policy-ssl-enforcement-1.2.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-xml-threat-protection/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-xml-threat-protection/gravitee-policy-xml-threat-protection-1.2.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-retry/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-retry/gravitee-policy-retry-1.0.1.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-jws/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-jws/gravitee-policy-jws-1.3.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-generate-jwt/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-generate-jwt/gravitee-policy-generate-jwt-1.5.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-rest-to-soap/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-rest-to-soap/gravitee-policy-rest-to-soap-1.11.1.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-openid-connect-userinfo/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-openid-connect-userinfo/gravitee-policy-openid-connect-userinfo-1.4.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-jwt/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-jwt/gravitee-policy-jwt-1.16.1.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-regex-threat-protection/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-regex-threat-protection/gravitee-policy-regex-threat-protection-1.2.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-latency/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-latency/gravitee-policy-latency-1.3.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-spikearrest/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-spikearrest/gravitee-policy-spikearrest-1.11.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-json-validation/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-json-validation/gravitee-policy-json-validation-1.6.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-oauth2/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-oauth2/gravitee-policy-oauth2-1.15.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-keyless/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-keyless/gravitee-policy-keyless-1.3.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-json-threat-protection/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-json-threat-protection/gravitee-policy-json-threat-protection-1.2.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-request-content-limit/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-request-content-limit/gravitee-policy-request-content-limit-1.7.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-mock/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-mock/gravitee-policy-mock-1.12.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-html-json/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-html-json/gravitee-policy-html-json-1.6.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-xml-json/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-xml-json/gravitee-policy-xml-json-1.7.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-request-validation/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-request-validation/gravitee-policy-request-validation-1.11.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-resource-filtering/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-resource-filtering/gravitee-policy-resource-filtering-1.8.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-json-to-json/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-json-to-json/gravitee-policy-json-to-json-1.6.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-xml-validation/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-xml-validation/gravitee-policy-xml-validation-1.1.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-assign-content/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-assign-content/gravitee-policy-assign-content-1.6.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-assign-attributes/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-assign-attributes/gravitee-policy-assign-attributes-1.5.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-callout-http/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-callout-http/gravitee-policy-callout-http-1.12.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-ipfiltering/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-ipfiltering/gravitee-policy-ipfiltering-1.6.1.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-role-based-access-control/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-role-based-access-control/gravitee-policy-role-based-access-control-1.1.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-groovy/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-groovy/gravitee-policy-groovy-1.12.1.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-ratelimit/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-ratelimit/gravitee-policy-ratelimit-1.11.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-transformheaders/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-transformheaders/gravitee-policy-transformheaders-1.8.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-url-rewriting/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-url-rewriting/gravitee-policy-url-rewriting-1.4.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-quota/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-quota/gravitee-policy-quota-1.11.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-override-http-method/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-override-http-method/gravitee-policy-override-http-method-1.3.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-apikey/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-apikey/gravitee-policy-apikey-2.2.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-xslt/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-xslt/gravitee-policy-xslt-1.6.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-cache/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-cache/gravitee-policy-cache-1.9.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-transformqueryparams/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-transformqueryparams/gravitee-policy-transformqueryparams-1.6.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-dynamic-routing/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-dynamic-routing/gravitee-policy-dynamic-routing-1.11.0.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/components/gravitee-gateway/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/components/gravitee-gateway/graviteeio-gateway-3.5.8.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/components/gravitee-management-rest-api/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/components/gravitee-management-rest-api/gravitee-management-rest-api-3.5.8.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/components/gravitee-portal-webui/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/components/gravitee-portal-webui/gravitee-portal-webui-3.5.8.zip
# mkdir -p ${BASE_WWW_FOLDER}/graviteeio-apim/components/gravitee-management-webui/
rm ${BASE_WWW_FOLDER}/graviteeio-apim/components/gravitee-management-webui/gravitee-management-webui-3.5.8.zip
