#!/bin/bash

export GPG_SECRETS_DIR=${HOME}/.retrieved.secrets/.gpg
export ARMOR_EXPORTED_KEYS_HOME="${HOME}/.exported.secrets/.gpg/armor-format"
export GNUPGHOME_PATH=${GNUPGHOME_PATH:-"/tmp/special.ops/.gnupg/keyring"}
mkdir -p ${GPG_SECRETS_DIR}
mkdir -p ${GNUPGHOME_PATH}
mkdir -p ${ARMOR_EXPORTED_KEYS_HOME}
mkdir -p ${HOME}/.exported.secrets/.gpg

echo "[$0] SECRETHUB_ORG=[${SECRETHUB_ORG}]"
echo "[$0] SECRETHUB_REPO=[${SECRETHUB_REPO}]"


echo "# ------------------------------------------ #"
echo "  [$0] Retrieve secrets from Secrethub Vault"
echo "# ------------------------------------------ #"
export GRAVITEEBOT_GPG_USER_NAME=$(secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/gpg/user_name")
export GRAVITEEBOT_GPG_USER_NAME_COMMENT=$(secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/gpg/user_name_comment")
export GRAVITEEBOT_GPG_USER_EMAIL=$(secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/gpg/user_email")
export GRAVITEEBOT_GPG_PASSPHRASE=$(secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/gpg/passphrase")




# Òsecrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/gpg/key_id"

if [ "x${GNUPGHOME_PATH}" == "x" ]; then
  echo "[GNUPGHOME_PATH] env. var. is not set, and must be."
  exit 2
fi;

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
export GNUPGHOME=${GNUPGHOME_PATH}
ls -allh ${GNUPGHOME}
gpg --list-secret-keys
gpg --list-keys


export ARMOR_FMT_EXPORTED_GPG_PUB_KEY_FILE="${ARMOR_EXPORTED_KEYS_HOME}/the.armor.exported.gpg.pub.key"
export ARMOR_FMT_EXPORTED_GPG_PRIVATE_KEY_FILE="${ARMOR_EXPORTED_KEYS_HOME}/the.armor.exported.gpg.priv.key"

mkdir -p ${ARMOR_EXPORTED_KEYS_HOME}
# --- #
# saving public and private GPG Keys as base  64 rncoded text files with [--armor] option
# gpg --export --armor -a "${GRAVITEEBOT_GPG_USER_NAME} (${GRAVITEEBOT_GPG_USER_NAME_COMMENT}) <${GRAVITEEBOT_GPG_USER_EMAIL}>" | tee ${ARMOR_FMT_EXPORTED_GPG_PUB_KEY_FILE}
# gpg --export --armor -a "${GRAVITEEBOT_GPG_USER_NAME} (${GRAVITEEBOT_GPG_USER_NAME_COMMENT}) <${GRAVITEEBOT_GPG_USER_EMAIL}>" --output ${ARMOR_FMT_EXPORTED_GPG_PUB_KEY_FILE}
gpg --export --armor -a "${GRAVITEEBOT_GPG_USER_NAME} (${GRAVITEEBOT_GPG_USER_NAME_COMMENT}) <${GRAVITEEBOT_GPG_USER_EMAIL}>" | tee ${ARMOR_FMT_EXPORTED_GPG_PUB_KEY_FILE}
# gpg --export -a "Jean-Baptiste Lasselle <jean.baptiste.lasselle.pegasus@gmail.com>" | tee ${ARMOR_FMT_EXPORTED_GPG_PUB_KEY_FILE}
# -- #
# Will be interactive for private key : you
# will have to type your GPG password
read -p "Open another shell, retrieve the GPG Passphrase with [secrethub read \"${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/gpg/passphrase\"], and press enter"
# gpg --export-secret-key --armor -a "${GRAVITEEBOT_GPG_USER_NAME} (${GRAVITEEBOT_GPG_USER_NAME_COMMENT}) <${GRAVITEEBOT_GPG_USER_EMAIL}>" | tee ${ARMOR_FMT_EXPORTED_GPG_PRIVATE_KEY_FILE}
# gpg --export-secret-key  --passphrase "${GRAVITEEBOT_GPG_PASSPHRASE}" --armor -a "${GRAVITEEBOT_GPG_USER_NAME} (${GRAVITEEBOT_GPG_USER_NAME_COMMENT}) <${GRAVITEEBOT_GPG_USER_EMAIL}>" --output ${ARMOR_FMT_EXPORTED_GPG_PRIVATE_KEY_FILE}
gpg --export-secret-key  --passphrase "${GRAVITEEBOT_GPG_PASSPHRASE}" --armor -a "${GRAVITEEBOT_GPG_USER_NAME} (${GRAVITEEBOT_GPG_USER_NAME_COMMENT}) <${GRAVITEEBOT_GPG_USER_EMAIL}>"  | tee ${ARMOR_FMT_EXPORTED_GPG_PRIVATE_KEY_FILE}


echo "checking existence of exported keys : "
echo "checking [\${HOME}/.exported.secrets/.gpg]"
ls -allh ${HOME}/.exported.secrets/.gpg
echo "checking [\${ARMOR_EXPORTED_KEYS_HOME}]=[${ARMOR_EXPORTED_KEYS_HOME}]"
ls -allh ${ARMOR_EXPORTED_KEYS_HOME}
echo "checking existence of [${ARMOR_FMT_EXPORTED_GPG_PRIVATE_KEY_FILE}]"
ls -allh ${ARMOR_FMT_EXPORTED_GPG_PRIVATE_KEY_FILE}
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

echo "JBL debug : do not save to secrethub until I am sure export is fine"
ls -allh ${ARMOR_FMT_EXPORTED_GPG_PUB_KEY_FILE}
ls -allh ${ARMOR_FMT_EXPORTED_GPG_PRIVATE_KEY_FILE}
secrethub write --in-file ${ARMOR_FMT_EXPORTED_GPG_PUB_KEY_FILE} "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/gpg/armor_format_pub_key"
secrethub write --in-file ${ARMOR_FMT_EXPORTED_GPG_PRIVATE_KEY_FILE} "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/gpg/armor_format_private_key"

exit 0
secrethub read --out-file ./test.armor_fmt_exported_gpg_pub_key_file "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/gpg/armor_format_pub_key"
secrethub read --out-file ./test.armor_fmt_exported_gpg_private_key_file "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/gpg/armor_format_private_key"
