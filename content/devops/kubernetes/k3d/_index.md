

### Install `K3D` on GNU/Linux and Mac OS

```bash
#!/bin/bash

# uninstall any k3d previous installation, if any
if [ -f $(which k3d) ]; then
  # wipe  out all pre-existing cluster
  k3d delete cluster --all && docker system prune -f --all && docker system prune -f --volumes
  sudo rm $(which k3d)
fi;

# Install latest stable (`v1.7`)

https://github.com/rancher/k3d/releases/tag/v4.4.1

# Tested OK with :
# => [v3.0.0-beta.1]
# => [v4.4.1]
export K3D_VERSION=v3.0.0-beta.1
export K3D_VERSION=v4.4.1
# darwin, for macos, and will run in bash, on both linux and macos, coz of shebang
export K3D_OS=linux
export K3D_CPU_ARCH=amd64
export K3D_GH_BINARY_RELEASE_DWLD_URI="https://github.com/rancher/k3d/releases/download/${K3D_VERSION}/k3d-${K3D_OS}-${K3D_CPU_ARCH}"

# first, run the installation of the latest version so that all helpers bash env are installed

wget -q -O - https://raw.githubusercontent.com/rancher/k3d/master/install.sh | TAG=${K3D_VERSION} bash
# the delete installed standalone k3d binary
if [ -f /usr/local/bin/k3d ]; then
  sudo rm /usr/local/bin/k3d
else
  echo "k3d latest version was not properly installed, prior to beta version"
  exit 2
fi;

curl -L ${K3D_GH_BINARY_RELEASE_DWLD_URI} --output ./k3d



sudo mv k3d /usr/local/bin

sudo chmod a+x /usr/local/bin/k3d

k3d version


docker network create --driver bridge jbl_network

#
# ---
# multi master mode is really extremely unstable :
# every time I spawn up a multi master, it always
# ends up in a failed state, after a few minutes
# ---
#
# k3d create cluster jblCluster --masters 3 --workers 5 --network jbl_network
k3d create cluster jblCluster --masters 1 --workers 9 --network jbl_network



# this will create a ~/.kube/config file, with the kube configration inside of it, to use with Kubectl
export KUBECONFIG=$(k3d get kubeconfig jblCluster)
ls -allh ${KUBECONFIG}
cat ${KUBECONFIG}
```
