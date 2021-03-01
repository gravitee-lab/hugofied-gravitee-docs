#!/bin/bash
export GPG_SECRETS_DIR=${HOME}/.retrieved.secrets/.gpg/
export PATH_TO_GPG_PUB_KEY_FILE="${GPG_SECRETS_DIR}/armor-format/graviteebot.gpg.key.public"
export PATH_TO_GPG_PRIVATE_KEY_FILE="${GPG_SECRETS_DIR}/armor-format/graviteebot.gpg.key.private"
export GNUPGHOME_PATH="/tmp/special.ops/.gnupg/keyring"
mkdir -p ${GPG_SECRETS_DIR}
mkdir -p ${GNUPGHOME_PATH}


echo "# ------------------------------------------ #"
echo "  GnuGPG version is :"
echo "# ------------------------------------------ #"
gpg --version
echo "# ------------------------------------------ #"
if [ "x${PATH_TO_GPG_PUB_KEY_FILE}" == "x" ]; then
  echo "[PATH_TO_GPG_PUB_KEY_FILE] env. var. is not set, and must be."
  exit 2
fi;

if [ "x${PATH_TO_GPG_PRIVATE_KEY_FILE}" == "x" ]; then
  echo "[PATH_TO_GPG_PRIVATE_KEY_FILE] env. var. is not set, and must be."
  exit 3
fi;

if [ "x${GPG_SIGNING_KEY_ID}" == "x" ]; then
  echo "[GPG_SIGNING_KEY_ID] env. var. is not set, and must be."
  exit 4
fi;

if [ "x${GNUPGHOME_PATH}" == "x" ]; then
  echo "[GNUPGHOME_PATH] env. var. is not set, and must be."
  exit 5
fi;


echo "# ------------------------------------------ #"
# export SECRETS_HOME=/home/NON_ROOT_USER_NAME/.secrets
# export RESTORED_GPG_PUB_KEY_FILE="${SECRETS_HOME}/.gungpg/graviteebot.gpg.pub.key"
# export RESTORED_GPG_PRIVATE_KEY_FILE="${SECRETS_HOME}/.gungpg/graviteebot.gpg.priv.key"
export RESTORED_GPG_PUB_KEY_FILE=${PATH_TO_GPG_PUB_KEY_FILE}
export RESTORED_GPG_PRIVATE_KEY_FILE=${PATH_TO_GPG_PRIVATE_KEY_FILE}

echo "# ------------------------------------------ #"
echo "  Retrieve secrets form Vault"
echo "# ------------------------------------------ #"
export GPG_SIGNING_KEY_ID=$(secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/gpg/key_id")
secrethub read --out-file ${RESTORED_GPG_PUB_KEY_FILE} "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/gpg/armor_format_pub_key"
secrethub read --out-file ${RESTORED_GPG_PRIVATE_KEY_FILE} "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/gpg/armor_format_private_key"

echo "# ------------------------------------------ #"

# export EPHEMERAL_KEYRING_FOLDER_ZERO=$(mktemp -d)
export EPHEMERAL_KEYRING_FOLDER_ZERO=${GNUPGHOME_PATH}

if [ -d ${EPHEMERAL_KEYRING_FOLDER_ZERO} ]; then
  rm -fr ${EPHEMERAL_KEYRING_FOLDER_ZERO}
fi;
mkdir -p ${EPHEMERAL_KEYRING_FOLDER_ZERO}
chmod 700 ${EPHEMERAL_KEYRING_FOLDER_ZERO}
export GNUPGHOME=${EPHEMERAL_KEYRING_FOLDER_ZERO}
echo "GPG Keys before import : "
# this will generate the empty keyring
gpg --list-keys

# ---
# Importing GPG KeyPair
echo "# ------------------------------------------ #"
echo "Now Importing GPG KeyPair : "
gpg --batch --import ${RESTORED_GPG_PRIVATE_KEY_FILE}
gpg --import ${RESTORED_GPG_PUB_KEY_FILE}
echo "# ------------------------------------------ #"
echo "GPG Keys after import : "
gpg --list-keys
echo "# ------------------------------------------ #"
echo "  GPG version is :"
echo "# ------------------------------------------ #"
gpg --version
echo "# ------------------------------------------ #"

# ---
# now we trust ultimately the Public Key in the Ephemeral Context,
export GRAVITEEBOT_GPG_SIGNING_KEY_ID=${GPG_SIGNING_KEY_ID}
echo "GRAVITEEBOT_GPG_SIGNING_KEY_ID=[${GRAVITEEBOT_GPG_SIGNING_KEY_ID}]"

echo -e "5\ny\n" |  gpg --command-fd 0 --expert --edit-key ${GRAVITEEBOT_GPG_SIGNING_KEY_ID} trust

echo "# ------------------------------------------ #"
echo "# --- OK READY TO SIGN"
echo "# ------------------------------------------ #"
