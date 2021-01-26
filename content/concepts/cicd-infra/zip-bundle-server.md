---
title: "The Zip Bundles Downloads Server"
date: 2020-12-16T00:44:23+01:00
draft: false
nav_menu: "Standard Operations"
menu: cicd_infra
menu_index: 11
# menu:
  # developer_guide:
    # parent: 'mainmenu'
type: cicd-infra
---

# _(Work in progress)_



### Description of the CI CD System Component(s)

All container images of __Gravitee APIM__, and most of Gravitee.io Products, are defined by `Dockerfile`s, whose docker build process makes use of two "downloads" servers :
* https://dist.gravitee.io/
* and https://download.gravitee.io/

### CI CD Processes using the CI CD System Component(s)

The https://dist.gravitee.io/ and https://download.gravitee.io/ _" Zip bundles Downloads Server(s)"_ , are dependencies of the two following CI CD Processes, For `Gravitee APIM` and most of Gravitee Products :
* Continuous Delivery and Deployment of the Stable Release
* Continuous Delivery and Deployment of the Nightly Release

### Legacy Design

For the https://dist.gravitee.io/ :
* Apache HttpServer
* Its content is defined by the workspace of a Jenkins Job : the Jenkins job which in the legacy CICD Sytem, builds the nightly release of `Gravitee APIM`
* This service only cares about on Gravitee Product :  `Gravitee APIM`



For the https://download.gravitee.io/ :
* Apache HttpServer
* content defined by the https://github.com/gravitee-io/dist.gravitee.io git repo:
  * the files served at the root of https://download.gravitee.io
  * are exactly defined as if the https://github.com/gravitee-io/dist.gravitee.io was git cloned at the root of "the `www/` folder" of the https://download.gravitee.io Apache server
