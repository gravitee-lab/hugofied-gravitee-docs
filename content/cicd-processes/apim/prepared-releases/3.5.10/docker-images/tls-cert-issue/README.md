# An issue among others


The Docker Image Build fails because the TLS Cert of https://download.gravitee.io is considered invalid in the Circle CI Pipeline.


```bash
export SERVER_HOST=${SERVER_HOST:-"download.gravitee.io"}
export SERVER_NAME=${SERVER_NAME:-"download.gravitee.io"}

ping -c 4 ${SERVER_HOST}
echo "# ------------------------------------------------------------------- #"
echo "Checking TLS/SSL Cert validity of [${SERVER_HOST}] server , check 1 : "
echo "# ------------------------------------------------------------------- #"

if true | openssl s_client -connect ${SERVER_HOST}:443 2>/dev/null | \
  openssl x509 -noout -checkend 0; then
  echo "Certificate is not expired"
else
  echo "Certificate is expired"
fi

echo "# ------------------------------------------------------------------- #"
echo "Checking TLS/SSL Cert validity of [${SERVER_HOST}] server , check 2 : "
echo "# ------------------------------------------------------------------- #"

if true | openssl s_client -servername ${SERVER_NAME} -connect ${SERVER_HOST}:443 2>/dev/null | \
  openssl x509 -noout -checkend 0; then
  echo "Certificate is not expired"
else
  echo "Certificate is expired"
fi


```



ADD your_ca_root.crt /usr/local/share/ca-certificates/foo.crt
RUN chmod 644 /usr/local/share/ca-certificates/foo.crt && update-ca-certificates
