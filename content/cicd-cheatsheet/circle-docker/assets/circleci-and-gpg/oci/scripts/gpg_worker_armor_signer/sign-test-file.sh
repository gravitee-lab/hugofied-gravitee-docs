#!/bin/bash

export GPG_SECRETS_DIR=${HOME}/.retrieved.secrets/.gpg
export ARMOR_EXPORTED_KEYS_HOME="${HOME}/.exported.secrets/.gpg/armor-format"
mkdir -p ${GPG_SECRETS_DIR}
mkdir -p ${ARMOR_EXPORTED_KEYS_HOME}
mkdir -p ${HOME}/.exported.secrets/.gpg

echo "[$0] SECRETHUB_ORG=[${SECRETHUB_ORG}]"
echo "[$0] SECRETHUB_REPO=[${SECRETHUB_REPO}]"

echo "# ------------------------------------------ #"
echo "  [$0]"
echo "# ------------------------------------------ #"

echo "# ------------------------------------------ #"
echo "  [$0] Retrieve secrets from Secrethub Vault"
echo "# ------------------------------------------ #"




# Òsecrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/gpg/key_id"

if [ "x${GNUPGHOME_PATH}" == "x" ]; then
  echo "[GNUPGHOME_PATH] env. var. is not set, and must be."
  exit 2
fi;

if [ "x${GRAVITEEBOT_GPG_PASSPHRASE}" == "x" ]; then
  echo "[GRAVITEEBOT_GPG_PASSPHRASE] env. var. is not set, and must be."
  exit 5
fi;




export GNUPGHOME=${GNUPGHOME_PATH}
# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
# ------------------------------------------------------------------------------------------------ #
# -- TESTS --                          First Let's Sign a file                         -- TESTS -- #
# ------------------------------------------------------------------------------------------------ #
cat > ${HOME}/.signed.files/some-file-to-sign.txt <<EOF
Hey I ma sooo important a file that
I am in a file which is going to be signed to proove my integrity
EOF


echo "# ------------------------------------------ #"
echo "  [$0] "
echo "  Retrieve secrets from Secrethub Vault"
echo "# ------------------------------------------ #"

export GRAVITEEBOT_GPG_PASSPHRASE=$(secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/gpg/passphrase")

# echo "${GRAVITEEBOT_GPG_PASSPHRASE}" | gpg --pinentry-mode loopback --passphrase-fd 0 --sign ./some-file-to-sign.txt

# ---
# That's Jean-Baptiste Lasselle's GPG SIGNING KEY ID for signing git commits n tags (used as example)
# export GPG_SIGNING_KEY_ID=7B19A8E1574C2883
# ---
# That's the GPG_SIGNING_KEY used buy the "Gravitee.io Bot" for git and signing any file
# export GRAVITEEBOT_GPG_SIGNING_KEY_ID=$(gpg --list-signatures -a "${GRAVITEEBOT_GPG_USER_NAME} (${GRAVITEEBOT_GPG_USER_NAME_COMMENT}) <${GRAVITEEBOT_GPG_USER_EMAIL}>" | grep 'sig' | tail -n 1 | awk '{print $2}')
export GRAVITEEBOT_GPG_SIGNING_KEY_ID=$(secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/gpg/key_id")
echo "GRAVITEEBOT_GPG_SIGNING_KEY_ID=[${GRAVITEEBOT_GPG_SIGNING_KEY_ID}]"

gpg --keyid-format LONG -k "0x${GRAVITEEBOT_GPG_SIGNING_KEY}"

echo "# ---------------------------------------------------------------------- #"
echo "  [$0] "
echo "   Now Signing a test file"
echo "# ---------------------------------------------------------------------- #"


echo "${GRAVITEEBOT_GPG_PASSPHRASE}" | gpg -u "0x${GRAVITEEBOT_GPG_SIGNING_KEY}" --pinentry-mode loopback --passphrase-fd 0 --sign ${HOME}/.signed.files/some-file-to-sign.txt
echo "${GRAVITEEBOT_GPG_PASSPHRASE}" | gpg -u "0x${GRAVITEEBOT_GPG_SIGNING_KEY}" --pinentry-mode loopback --passphrase-fd 0 --detach-sign ${HOME}/.signed.files/some-file-to-sign.txt



echo "# ---------------------------------------------------------------------- #"
echo "  [$0] "
echo "   Here are the signatures of the test file : "
echo "# ---------------------------------------------------------------------- #"
ls -all ${HOME}/.signed.files/
echo "# ---------------------------------------------------------------------- #"


# -- #
