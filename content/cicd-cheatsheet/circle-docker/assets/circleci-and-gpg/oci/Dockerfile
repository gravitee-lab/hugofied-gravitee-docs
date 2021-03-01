ARG DEBIAN_IMAGE_TAG=buster-slim
FROM debian:buster-slim

RUN apt-get update -y && apt-get install -y gnupg build-essential tree curl
ARG OCI_VENDOR=$GITHUB_ORG
LABEL oci.image.tag="${DEBIAN_IMAGE_TAG}-debian"
LABEL oci.image.from="debian:$DEBIAN_IMAGE_TAG"
LABEL vendor="${OCI_VENDOR}"
LABEL maintainer="jean-baptiste.lasselle@graviteesource.com"


# --- NON ROOT USER
ARG NON_ROOT_USER_UID=1000
ENV NON_ROOT_USER_UID=$NON_ROOT_USER_UID
ARG NON_ROOT_USER_GID=1000
ENV NON_ROOT_USER_GID=$NON_ROOT_USER_GID

ARG NON_ROOT_USER_NAME=circleci
ENV NON_ROOT_USER_NAME=$NON_ROOT_USER_NAME
ARG NON_ROOT_USER_GRP=circleci
ENV NON_ROOT_USER_GRP=$NON_ROOT_USER_GRP

# ENV SECRETHUB_CREDENTIAL=$SECRETHUB_CREDENTIAL

LABEL oci.image.nonroot.user.name=$NON_ROOT_USER_NAME
LABEL oci.image.nonroot.user.group=$NON_ROOT_USER_GRP
LABEL oci.image.nonroot.user.uid=$NON_ROOT_USER_UID
LABEL oci.image.nonroot.user.gid=$NON_ROOT_USER_GID

# ------------------------------------------------
# -----  INSTALL SECRETHUB CLI
# ------------------------------------------------
COPY install-secrethub-cli.sh .
RUN chmod +x ./install-secrethub-cli.sh && ./install-secrethub-cli.sh
# ------------------------------------------------
# -----  NON ROOT USER
# ------------------------------------------------

RUN echo "List of Linux users : " && awk -F: '{ print $1 " " $2 " uid : " $3 " gid : " $4}' /etc/passwd
RUN echo "Here are the linux groups "
RUN users && groups && id
# RUN groupadd -g $NON_ROOT_USER_GID $NON_ROOT_USER_GRP || true
RUN groupadd $NON_ROOT_USER_GRP || true
RUN useradd -g $NON_ROOT_USER_GRP -u $NON_ROOT_USER_UID -m $NON_ROOT_USER_NAME
# RUN useradd -g $NON_ROOT_USER_GRP -u $NON_ROOT_USER_UID -m $NON_ROOT_USER_NAME || true

RUN ls -allh /home/$NON_ROOT_USER_NAME
# --
# workaround old known issue of docker for non-root users https://github.com/moby/moby/issues/2259#issuecomment-26564115
RUN mkdir -p /home/$NON_ROOT_USER_NAME/.m2
RUN mkdir -p /home/$NON_ROOT_USER_NAME/.m2
RUN chown $NON_ROOT_USER_NAME:$NON_ROOT_USER_GRP /home/$NON_ROOT_USER_NAME/.m2

RUN echo "whoami = [$(whoami)]"
USER $NON_ROOT_USER_NAME
RUN echo "whoami = [$(whoami)]"

# --- #
# /home/$NON_ROOT_USER_NAME/.secrets will be mapped as a
# volume for secrets from outside(no secretsin a container image)
#
RUN mkdir -p /home/$NON_ROOT_USER_NAME/.secrets
RUN chown $NON_ROOT_USER_NAME:$NON_ROOT_USER_GRP /home/$NON_ROOT_USER_NAME/.secrets
RUN mkdir -p /home/$NON_ROOT_USER_NAME/scripts
COPY scripts/ /home/$NON_ROOT_USER_NAME/scripts/
WORKDIR /home


# CMD ["/bin/bash"]