* The  distributed zip bundles, are for the releases of the following Gravitee Products :
  * [Gravitee APIM, Community Edition](https://github.com/gravitee-io/dist.gravitee.io/tree/master/graviteeio-apim)
  * [Gravitee APIM, Entreprise Edition](https://github.com/gravitee-io/dist.gravitee.io/tree/master/graviteeio-ee/apim)
  * [Gravitee AM, Community Edition](https://github.com/gravitee-io/dist.gravitee.io/tree/master/graviteeio-am)
  * [Gravitee AM, Enreprise Edition](https://github.com/gravitee-io/dist.gravitee.io/tree/master/graviteeio-ee/am)
  * [Gravitee Alert Engine](https://github.com/gravitee-io/dist.gravitee.io/tree/master/graviteeio-ae)
  * There are also other distributed bundles :
    * [Gravitee "Notifiers" Plugins](https://github.com/gravitee-io/dist.gravitee.io/tree/master/plugins/notifiers) : those are components developedby the Gravitee Team
    * [Sample APIs](https://github.com/gravitee-io/dist.gravitee.io/tree/master/sample-apis) are simple APIs used for tests and demo purposes, by the gravitee team.Their souce codeis versioned in the https://github.com/gravitee-io/gravitee-sample-apis git repo


### The problem of the Legacy Design

A problem is common to both of https://download.gravitee.io/ and https://dist.gravitee.io/ :
* no limits are openly, clearly defined,
* when do we stop serving given file ?
* those limits should probably synced to the LTS / STS policies : the CICD System shoudl automatically comply with those poicies, and these policies should be configuration parameters of the CI CD System.

This first problem will be addresseed, but is not the most critical in the Legacy CICD System.

The two server-specific problems described below, are more important to solve, before we address this common problem.

#### The problem of the  https://download.gravitee.io/ server

The content served by this server is updated by git cloning the https://github.com/gravitee-io/dist.gravitee.io git repo :
* This `git clone` operation is very long, since new files are pushed with git commits
* the files being held by the git repository, it will be even longer to perfom operations like is not easy to perform operations like  "get rid of files older than a given date",

#### The problem of the  https://dist.gravitee.io/ server

* The operation of updating the content served by https://dist.gravitee.io/ is completely tied to Jenkins :
  * The server is an Apache Server, and the content of its _"www/"_ folder is mapped as a docker volume, to the workspace of a Jenkins job, directly on the Jenkins Worker machine :  If the Jenkins service goes down, the https://dist.gravitee.io/ goes down with it.
  * If we want to use other Pipeline service providers, like `Circle CI`, `Drone`, or `Tekton`, well we have to completely redesign the https://dist.gravitee.io/ service with that migration

So here, we see that the Legacy system cries out for a decoupling between :
* the Pipeline Service provider used in the CI CD System : the part of the CI CD System which processes big jbo to build the zip bundle files to be served
* and the simple static files server responsible dfor serving those files, on the other hand


### The Target Design to solve our problem(s)

Alright, now if we sum up :
* For the https://download.gravitee.io/ service :
  * we a decoupling between the Pipeline Service provider, and the https://download.gravitee.io/ service, responsible of making available for download, the GRavitee Porducts zip bundles files :  the decoupling is realized using a git repository to store the built zip bundles, after they are built by the pipelines, and before publishing them to the https://download.gravitee.io/ service
  * but this decoupling solution makes stadnard operations slow : we doomed to git clone a huge size git repository, and managing "limits synced to STS / LTS policies" is made even more complex.
* For the https://dist.gravitee.io/ service :
  * we lack a decoupling between the Pipeline Service provider, and the https://download.gravitee.io/ service
  * this makes the https://dist.gravitee.io/ service both very non resilient, and complex to migrate in case we wxould like to try different Pipeline service providers (`Drone`, `Circle CI`, `Tekton`, etc...) th

Okay, so for both of those services, we :
* will use an S3 bucket to :
   * realize a decoupling between the Pipeline Service provider, and the https://download.gravitee.io/ service
   * realize a decoupling between the Pipeline Service provider, and the https://dist.gravitee.io/ service
   * make incremental content update a quick as possible
   * make any "no files older than"-like policies easy and stright forward to implement
* and we will use an S3 bucket, because most of the Cloud providers offer the feature of turning an S3 bucket into a static files server.

### Planned path to Target Design




#### POCs

Therefore, a first main design task will be to conduct a POC where :

* A set of `N` (`N > 1`) pipelines produce `N` zip files an jar files with a maven `mvn clean install` command. Here I will use forks of exitiing https://github.com/gravitee-io repos, to make the POC "real-life"
* Those `N` files are pushed to an S3 bucket
* The S3 bucket is configured to serve its files as a static fiels server


Next POC (migration, consolidation, Circle CI Orb Command to sync S3 bucket) :
* CI CD Process "Stable Release" :
  * migration of the existing content at https://download.gravitee.io/, to the s3 bucket
  * launching a `Gravitee APIM` Stable Release must update the content of https://download.gravitee.io/
* CI CD Process "Nightly Release" :
  * migration of the existing content at https://dist.gravitee.io/, to the s3 bucket
  * launching a `Gravitee APIM` Nightly Release must update the content of https://dist.gravitee.io/



Misc.  requirements:
* Migrations must keep the old URLs, all based on https://download.gravitee.io/ , no cut off
* S3 bucket based (clever cloud)
* I will add a nicer browsing web interface :
  * quick one stealed from [the clever cloud tutorial](https://www.clever-cloud.com/blog/features/2020/10/08/s3-directory-listing/) :  https://github.com/qoomon/aws-s3-bucket-browser
  * maybe later for eye pleasure, thngs like hugo theme to browse at least main pages and to start with for the home landing page (explaining what's there, the policy about not keeping files older than ...e tc...)



## The Gravitee.io Products Impacted

### Gravitee APIM

The `Dockerfile`s defined for the 4 Gravitee APIM components are :
* versioned in the https://github.com/gravitee-io/gravitee-docker repo,and in that repo :
  * Gravitee APIM Management API Dockerfiles are :
    * release image: `./images/management-api/Dockerfile`
    * nightly image: `./images/management-api/Dockerfile-nightly`
  * Gravitee APIM Management UI :
    * release image: `./images/management-api/Dockerfile`
    * nightly image: `./images/management-api/Dockerfile-nightly`
  * Gravitee APIM Portal UI :
    * release image: `./images/portal-ui/Dockerfile` (does not exist yet)
    * nightly image: `./images/portal-ui/Dockerfile-nightly`
  * Gravitee APIM Gateway :
    * release image: `./images/gateway/Dockerfile`
    * nightly image: `./images/gateway/Dockerfile-nightly`

Now, for each of those container image definition, I synthetized the _"download servers"_ usage in the table below, making clear that :
* The https://dist.gravitee.io server is used to build nightly images, and for all of them, the content distributed at https://dist.gravitee.io/master/dist is used. Also note that in the Legacy CI CD System the https://dist.gravitee.io/ is only used for the `Gravitee APIM` Gravitee.io Product, cf. [The annex about the nightly distribution service](#annex--a-cadidate-next-target-design)
* and https://download.gravitee.io/ is used to build release images.

Those two servers are therefore, two components of the infrastructure of the global Gravitee CICD System.

{{< tables/1/table id="sample" class="bordered" data-sample=10 >}}

| Gravitee APIM component      | nightly or release | Download(s) server(s) used          | Check this in the git repo 's master branch          |
|------------------------------|--------------------|-------------------------------------|------------------------------------------------------|
| Gravitee APIM Management API | release            | https://download.gravitee.io/       | [`./images/management-api/Dockerfile` line 21](https://github.com/gravitee-io/gravitee-docker/blob/2ba64162af7717ccbcb79025e221e997846a34ae/images/management-api/Dockerfile#L21) |
| Gravitee APIM Management API | nightly            | https://dist.gravitee.io/           | [`./images/management-api/Dockerfile-nightly` line 21](https://github.com/gravitee-io/gravitee-docker/blob/2ba64162af7717ccbcb79025e221e997846a34ae/images/management-api/Dockerfile-nightly#L21) |
| Gravitee APIM Management UI  | release            | https://download.gravitee.io/       | [`./images/management-ui/Dockerfile` ligne 26](https://github.com/gravitee-io/gravitee-docker/blob/2ba64162af7717ccbcb79025e221e997846a34ae/images/management-ui/Dockerfile#L26)  |
| Gravitee APIM Management UI  | nightly            | https://dist.gravitee.io/           | [`./images/management-ui/Dockerfile-nightly` ligne 27](https://github.com/gravitee-io/gravitee-docker/blob/2ba64162af7717ccbcb79025e221e997846a34ae/images/management-ui/Dockerfile-nightly#L27) |
| Gravitee APIM Portal UI      | release            | _(image does not exist yet)_        | _(image does not exist yet)_ |
| Gravitee APIM Portal UI      | nightly            | https://dist.gravitee.io/           | [`images/portal-ui/Dockerfile-nightly` ligne 27](https://github.com/gravitee-io/gravitee-docker/blob/2ba64162af7717ccbcb79025e221e997846a34ae/images/portal-ui/Dockerfile-nightly#L27) |
| Gravitee APIM Gateway        | release            | https://download.gravitee.io/       | [`./images/gateway/Dockerfile` line 21](https://github.com/gravitee-io/gravitee-docker/blob/2ba64162af7717ccbcb79025e221e997846a34ae/images/gateway/Dockerfile#L21) |
| Gravitee APIM Gateway        | nightly            | https://dist.gravitee.io/           | [`./images/gateway/Dockerfile-nightly` line 21](https://github.com/gravitee-io/gravitee-docker/blob/2ba64162af7717ccbcb79025e221e997846a34ae/images/gateway/Dockerfile-nightly#L21) |

{{</ tables/1/table >}}


### Gravitee Cockpit (work in progress)

The `Dockerfile`s defined for the 2 Gravitee Cockpit components are :
* versioned in the https://github.com/gravitee-io/gravitee-cockpit repo, and in that repo :
  * Gravitee Cockpit Management API Dockerfiles are :
    * release image: `./docker/management-api/Dockerfile`
    * nightly image: `./docker/management-api/Dockerfile-dev`
  * Gravitee Cockpit Management UI :
    * release image: `./docker/webui/Dockerfile`
    * nightly image: `./docker/webui/Dockerfile-dev`


Now, for each of those container image definition, I synthetized the _"download servers"_ usage in the table below, making clear that :
* https://dist.gravitee.io/ is not used, like for Gravitee API, to build nightly images : In the stead, the files generated by the repo build process, are locally used in pipelines execution, by the Docker build process. Also note that in the Legacy CI CD System the https://dist.gravitee.io/ is only used for the `Gravitee APIM` Gravitee.io Product, cf. [The annex about the nightly distribution service](#annex--a-cadidate-next-target-design)
* and that https://download.gravitee.io/ is planned to be used to build release images of Gravitee Cockpit, when its release process will fully be implemented, similarly to Gravitee APIM.


{{< tables/1/table id="sample" class="bordered" data-sample=10 >}}

| Gravitee Cockpit component      | nightly or release | Download(s) server(s) used          | Check this in the git repo 's master branch          |
|---------------------------------|--------------------|-------------------------------------|------------------------------------------------------|
| Gravitee Cockpit Management API | nightly            | no download server used             | [`./docker/management-api/Dockerfile-dev`](https://github.com/gravitee-io/gravitee-cockpit/blob/master/docker/management-api/Dockerfile-dev) . Note that all files needed in the Docker build context are _"prepared"_ by [the `Makefile`](https://github.com/gravitee-io/gravitee-cockpit/blob/e6324d5eb5f8055708b380ce4de4c6c669c0b6bc/Makefile#L8) used [in the `deliver_nightly_cockpit` Gravitee Circle CI Orb Job](https://github.com/gravitee-io/gravitee-circleci-orbinoid/blob/develop/orb/src/jobs/deliver_nightly_cockpit.yml#L75) to build the nightly Cockpit Management API |
| Gravitee Cockpit Management API | release            | https://download.gravitee.io/       | [`./docker/management-api/Dockerfile`](https://github.com/gravitee-io/gravitee-cockpit/blob/e6324d5eb5f8055708b380ce4de4c6c669c0b6bc/docker/management-api/Dockerfile#L9) . Note that the release process of `Gravitee Cockpit` has not yet been automatized, so this `Dockerfile` is not used in any implemented CICD Process yet |
| Gravitee Cockpit Web UI         | nightly            | no download server used             | [`./docker/webui/Dockerfile-dev`](https://github.com/gravitee-io/gravitee-cockpit/blob/master/docker/webui/Dockerfile-dev) . Note that all files needed in the Docker build context are _"prepared"_ by [the `Makefile`](https://github.com/gravitee-io/gravitee-cockpit/blob/e6324d5eb5f8055708b380ce4de4c6c669c0b6bc/Makefile#L20) used [in the `deliver_nightly_cockpit` Gravitee Circle CI Orb Job](https://github.com/gravitee-io/gravitee-circleci-orbinoid/blob/develop/orb/src/jobs/deliver_nightly_cockpit.yml#L75) to build the nightly Cockpit Web UI |
| Gravitee Cockpit Web UI         | release            | https://download.gravitee.io/       | [`./docker/webui/Dockerfile`](https://github.com/gravitee-io/gravitee-cockpit/blob/e6324d5eb5f8055708b380ce4de4c6c669c0b6bc/docker/webui/Dockerfile#L29) . Note that the release process of `Gravitee Cockpit` has not yet been automatized, so this `Dockerfile` is not used in any implemented CICD Process yet |

<!--
-->
{{</ tables/1/table >}}




### Gravitee AM (coming soon)


{{< tables/1/table id="sample" class="bordered" data-sample=10 >}}

| Gravitee AM component        | nightly or release | Download(s) server(s) used          | Check this in the git repo 's master branch          |
|------------------------------|--------------------|-------------------------------------|------------------------------------------------------|
<!--
| Gravitee AM Management API | nightly            | https://dist.gravitee.io/           | [`./images/management-api/Dockerfile-nightly` line 21](https://github.com/gravitee-io/gravitee-docker/blob/2ba64162af7717ccbcb79025e221e997846a34ae/images/management-api/Dockerfile-nightly#L21) |
| Gravitee AM Management UI  | release            | https://download.gravitee.io/       | [`./images/management-ui/Dockerfile` ligne 26](https://github.com/gravitee-io/gravitee-docker/blob/2ba64162af7717ccbcb79025e221e997846a34ae/images/management-ui/Dockerfile#L26)  |
-->
{{</ tables/1/table >}}


### Gravitee AE (coming soon)

{{< tables/1/table id="sample" class="bordered" data-sample=10 >}}

| Gravitee AE component        | nightly or release | Download(s) server(s) used          | Check this in the git repo 's master branch          |
|------------------------------|--------------------|-------------------------------------|------------------------------------------------------|
<!--
| Gravitee AM Management API | nightly            | https://dist.gravitee.io/           | [`./images/management-api/Dockerfile-nightly` line 21](https://github.com/gravitee-io/gravitee-docker/blob/2ba64162af7717ccbcb79025e221e997846a34ae/images/management-api/Dockerfile-nightly#L21) |
| Gravitee AM Management UI  | release            | https://download.gravitee.io/       | [`./images/management-ui/Dockerfile` ligne 26](https://github.com/gravitee-io/gravitee-docker/blob/2ba64162af7717ccbcb79025e221e997846a34ae/images/management-ui/Dockerfile#L26)  |
-->
{{</ tables/1/table >}}


### A First Quick recipe : setting up a first S3-based "Download" server with Clever Cloud


#### Step 1 : Create a Cellar Addon

A first issue you may experience, that I exeprienced, is that my user on the clervercloud portal does not have the permissions to create an add on (here I need to create a _"Scellar"_ `add-on`) :

{{< image alt=" permissions to create an add on" width="100%" height="100%" src="/images/figures/concepts-n-design/cicd-infra/jb-needs-permission-to-create-scellar-add-on.png" >}}

__Solved__

The Scellar add-on was already created, the Clever Cloud Web UI URL to the Scellar S3 bucket is : https://console.clever-cloud.com/organisations/orga_ba284152-8da9-4e8f-b32f-21d86100cac1/addons/addon_af75d939-a744-4f33-b598-886a692165f9

Ok, the downloaded credentials file (validfor `s3cmd`), is :

```bash
~/someops/yaml2json$ curl https://cellar-addon-clevercloud-customers.services.clever-cloud.com/s3cfg?token=2-FwSzFnV9dVzVHQqu06%2BZfIq8dWCFHR%2F4%2BbONqqRH5hDS%2FFFMBPpcLSGuMl%2FHF9j0lQj7DcR7%2FJY5zSE4Di7Ldewv069N0wlkrIZo0B38%2B894sNyc%2B0o4ALRq1rsLknEdDsAjof%2BJs7bS9KhqMPEqgw%3D%3D

access_key = RF1SG1FHT83PQVBBED17
secret_key = rxQITmnP9hX5srKpRfNkoFqF2QAgMDUnQUqHyz5c
bucket_location = US
cloudfront_host = cloudfront.amazonaws.com
cloudfront_resource = /2010-07-15/distribution
default_mime_type = binary/octet-stream
delete_removed = False
dry_run = False
encoding = UTF-8
encrypt = False
follow_symlinks = False
force = False
get_continue = False
gpg_command = /usr/bin/gpg
gpg_decrypt = %(gpg_command)s -d --verbose --no-use-agent --batch --yes --passphrase-fd %(passphrase_fd)s -o %(output_file)s %(input_file)s
gpg_encrypt = %(gpg_command)s -c --verbose --no-use-agent --batch --yes --passphrase-fd %(passphrase_fd)s -o %(output_file)s %(input_file)s
gpg_passphrase =
guess_mime_type = True
host_base = cellar-c2.services.clever-cloud.com
host_bucket = %(bucket)s.cellar-c2.services.clever-cloud.com
human_readable_sizes = False
list_md5 = False
log_target_prefix =
preserve_attrs = True
progress_meter = True
proxy_host =
proxy_port = 0
recursive = False
recv_chunk = 4096
reduced_redundancy = False
send_chunk = 4096
simpledb_host = sdb.amazonaws.com
skip_existing = False
socket_timeout = 300
urlencoding_mode = normal
use_https = False
verbosity = WARNING

~/$


```

#### Step 2: create a bucket, make it public, and store some files

* To create a bucket, I will need to use a command line tool, the two proposed by [the clever cloud team tutorial](https://www.clever-cloud.com/blog/features/2020/10/08/s3-directory-listing/) :
  * I will use tha ttool in a docker container
  * I compared `rclone` and `s3cmd`, and chose `rclone` over `s3cmd` : see below the full details in [the annex dedicatedto the subject](#annex--docker-images-and-comparison-of-rclone-and-s3cmd)
* Now I need to configure `rclone`, to be able to run the command which will create the _"Scellar"_ S3 bucket :
  * The CleverCloud Web UI provides a download link to download an `s3cmd`-ready configuration file, `s3cmd`:
    * If I used `s3cmd`, I would map the downloaded file to the `~/.s3cfg` path inside the docker container
    * So the question is : How do I convert this `s3cmd`-ready configuration file, downloaded from Clever CLoud, into a valid `rclone` configuration file ?
    * Using he `rclone config` command,I could manage to generate a config file, which ahs he following format/content , for an "Amazon Drive Cloud" remote type :

```bash
jbl@pc-alienware-jbl:~/tests.s3cmd$ docker exec -it devops-bubble bash -c "cat /root/.config/rclone/rclone.conf"
[clevercloudscellar]
type = amazon cloud drive
client_id = clientid
client_secret = clientecret
token = wdfgwdgfwd
auth_url = wdfgwdfg
token_url = https://clevercloud.com/oauth

jbl@pc-alienware-jbl:~/tests.s3cmd$

```


* Here are the typical `rclone` commands I will have to execute :

```bash
# [rclone config] will be interactive, and
rclone config
# Then I will be able to perform the following comands on my remote S3 bucket :
rclone ls remote:path # lists files in the "path" path of the remote
rclone copy /local/path remote:path # copies /local/path to the remote,  in the "path" path of the remote
rclone sync -i /local/path remote:path # syncs /local/path to the remote in the "path" path of the remote
```

So in my contianer, I will use 2 volumes :
* `-v ./.my.rclone.config.file:/root/.config/rclone/rclone.conf` : to map the `/root/.config/rclone/rclone.conf` configuration file to be used by `rclone` in the container
* `-v ./local/files/to/s3/:/gio/devops/s3bucket` : to map the local folder to sync to the remote S3 Bucket

```bash
cat <<EOF >install-rclone.sh
#!/bin/bash
# https://rclone.org/install/#linux-installation-from-precompiled-binary
# script to execute as ROOT user
export RCLONE_OPS_HOME=\$(mktemp -d -t "rclone_install_ops-XXXXXXXXXX")
export RCLONE_VERSION=\${RCLONE_VERSION:-'1.53.4'}
export RCLONE_OS=osx
export RCLONE_OS=plan9
export RCLONE_OS=openbsd
export RCLONE_OS=freebsd
export RCLONE_OS=netbsd
export RCLONE_OS=linux
export RCLONE_CPU_ARCH=arm-v7
export RCLONE_CPU_ARCH=amd64

curl -LO "https://github.com/rclone/rclone/releases/download/v\${RCLONE_VERSION}/rclone-v\${RCLONE_VERSION}-\${RCLONE_OS}-\${RCLONE_CPU_ARCH}.zip"
# verify binary
curl -LO "https://github.com/rclone/rclone/releases/download/v\${RCLONE_VERSION}/SHA256SUMS"
cat ./SHA256SUMS | grep "rclone-v\${RCLONE_VERSION}-\${RCLONE_OS}-\${RCLONE_CPU_ARCH}.zip" | sha256sum --check --status
# install it

unzip ./rclone-v\${RCLONE_VERSION}-\${RCLONE_OS}-\${RCLONE_CPU_ARCH}.zip -d \${RCLONE_OPS_HOME}
export WHEREIAM=\$(pwd)
echo "\\\${RCLONE_OPS_HOME}=\${RCLONE_OPS_HOME}"
echo "\\\${RCLONE_OPS_HOME}/rclone-v\\\${RCLONE_VERSION}-\\\${RCLONE_OS}-\\\${RCLONE_CPU_ARCH}=\${RCLONE_OPS_HOME}/rclone-v\${RCLONE_VERSION}-\${RCLONE_OS}-\${RCLONE_CPU_ARCH}"
ls -allh \${RCLONE_OPS_HOME}/rclone-v\${RCLONE_VERSION}-\${RCLONE_OS}-\${RCLONE_CPU_ARCH}

cd \${RCLONE_OPS_HOME}/rclone-v\${RCLONE_VERSION}-\${RCLONE_OS}-\${RCLONE_CPU_ARCH}
cp rclone /usr/bin/
chown root:root /usr/bin/rclone
chmod 755 /usr/bin/rclone
cd \${WHEREIAM}
rm -fr \${RCLONE_OPS_HOME}
unset RCLONE_VERSION
rclone --version
EOF


cat <<EOF >Dockerfile
FROM debian:stable-slim

RUN ls -allh
RUN apt-get update -y && apt-get install -y bash curl wget jq unzip
RUN mkdir -p /root/.config/rclone/
RUN mkdir -p /gio/devops/s3bucket

VOLUME /root/.config/rclone/rclone.conf
VOLUME /gio/devops/s3bucket

WORKDIR /gio/devops
COPY install-rclone.sh /gio/devops
RUN chmod +x ./install-rclone.sh && ./install-rclone.sh
# ENTRYPOINT [ "/gio/devops/install-rclone.sh" ]
CMD [ "/bin/bash" ]
EOF

docker build -t graviteeio/rclone:clever-cloud-0.0.1 .
docker run -itd --name devops-bubble -v ./.my.rclone.config.file:/root/.config/rclone/rclone.conf -v ./local/files/to/s3/:/gio/devops/s3bucket graviteeio/rclone:clever-cloud-0.0.1 bash
docker exec -it devops-bubble bash -c "rclone --version"
docker exec -it devops-bubble bash -c "rclone config show"
docker exec -it devops-bubble bash -c "rclone config file"
# --- Assume the content ofthe [~/.config/rclone/rclone.conf] rclone config file is :
# [clevercloudscellar]
# type = amazon cloud drive
# client_id = clientid
# client_secret = clientecret
# token = wdfgwdgfwd
# auth_url = wdfgwdfg
# token_url = https://clevercloud.com/oauth
# --
# Then, the remote name is [clevercloudscellar] , and I can browse into it like this :
export RCLONE_REMOTE_NAME=clevercloudscellar
docker exec -it devops-bubble bash -c "rclone ls ${RCLONE_REMOTE_NAME}:/"
# Then, the remote name is [clevercloudscellar] , and I can
# copy /gio/devops/s3bucket folder content in container, in the "/" path of the "clevercloudscellar" remote,  like this :
export RCLONE_REMOTE_NAME=clevercloudscellar
docker exec -it devops-bubble bash -c "rclone copy /gio/devops/s3bucket ${RCLONE_REMOTE_NAME}:/"
# Then, the remote name is [clevercloudscellar] , and I can
# sync /gio/devops/s3bucket folder content in container, in the "/" path of the "clevercloudscellar" remote,  like this :
export RCLONE_REMOTE_NAME=clevercloudscellar
docker exec -it devops-bubble bash -c "rclone sync -i /gio/devops/s3bucket ${RCLONE_REMOTE_NAME}:/"

```


## ANNEX : Docker images, and comparison of `rclone` and `s3cmd`

__The `rclone` Docker image__


Docker image for `Rclone` :

```Dockerfile
FROM debian:stable-slim

RUN ls -allh
# [python-pip] package necessary for s3cmd installation
# [python3-pip] package necessary for s3cmd installation  ?
# RUN apt-get update -y && apt-get install -y curl wget python3-pip jq
RUN apt-get update -y && apt-get install -y bash curl wget jq unzip

# install kubectl latest stable
# https://kubernetes.io/docs/tasks/tools/install-kubectl/
# doxnload binary
RUN mkdir -p /gio/devops
WORKDIR /gio/devops
COPY install-rclone.sh /gio/devops
RUN chmod +x ./install-rclone.sh && ./install-rclone.sh
# ENTRYPOINT [ "/gio/devops/install-rclone.sh" ]
CMD [ "/bin/bash" ]
```

I preferred `rclone` over `s3cmd` :
* for `s3cmd`, I do not have any checksum file tocheck integrity of distribution downloads, and the GPG public Key to verify the signature is not available, see below the work done on building a container for `s3cmd`, and https://github.com/s3tools/s3cmd/issues/1173
* At least, `rclone` project has checksums instead of GPG signatures, on the https://github.com/rclone/rclone/releases page, so that downloads integrity can be checked, and we can build a secured Docker image. So I'll build an image for Gravitee CICD Container library, based on `rclone` instead of `s3cmd`.


```bash
cat <<EOF >install-rclone.sh
#!/bin/bash
# https://rclone.org/install/#linux-installation-from-precompiled-binary
# script to execute as ROOT user
export RCLONE_OPS_HOME=\$(mktemp -d -t "rclone_install_ops-XXXXXXXXXX")
export RCLONE_VERSION=\${RCLONE_VERSION:-'1.53.4'}
export RCLONE_OS=osx
export RCLONE_OS=plan9
export RCLONE_OS=openbsd
export RCLONE_OS=freebsd
export RCLONE_OS=netbsd
export RCLONE_OS=linux
export RCLONE_CPU_ARCH=arm-v7
export RCLONE_CPU_ARCH=amd64

curl -LO "https://github.com/rclone/rclone/releases/download/v\${RCLONE_VERSION}/rclone-v\${RCLONE_VERSION}-\${RCLONE_OS}-\${RCLONE_CPU_ARCH}.zip"
# verify binary
curl -LO "https://github.com/rclone/rclone/releases/download/v\${RCLONE_VERSION}/SHA256SUMS"
cat ./SHA256SUMS | grep "rclone-v\${RCLONE_VERSION}-\${RCLONE_OS}-\${RCLONE_CPU_ARCH}.zip" | sha256sum --check --status
# install it

unzip ./rclone-v\${RCLONE_VERSION}-\${RCLONE_OS}-\${RCLONE_CPU_ARCH}.zip -d \${RCLONE_OPS_HOME}
export WHEREIAM=\$(pwd)
echo "\\\${RCLONE_OPS_HOME}=\${RCLONE_OPS_HOME}"
echo "\\\${RCLONE_OPS_HOME}/rclone-v\\\${RCLONE_VERSION}-\\\${RCLONE_OS}-\\\${RCLONE_CPU_ARCH}=\${RCLONE_OPS_HOME}/rclone-v\${RCLONE_VERSION}-\${RCLONE_OS}-\${RCLONE_CPU_ARCH}"
ls -allh \${RCLONE_OPS_HOME}/rclone-v\${RCLONE_VERSION}-\${RCLONE_OS}-\${RCLONE_CPU_ARCH}

cd \${RCLONE_OPS_HOME}/rclone-v\${RCLONE_VERSION}-\${RCLONE_OS}-\${RCLONE_CPU_ARCH}
cp rclone /usr/bin/
chown root:root /usr/bin/rclone
chmod 755 /usr/bin/rclone
cd \${WHEREIAM}
rm -fr \${RCLONE_OPS_HOME}
unset RCLONE_VERSION
rclone --version
EOF


cat <<EOF >Dockerfile
FROM debian:stable-slim

RUN ls -allh
RUN apt-get update -y && apt-get install -y bash curl wget jq unzip
RUN mkdir -p /gio/devops
WORKDIR /gio/devops
COPY install-rclone.sh /gio/devops
RUN chmod +x ./install-rclone.sh && ./install-rclone.sh
# ENTRYPOINT [ "/gio/devops/install-rclone.sh" ]
CMD [ "/bin/bash" ]
EOF
docker build -t graviteeio/rclone:clever-cloud-0.0.1 .
docker run -itd --name devops-bubble graviteeio/rclone:clever-cloud-0.0.1 bash
docker exec -it devops-bubble bash -c "rclone --version"
# so ok, ready to work with s3cmd now

```

* Right, usage documentation of `Rclone` : https://rclone.org/docs/


__The `s3cmd` Docker image__

Here is the docker image I designed for `s3cmd`, in order to evalutate its installation procedure and its usage :

```bash
cat <<EOF >install-s3cmd.sh
#!/bin/bash
export INSTALL_OPS_HOME=\$(mktemp -d -t "s3cmd_install_ops-XXXXXXXXXX")
export S3CMD_VERSION=\${S3CMD_VERSION:-'2.1.0'}
curl -LO https://github.com/s3tools/s3cmd/releases/download/v\${S3CMD_VERSION}/s3cmd-\${S3CMD_VERSION}.zip
curl -LO https://github.com/s3tools/s3cmd/releases/download/v\${S3CMD_VERSION}/s3cmd-\${S3CMD_VERSION}.zip.asc
# okay this is a GPG based signature check
# Si need GPG installed, a GPG keyring context
gpg --keyid-format long --list-options show-keyring s3cmd-${S3CMD_VERSION}.zip.asc
# I will need the GPG Public Key of the project, whichI could not find anywhere yet, so
# I opened an issue to ask for it : https://github.com/s3tools/s3cmd/issues/1173

# https://serverfault.com/questions/896228/how-to-verify-a-file-using-an-asc-signature-file

# once verifications finished

unzip ./s3cmd-\${S3CMD_VERSION}.zip -d \${INSTALL_OPS_HOME}
export WHERE_IAM=\$(pwd)
cd \${INSTALL_OPS_HOME}/s3cmd-2.1.0
python setup.py install
cd \${WHERE_IAM}
rm -fr \${INSTALL_OPS_HOME}
s3cmd --version
EOF

cat <<EOF >install-s3cmd.sh
#!/bin/bash
export INSTALL_OPS_HOME=\$(mktemp -d -t "s3cmd_install_ops-XXXXXXXXXX")
export S3CMD_VERSION=\${S3CMD_VERSION:-'2.1.0'}
curl -LO https://github.com/s3tools/s3cmd/releases/download/v\${S3CMD_VERSION}/s3cmd-\${S3CMD_VERSION}.zip
curl -LO https://github.com/s3tools/s3cmd/releases/download/v\${S3CMD_VERSION}/s3cmd-\${S3CMD_VERSION}.zip.asc
# okay this is a GPG based signature check
# Si need GPG installed, a GPG keyring context
gpg --keyid-format long --list-options show-keyring s3cmd-${S3CMD_VERSION}.zip.asc
# I will need the GPG Public Key of the project, whichI could not find anywhere yet, so
# I opened an issue to ask for it : https://github.com/s3tools/s3cmd/issues/1173

# https://serverfault.com/questions/896228/how-to-verify-a-file-using-an-asc-signature-file

# once verifications finished

unzip ./s3cmd-\${S3CMD_VERSION}.zip -d \${INSTALL_OPS_HOME}
export WHERE_IAM=\$(pwd)
cd \${INSTALL_OPS_HOME}/s3cmd-2.1.0
python setup.py install
cd \${WHERE_IAM}
rm -fr \${INSTALL_OPS_HOME}
s3cmd --version
EOF
cat <<EOF >Dockerfile
FROM debian:stable-slim

RUN ls -allh
# [python-pip] package necessary for s3cmd installation
# [python3-pip] package necessary for s3cmd installation  ?
# RUN apt-get update -y && apt-get install -y curl wget python3-pip jq
RUN apt-get update -y && apt-get install -y bash curl wget python-pip python-setuptools jq unzip

# install kubectl latest stable
# https://kubernetes.io/docs/tasks/tools/install-kubectl/
# doxnload binary
RUN mkdir -p /gio/devops
WORKDIR /gio/devops
COPY install-s3cmd.sh /gio/devops
RUN chmod +x ./install-s3cmd.sh && ./install-s3cmd.sh
# ENTRYPOINT [ "/gio/devops/install-s3cmd.sh" ]
CMD [ "/bin/bash" ]
EOF
docker build -t graviteeio/s3cmd:clever-cloud-0.0.1 .
docker run -itd --name devops-bubble graviteeio/s3cmd:clever-cloud-0.0.1 bash
docker exec -it devops-bubble bash -c "s3cmd --version"
# so ok, ready to work with s3cmd now

```

## ANNEX : A candidate Next Target Design

Note finally that The https://dist.gravitee.io/ service :
* only cares about on Gravitee Product `Gravitee APIM`.
* Well, we probably would want to generalize the https://dist.gravitee.io/ service to be responsible of serving distrib files, of Nightly Releases, for all Gravitee Products, not just `Gravitee APIM`.
* Indeed, we can easily conceive :
  * a "Nightly Release" concept for any Gravitee.io Product
  * and therefore a "Deliver Nightly Release" CI CD Process, just like we have begun doing so for Gravitee Cockpit, see [Gravitee Cockpit (work in progress)](#gravitee-cockpit-work-in-progress)


## ANNEX : Misc Resources

* A tutorial from Clever Cloud : https://www.clever-cloud.com/blog/features/2020/10/08/s3-directory-listing/
* Rclone https://rclone.org/install/
* advised palylist while working :
  * ["Creedence Revival Clearwater Greatest Hits (Full Album) Best Songs (HQ)"](https://www.youtube.com/watch?v=05JgKtm9ZKU)
