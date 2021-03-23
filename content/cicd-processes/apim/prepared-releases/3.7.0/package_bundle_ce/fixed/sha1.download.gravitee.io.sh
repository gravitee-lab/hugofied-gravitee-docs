#!/bin/bash

echo "implementation not finished"

exit 0
if [ "x${BASE_WWW_FOLDER}" == "x" ]; then
  echo "[BASE_WWW_FOLDER] env. var. is not set: set BASE_WWW_FOLDER to the path of the WWW folder served by the [https://download.gravitee.io] server"
  exit 3
fi;

export S3_BASE_URL=https://gravitee-releases-downloads.cellar-c2.services.clever-cloud.com

sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/distributions/graviteeio-full-3.7.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-github/gravitee-fetcher-github-1.5.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-git/gravitee-fetcher-git-1.7.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-bitbucket/gravitee-fetcher-bitbucket-1.6.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-gitlab/gravitee-fetcher-gitlab-1.10.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/fetchers/gravitee-fetcher-http/gravitee-fetcher-http-1.11.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/services/gravitee-gateway-services-ratelimit/gravitee-gateway-services-ratelimit-1.11.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/services/gravitee-service-discovery-consul/gravitee-service-discovery-consul-1.2.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/reporters/gravitee-reporter-tcp/gravitee-reporter-tcp-1.2.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/reporters/gravitee-reporter-elasticsearch/gravitee-reporter-elasticsearch-3.6.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/reporters/gravitee-reporter-file/gravitee-reporter-file-2.2.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/repositories/gravitee-repository-gateway-bridge-http-server/gravitee-repository-gateway-bridge-http-server-3.7.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/repositories/gravitee-repository-mongodb/gravitee-repository-mongodb-3.7.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/repositories/gravitee-repository-jdbc/gravitee-repository-jdbc-3.7.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/repositories/gravitee-repository-elasticsearch/gravitee-repository-elasticsearch-3.6.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/repositories/gravitee-repository-gateway-bridge-http-client/gravitee-repository-gateway-bridge-http-client-3.7.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/resources/gravitee-resource-cache/gravitee-resource-cache-1.5.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/resources/gravitee-resource-oauth2-provider-generic/gravitee-resource-oauth2-provider-generic-1.15.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/resources/gravitee-resource-oauth2-provider-am/gravitee-resource-oauth2-provider-am-1.13.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/service-discovery/gravitee-gateway-services-ratelimit/gravitee-gateway-services-ratelimit-1.11.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/connectors/gravitee-cockpit-connectors-ws/gravitee-cockpit-connectors-ws-1.0.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-ssl-enforcement/gravitee-policy-ssl-enforcement-1.2.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-xml-threat-protection/gravitee-policy-xml-threat-protection-1.2.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-retry/gravitee-policy-retry-1.1.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-jws/gravitee-policy-jws-1.3.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-generate-jwt/gravitee-policy-generate-jwt-1.5.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-rest-to-soap/gravitee-policy-rest-to-soap-1.12.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-openid-connect-userinfo/gravitee-policy-openid-connect-userinfo-1.4.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-jwt/gravitee-policy-jwt-1.17.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-regex-threat-protection/gravitee-policy-regex-threat-protection-1.2.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-latency/gravitee-policy-latency-1.3.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-spikearrest/gravitee-policy-spikearrest-1.11.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-json-validation/gravitee-policy-json-validation-1.6.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-oauth2/gravitee-policy-oauth2-1.16.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-keyless/gravitee-policy-keyless-1.3.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-json-threat-protection/gravitee-policy-json-threat-protection-1.2.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-request-content-limit/gravitee-policy-request-content-limit-1.7.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-mock/gravitee-policy-mock-1.12.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-html-json/gravitee-policy-html-json-1.6.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-xml-json/gravitee-policy-xml-json-1.7.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-request-validation/gravitee-policy-request-validation-1.11.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-resource-filtering/gravitee-policy-resource-filtering-1.8.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-json-to-json/gravitee-policy-json-to-json-1.6.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-xml-validation/gravitee-policy-xml-validation-1.1.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-assign-content/gravitee-policy-assign-content-1.6.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-http-signature/gravitee-policy-http-signature-1.1.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-assign-attributes/gravitee-policy-assign-attributes-1.5.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-callout-http/gravitee-policy-callout-http-1.12.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-ipfiltering/gravitee-policy-ipfiltering-1.7.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-role-based-access-control/gravitee-policy-role-based-access-control-1.1.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-groovy/gravitee-policy-groovy-1.12.1.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-ratelimit/gravitee-policy-ratelimit-1.11.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-transformheaders/gravitee-policy-transformheaders-1.8.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-url-rewriting/gravitee-policy-url-rewriting-1.4.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-quota/gravitee-policy-quota-1.11.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-override-http-method/gravitee-policy-override-http-method-1.3.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-apikey/gravitee-policy-apikey-2.2.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-xslt/gravitee-policy-xslt-1.6.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-json-xml/gravitee-policy-json-xml-1.0.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-cache/gravitee-policy-cache-1.10.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-transformqueryparams/gravitee-policy-transformqueryparams-1.6.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/plugins/policies/gravitee-policy-dynamic-routing/gravitee-policy-dynamic-routing-1.11.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/components/gravitee-gateway/gravitee-gateway-3.7.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/components/gravitee-management-rest-api/gravitee-management-rest-api-3.7.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/components/gravitee-portal-webui/gravitee-portal-webui-3.7.0.zip
sha1sum ${BASE_WWW_FOLDER}/graviteeio-apim/components/gravitee-management-webui/gravitee-management-webui-3.7.0.zip
