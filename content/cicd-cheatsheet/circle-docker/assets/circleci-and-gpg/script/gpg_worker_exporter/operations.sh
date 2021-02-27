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
export SECRETHUB_ORG=${SECRETHUB_REPO:-"cicd"}

echo "# -------------------------------------------------------------------- #"
echo "    Running Operations (Import binary Keys and Export [--armor] )       "
echo "# -------------------------------------------------------------------- #"
export GNUPGHOME_PATH="/tmp/special.ops/.gnupg/keyring"
./setup-keyring-from-binary-format-gpg-keys.sh

./export-gpg-keys-with-armor-n-secrethub.sh
