#!/bin/bash


secrethub --version

echo "# -------------------------------------------------------------------- #"
echo "      Checking [${HOME}/.secrethub/]                                    "
echo "# -------------------------------------------------------------------- #"
ls -allh ${HOME}/
ls -allh ${HOME}/.secrethub/
ls -allh ${HOME}/.secrethub/credential

secrethub account inspect

export SECRETHUB_ORG=${SECRETHUB_ORG:-"graviteeio"}
export SECRETHUB_REPO=${SECRETHUB_REPO:-"cicd"}

echo "# -------------------------------------------------------------------- #"
echo "    Running Operations (Import binary Keys and Export [--armor] )       "
echo "# -------------------------------------------------------------------- #"
export GNUPGHOME_PATH="/tmp/special.ops/.gnupg/keyring"
mkdir -p ${GNUPGHOME_PATH}
chmod 700 -R ${GNUPGHOME_PATH}
export GPG_SIGNING_KEY_ID=$(secrethub read "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/gpg/key_id")

./setup-keyring-from-armor-format-gpg-keys.sh

./sign-test-file.sh
