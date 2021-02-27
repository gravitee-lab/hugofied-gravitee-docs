#!/bin/bash

export GPG_SECRETS_DIR=${HOME}/.retrieved.secrets/.gpg/
export ARMOR_EXPORTED_KEYS_HOME="${GPG_SECRETS_DIR}/armor-format"
export GNUPGHOME_PATH=${GNUPGHOME_PATH:-"/tmp/special.ops/.gnupg/keyring"}
mkdir -p ${GPG_SECRETS_DIR}
mkdir -p ${GNUPGHOME_PATH}
mkdir -p ${ARMOR_EXPORTED_KEYS_HOME}



echo "# ------------------------------------------ #"
echo "  Retrieve secrets from Secrethub Vault"
echo "# ------------------------------------------ #"
export GRAVITEEBOT_GPG_USER_NAME=""
export GRAVITEEBOT_GPG_USER_NAME_COMMENT=""
export GRAVITEEBOT_GPG_USER_EMAIL=""
export GRAVITEEBOT_GPG_PASSPHRASE=""


if [ "x${GRAVITEEBOT_GPG_USER_NAME}" == "x" ]; then
  echo "[GRAVITEEBOT_GPG_USER_NAME] env. var. is not set, and must be."
  exit 2
fi;

if [ "x${GRAVITEEBOT_GPG_USER_NAME_COMMENT}" == "x" ]; then
  echo "[GRAVITEEBOT_GPG_USER_NAME_COMMENT] env. var. is not set, and must be."
  exit 3
fi;

if [ "x${GRAVITEEBOT_GPG_USER_EMAIL}" == "x" ]; then
  echo "[GRAVITEEBOT_GPG_USER_EMAIL] env. var. is not set, and must be."
  exit 4
fi;

if [ "x${GRAVITEEBOT_GPG_PASSPHRASE}" == "x" ]; then
  echo "[GRAVITEEBOT_GPG_PASSPHRASE] env. var. is not set, and must be."
  exit 5
fi;

# --- # --- # --- # --- # --- # --- # --- # --- # --- #
# --- # --- # --- # --- # --- # --- # --- # --- # --- #
# --- # --- # --- # --- # --- # --- # --- # --- # --- #

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
# ------------------------------------------------------------------------------------------------ #
# -- ARMOR EXPORT THE GPG KEY PAIR for the Gravitee.io bot --                         -- SECRET -- #
# ------------------------------------------------------------------------------------------------ #
ls -allh ${GNUPGHOME}
gpg --list-secret-keys
gpg --list-keys


export ARMOR_FMT_EXPORTED_GPG_PUB_KEY_FILE="${ARMOR_EXPORTED_KEYS_HOME}/the.armor.exported.gpg.pub.key"
export ARMOR_FMT_EXPORTED_GPG_PRIVATE_KEY_FILE="${ARMOR_EXPORTED_KEYS_HOME}/the.armor.exported.gpg.priv.key"


# --- #
# saving public and private GPG Keys as base  64 rncoded text files with [--armor] option
# gpg --export --armor -a "${GRAVITEEBOT_GPG_USER_NAME} (${GRAVITEEBOT_GPG_USER_NAME_COMMENT}) <${GRAVITEEBOT_GPG_USER_EMAIL}>" | tee ${ARMOR_FMT_EXPORTED_GPG_PUB_KEY_FILE}
gpg --export --armor -a "${GRAVITEEBOT_GPG_USER_NAME} (${GRAVITEEBOT_GPG_USER_NAME_COMMENT}) <${GRAVITEEBOT_GPG_USER_EMAIL}>" --output ${ARMOR_FMT_EXPORTED_GPG_PUB_KEY_FILE}
# gpg --export -a "Jean-Baptiste Lasselle <jean.baptiste.lasselle.pegasus@gmail.com>" | tee ${ARMOR_FMT_EXPORTED_GPG_PUB_KEY_FILE}
# -- #
# Will be interactive for private key : you
# will have to type your GPG password
# gpg --export-secret-key --armor -a "${GRAVITEEBOT_GPG_USER_NAME} (${GRAVITEEBOT_GPG_USER_NAME_COMMENT}) <${GRAVITEEBOT_GPG_USER_EMAIL}>" | tee ${ARMOR_FMT_EXPORTED_GPG_PRIVATE_KEY_FILE}
gpg --export-secret-key --armor -a "${GRAVITEEBOT_GPG_USER_NAME} (${GRAVITEEBOT_GPG_USER_NAME_COMMENT}) <${GRAVITEEBOT_GPG_USER_EMAIL}>" --output ${ARMOR_FMT_EXPORTED_GPG_PRIVATE_KEY_FILE}


export COMPUTED_GRAVITEEBOT_GPG_SIGNING_KEY_ID=$(gpg --list-signatures -a "${GRAVITEEBOT_GPG_USER_NAME} (${GRAVITEEBOT_GPG_USER_NAME_COMMENT}) <${GRAVITEEBOT_GPG_USER_EMAIL}>" | grep 'sig' | tail -n 1 | awk '{print $2}')

echo "# ---------------------------------------------------------------------- #"
echo "The exported GPG Public Key file is : [${ARMOR_FMT_EXPORTED_GPG_PUB_KEY_FILE}]"
echo "The exported GPG private Key file is : [${ARMOR_FMT_EXPORTED_GPG_PRIVATE_KEY_FILE}]"
echo ""
echo "Save Those two files as Pipeline artifacts to wdownload them with Circle CI API v2"
echo "# ---------------------------------------------------------------------- #"

echo "# ---------------------------------------------------------------------- #"
echo "The Key ID of our GPG Key pair is : [${COMPUTED_GRAVITEEBOT_GPG_SIGNING_KEY_ID}]"
echo "# ---------------------------------------------------------------------- #"


echo "# ---------------------------------------------------------------------- #"
echo "   Now Storing the Keys into the secrethub Vault "
echo "# ---------------------------------------------------------------------- #"

secrethub write --in-file ${ARMOR_FMT_EXPORTED_GPG_PUB_KEY_FILE} "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/gpg/armor_format_pub_key"
secrethub write --in-file ${ARMOR_FMT_EXPORTED_GPG_PRIVATE_KEY_FILE} "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/gpg/armor_format_private_key"
