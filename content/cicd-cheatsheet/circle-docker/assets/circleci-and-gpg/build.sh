#!/bin/bash

set -x


# -------------------------------------------------------------------------------- #
# -------------------------------------------------------------------------------- #
# -----------             COCKPIT MAVEN DOCKER IMAGE                     --------- #
# -------------------------------------------------------------------------------- #
# -------------------------------------------------------------------------------- #

# --
export MAVEN_VERSION=${MAVEN_VERSION:-"3.6.3"}
export OPENJDK_VERSION=${OPENJDK_VERSION:-"11"}
export OCI_REPOSITORY_ORG=${OCI_REPOSITORY_ORG:-"docker.io/graviteeio"}
export OCI_REPOSITORY_NAME=${OCI_REPOSITORY_NAME:-"cicd-gpg-maven"}


export OCI_VENDOR=gravitee.io
export MAPPED_USER_ID=$(id -u)
export MAPPED_USER_GID=$(id -g)
# [runMavenShellScript] - Will Run Maven Shell Script with MAPPED_USER_ID=[1001]
# [runMavenShellScript] - Will Run Maven Shell Script with MAPPED_USER_GID=[1002]
# export MAPPED_USER_ID=1001
# export MAPPED_USER_GID=1002
export NON_ROOT_USER_UID=${MAPPED_USER_ID}
# export NON_ROOT_USER_NAME=$(whoami)
export NON_ROOT_USER_NAME=graviteebot
export NON_ROOT_USER_GID=${MAPPED_USER_GID}
export NON_ROOT_USER_GRP=${NON_ROOT_USER_NAME}

export DESIRED_DOCKER_TAG="${MAVEN_VERSION}-openjdk-${OPENJDK_VERSION}"

docker-compose -f docker-compose.build.yml build

exit 0
# -------------------------------------------------------------------------------- #
# -----------                         DOCKER BUILD                       --------- #
# -------------------------------------------------------------------------------- #


export OCI_BUILD_ARGS="--build-arg MAVEN_VERSION=${MAVEN_VERSION} --build-arg OPENJDK_VERSION=${OPENJDK_VERSION} --build-arg OCI_VENDOR=${OCI_VENDOR}"
export OCI_BUILD_ARGS="${OCI_BUILD_ARGS}"
export OCI_BUILD_ARGS="${OCI_BUILD_ARGS} --build-arg NON_ROOT_USER_UID=${NON_ROOT_USER_UID} --build-arg NON_ROOT_USER_GID=${NON_ROOT_USER_GID}"
export OCI_BUILD_ARGS="${OCI_BUILD_ARGS} --build-arg NON_ROOT_USER_NAME=${NON_ROOT_USER_NAME} --build-arg NON_ROOT_USER_GRP=${NON_ROOT_USER_GRP}"

docker build -t "${OCI_REPOSITORY_ORG}/${OCI_REPOSITORY_NAME}:${DESIRED_DOCKER_TAG}" ${OCI_BUILD_ARGS} -f ./circleci-and-gpg/Dockerfile ./circleci-and-gpg/
docker tag "${OCI_REPOSITORY_ORG}/${OCI_REPOSITORY_NAME}:${DESIRED_DOCKER_TAG}" "${OCI_REPOSITORY_ORG}/${OCI_REPOSITORY_NAME}:stable-latest"
