#!/usr/bin/env bash

# ---
# First I need to locally install Git LFS Client
# ---
#
# https://github.com/git-lfs/git-lfs#installing
#
# ---


export GIT_LFS_OPS_HOME=$(mktemp -d -t "git_lfs_install_ops-XXXXXXXXXX")
# https://github.com/git-lfs/git-lfs/releases
export GIT_LFS_VERSION=2.13.2
export GIT_LFS_OS=linux
export GIT_LFS_CPU_ARCH=amd64
curl -LO https://github.com/git-lfs/git-lfs/releases/download/v${GIT_LFS_VERSION}/git-lfs-${GIT_LFS_OS}-${GIT_LFS_CPU_ARCH}-v${GIT_LFS_VERSION}.tar.gz
tar -xvf ./git-lfs-${GIT_LFS_OS}-${GIT_LFS_CPU_ARCH}-v${GIT_LFS_VERSION}.tar.gz -C ${GIT_LFS_OPS_HOME}
sudo ${GIT_LFS_OPS_HOME}/install.sh
git lfs install
git lfs version
