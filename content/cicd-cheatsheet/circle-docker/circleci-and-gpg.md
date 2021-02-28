---
title: "Circle CI, Docker and GPG"
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "Circle CI and Docker"
menu: circle_docker
menu_index: 3
product: "Gravitee APIM"
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: circle-docker
---

## The problem

Explain the problem


### From the binary KEys, to the base64 encoded Text Keys

I will, in a container :

* Import the Gravitee Bot public and private Keys
* Then I will export them but as base64 encoded text files, instead of binary files, using the `--armor` option
* Then I will store the base64 encoded text files exported Keys into secrethub
* And I will finally import those base64 encoded text files exported GPG Keys  into a Circle CI Docker executor. I will do that in this github repository : https://github.com/gravitee-lab/cicd_test_docker_n_gpg.git git@github.com:gravitee-lab/cicd_test_docker_n_gpg.git


* run the docker-compose :

```bash
git clone git@github.com:gravitee-lab3/hugofied-gravitee-docs.git hugofied-gpg-work/
cd hugofied-gpg-work/
cd content/cicd-cheatsheet/circle-docker/assets/circleci-and-gpg/

./build.sh


```


* import the Gravitee Bot public and private Keys :

```bash
#!/bin/bash

export GPG_SECRETS_DIR=${HOME}/.retrieved.secrets/.gpg/
export PATH_TO_GPG_PUB_KEY_FILE="${GPG_SECRETS_DIR}/binary-format/graviteebot.gpg.key.public"
export PATH_TO_GPG_PRIVATE_KEY_FILE="${GPG_SECRETS_DIR}/binary-format/graviteebot.gpg.key.private"
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
secrethub read --out-file ${RESTORED_GPG_PUB_KEY_FILE} "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/gpg/pub_key"
secrethub read --out-file ${RESTORED_GPG_PRIVATE_KEY_FILE} "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/gpg/private_key"

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

```

* export them but as base64 encoded text files, and store them into `secrethub` vault :

```bash

export GRAVITEEBOT_GPG_USER_NAME=""
export GRAVITEEBOT_GPG_USER_NAME_COMMENT=""
export GRAVITEEBOT_GPG_USER_EMAIL=""
export GRAVITEEBOT_GPG_PASSPHRASE=""
export GNUPGHOME_PATH="/tmp/special.ops/.gnupg/keyring"
mkdir -p ${GNUPGHOME_PATH}

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
#        GPG Key Pair of the Gravitee Lab Bot         #
#                for Github SSH Service               #
#                to GPG sign maven artifacts          #
#        >>> GPG version 2.x ONLY!!!                  #
# --- # --- # --- # --- # --- # --- # --- # --- # --- #
# --- # --- # --- # --- # --- # --- # --- # --- # --- #
# --- # --- # --- # --- # --- # --- # --- # --- # --- #
# -------------------------------------------------------------- #
# -------------------------------------------------------------- #
# for the Gravitee CI CD Bot in
# the https://github.com/gravitee-lab Github Org
# -------------------------------------------------------------- #
# -------------------------------------------------------------- #
# https://www.gnupg.org/documentation/manuals/gnupg-devel/Unattended-GPG-key-generation.html

# ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ #
# ------------------------------------------------------------------------------------------------ #
# -- ARMOR EXPORT THE GPG KEY PAIR for the Gravitee.io bot --                         -- SECRET -- #
# ------------------------------------------------------------------------------------------------ #
ls -allh ${GNUPGHOME}
gpg --list-secret-keys
gpg --list-keys


export GPG_PUB_KEY_FILE="$(pwd)/the.armor.exported.gpg.pub.key"
export GPG_PRIVATE_KEY_FILE="$(pwd)/the.armor.exported.gpg.priv.key"


# --- #
# saving public and private GPG Keys as base  64 rncoded text files with [--armor] option
# gpg --export --armor -a "${GRAVITEEBOT_GPG_USER_NAME} (${GRAVITEEBOT_GPG_USER_NAME_COMMENT}) <${GRAVITEEBOT_GPG_USER_EMAIL}>" | tee ${GPG_PUB_KEY_FILE}
gpg --export --armor -a "${GRAVITEEBOT_GPG_USER_NAME} (${GRAVITEEBOT_GPG_USER_NAME_COMMENT}) <${GRAVITEEBOT_GPG_USER_EMAIL}>" --output ${GPG_PUB_KEY_FILE}
# gpg --export -a "Jean-Baptiste Lasselle <jean.baptiste.lasselle.pegasus@gmail.com>" | tee ${GPG_PUB_KEY_FILE}
# -- #
# Will be interactive for private key : you
# will have to type your GPG password
# gpg --export-secret-key --armor -a "${GRAVITEEBOT_GPG_USER_NAME} (${GRAVITEEBOT_GPG_USER_NAME_COMMENT}) <${GRAVITEEBOT_GPG_USER_EMAIL}>" | tee ${GPG_PRIVATE_KEY_FILE}
gpg --export-secret-key --armor -a "${GRAVITEEBOT_GPG_USER_NAME} (${GRAVITEEBOT_GPG_USER_NAME_COMMENT}) <${GRAVITEEBOT_GPG_USER_EMAIL}>" --output ${GPG_PRIVATE_KEY_FILE}


export GRAVITEEBOT_GPG_SIGNING_KEY_ID=$(gpg --list-signatures -a "${GRAVITEEBOT_GPG_USER_NAME} (${GRAVITEEBOT_GPG_USER_NAME_COMMENT}) <${GRAVITEEBOT_GPG_USER_EMAIL}>" | grep 'sig' | tail -n 1 | awk '{print $2}')

echo "# ---------------------------------------------------------------------- #"
echo "The exported GPG Public Key file is : [${GPG_PUB_KEY_FILE}]"
echo "The exported GPG private Key file is : [${GPG_PRIVATE_KEY_FILE}]"
echo ""
echo "Save Those two files as Pipeline artifacts to wdownload them with Circle CI API v2"
echo "# ---------------------------------------------------------------------- #"

echo "# ---------------------------------------------------------------------- #"
echo "The Key ID of our GPG Key pair is : [${GRAVITEEBOT_GPG_SIGNING_KEY_ID}]"
echo "# ---------------------------------------------------------------------- #"

```

#### Build the container

```bash
git clone git@github.com:gravitee-lab3/hugofied-gravitee-docs.git

cd hugofied-gravitee-docs

content/cicd-cheatsheet/circle-docker/oci

chmod +x ./build.sh
./build.sh

```
