


### Install `Kubectl` on GNU/Linux and Mac OS

* Install form Binary :

```bash
export WHERE_I_WAS=$(pwd)
export KCTL_INSTALL_OPS=$(mktemp -d -t "KCTL_INSTALL_OPS-XXXXXXXXXX")
completeKctlInstall () {
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  cd ${WHERE_I_WAS}
  rm -fr ${KCTL_INSTALL_OPS}
  kubectl version --client
}

# uninstall any kubectl previous installation, if any
if [ -f $(which kubectl) ]; then
  sudo rm $(which kubectl)
fi;

curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
# Validate the kubectl binary against the checksum file:
echo "$(<kubectl.sha256) kubectl" | sha256sum --check

export CHCKSUM_EXIT_CODE=$?
if [ "${CHCKSUM_EXIT_CODE}" == "0" ]; then
  completeKctlInstall
else
  echo "There was a problem checksumming downloaded Kubectl binary"
fi;


```



* Build from source :

```bash
#!/bin/bash

# uninstall any kubectl previous installation, if any
if [ -f $(which kubectl) ]; then
  sudo rm $(which kubectl)
fi;
# ---
# Install latest stable
export KCTL_LATEST_STABLE=$(curl -L -s https://dl.k8s.io/release/stable.txt)
export KCTL_VERSION=${KCTL_LATEST_STABLE}
export WHERE_I_WAS=$(pwd)
export KCTL_INSTALL_OPS=$(mktemp -d -t "KCTL_INSTALL_OPS-XXXXXXXXXX")
cd ${KCTL_INSTALL_OPS}

curl -L https://github.com/kubernetes/kubectl/archive/refs/tags/${KCTL_VERSION}.tar.gz -o kubectl-${KCTL_VERSION}.tar.gz

mkdir uncompressed/
tar -xvf kubectl-${KCTL_VERSION}.tar.gz -C uncompressed/
export GOLANG_VERSION=1.16
docker run --rm -v $PWD/uncompressed/kubectl-0.21.0/:/usr/src/myapp -w /usr/src/myapp golang:${GOLANG_VERSION} go build -v

# ---
# export FILE_NAME='kubectl'
# docker run --name checksummer -i --rm -v $PWD/uncompressed/kubectl-0.21.0/bin/kubectl:/root/ debian:buster-slim bash -c "cd /root && md5sum ./${FILE_NAME} > ./${FILE_NAME}.md5 && sha512sum ./${FILE_NAME} > ./${FILE_NAME}.sha512sum && sha1sum ${FILE_NAME} > ${FILE_NAME}.sha1"

# Validate the kubectl binary against the checksum file:
# echo "$(<kubectl.sha256) kubectl" | sha256sum --check
# echo "$(<uncompressed/kubectl.sha256) uncompressed/kubectl" | sha256sum --check
```

### Install `K3D` on GNU/Linux and Mac OS

```bash
#!/bin/bash

# uninstall any k3d previous installation, if any
if [ -f $(which k3d) ]; then
  # wipe  out all pre-existing cluster
  k3d delete cluster --all && docker system prune -f --all && docker system prune -f --volumes
  sudo rm $(which k3d)
fi;

# Install latest stable

export K3D_VERSION=v3.0.0-beta.1
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
