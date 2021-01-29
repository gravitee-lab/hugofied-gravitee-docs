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

#### Step 2: create and setup the S3 bucket



* With the above shell script, I initialized the file secret in secrethub, for the `s3cmd` configuration file distributed by the cleverCloud Web UI.
* In the below script, Replace the value of the `CLEVER_CLOUD_DOWNLOAD_LINK_URI` env. var., with the value you have copied from Clever Cloud Portal Web UI

```bash
export SECRETHUB_ORG=graviteeio
export SECRETHUB_ORG=gravitee-lab
export SECRETHUB_REPO=cicd

secrethub mkdir --parents "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/infra/zip-bundle-server/clever-cloud-s3/s3cmd/"

# Replace the value of CLEVER_CLOUD_DOWNLOAD_LINK_URI with the value you have copied from Clever Cloud Portal Web UI
export CLEVER_CLOUD_DOWNLOAD_LINK_URI="https://cellar-addon-clevercloud-customers.services.clever-cloud.com/s3cfg?token=2-FwSzFnV9dVzVHQqu06%2BZfIq8dWCFHR%2F4%2BbONqqRH5hDS%2FFFMBPpcLSGuMl%2FHF9j0lQj7DcR7%2FJY5zSE4Di7Ldewv069N0wlkrIZo0B38%2B894sNyc%2B0o4ALRq1rsLknEdDsAjof%2BJs7bS9KhqMPEqgw%3D%3D"
mkdir -p ./.s3cmd
touch ./.s3cmd/config
curl -o ./.s3cmd/config ${CLEVER_CLOUD_DOWNLOAD_LINK_URI}

# storing in the secret manager, the s3cmd configuration file, which includes the credentials, so is a secret file.
secrethub write --in-file ./.s3cmd/config "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/infra/zip-bundle-server/clever-cloud-s3/s3cmd/config"

rm -fr ./.s3cmd

export SECRETHUB_ORG=graviteeio
export SECRETHUB_ORG=gravitee-lab
export SECRETHUB_REPO=cicd

secrethub read --out-file ./.s3cmd.config.test "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/infra/zip-bundle-server/clever-cloud-s3/s3cmd/config"
cat ./.s3cmd.config.test
rm ./.s3cmd.config.test

```

 * With the below shell script, I initialized the S3 bucket, and set up a file browser into it :

```bash

export CICD_LIB_OCI_REPOSITORY_ORG=${CICD_LIB_OCI_REPOSITORY_ORG:-"quay.io/gravitee-lab"}
export CICD_LIB_OCI_REPOSITORY_NAME=${CICD_LIB_OCI_REPOSITORY_NAME:-"cicd-s3cmd"}
export S3CMD_CONTAINER_IMAGE_TAG=${S3CMD_CONTAINER_IMAGE_TAG:-"stable-latest"}
export S3CMD_DOCKER="${CICD_LIB_OCI_REPOSITORY_ORG}/${CICD_LIB_OCI_REPOSITORY_NAME}:${S3CMD_CONTAINER_IMAGE_TAG}"

docker pull "${S3CMD_DOCKER}"


# this is where I'll put all the files that I want to send (or sync) to the bucket
mkdir -p ./bucket-content
# The s3cmd configuration files, which includes the credentials
mkdir -p ./.s3cmd

export SECRETHUB_ORG=graviteeio
export SECRETHUB_ORG=gravitee-lab
export SECRETHUB_REPO=cicd

secrethub read --out-file ./.s3cmd/config "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/infra/zip-bundle-server/clever-cloud-s3/s3cmd/config"

# I need 2 volumes : one to map the s3cmd config file, one for the bucket
docker run -itd --name devops-bubble -v $PWD/.s3cmd/config:/root/.s3cfg -v $PWD/bucket-content:/gio/devops/bucket "${S3CMD_DOCKER}" bash
docker exec -it devops-bubble bash -c "s3cmd --version"
docker exec -it devops-bubble bash -c "ls -allh . && ls -allh /root/.s3cmd && ls -allh /gio/devops/ && ls -allh /gio/devops/bucket "

# Ok, now we have everything we need inside container to run s3cmd commands

# create the s3 bucket
export S3_BUCKET_NAME="gravitee-releases-downloads"
docker exec -it devops-bubble bash -c "s3cmd mb s3://${S3_BUCKET_NAME}"
echo "------------------------------------------------------------------------------------------------------------"
echo "The bucket is now available at https://${S3_BUCKET_NAME}.cellar-c2.services.clever-cloud.com/"
echo "------------------------------------------------------------------------------------------------------------"
# to remove the same bucket :
# docker exec -it devops-bubble bash -c "s3cmd rb s3://${S3_BUCKET_NAME}"

# https://gravitee-releases-downloads.cellar-c2.services.clever-cloud.com/

# Now we change ACLs to make the bucket content publicly accessible
docker exec -it devops-bubble bash -c "s3cmd setacl --acl-public s3://${S3_BUCKET_NAME}/*"

# Now we will add the bucket HTML browser

git clone https://github.com/qoomon/aws-s3-bucket-browser ./bucket-content/
cd ./bucket-content/
git checkout v1.2.0
cd ../


docker exec -it devops-bubble bash -c "ls -allh /gio/devops/bucket"

docker exec -it devops-bubble bash -c "s3cmd put --acl-public /gio/devops/bucket/favicon.ico s3://${S3_BUCKET_NAME}/favicon.ico"
docker exec -it devops-bubble bash -c "s3cmd put --acl-public /gio/devops/bucket/index.html s3://${S3_BUCKET_NAME}/index.html"
docker exec -it devops-bubble bash -c "s3cmd put --acl-public /gio/devops/bucket/logo.png s3://${S3_BUCKET_NAME}/logo.png"

# Now we allow public access to root of the bucket
docker exec -it devops-bubble bash -c "s3cmd setacl --acl-public s3://${S3_BUCKET_NAME}"

echo "------------------------------------------------------------------------------------------------------------"
echo "The bucket browser is now available at https://${S3_BUCKET_NAME}.cellar-c2.services.clever-cloud.com/index.html"
echo "------------------------------------------------------------------------------------------------------------"

```


#### Step 3: Add files to the bucket

* adding files to the S3 bucket is easy using `s3cmd`,asdemonstrated below.
* Nevertheless, we have a problem with `s3cmd` : it doesnot preserve files attributes. And that's dirty. As it apperaed, neither does AWS CLI, or other tools. Therefore, we will have to find and use antoher tool, to perform adding / syncing files to the S3 bucket.

```bash

# ---
# This will be my future Circle CI Orb command shell script file
# ---
#
export CICD_LIB_OCI_REPOSITORY_ORG=${CICD_LIB_OCI_REPOSITORY_ORG:-"quay.io/gravitee-lab"}
export CICD_LIB_OCI_REPOSITORY_NAME=${CICD_LIB_OCI_REPOSITORY_NAME:-"cicd-s3cmd"}
export S3CMD_CONTAINER_IMAGE_TAG=${S3CMD_CONTAINER_IMAGE_TAG:-"stable-latest"}
export S3CMD_DOCKER="${CICD_LIB_OCI_REPOSITORY_ORG}/${CICD_LIB_OCI_REPOSITORY_NAME}:${S3CMD_CONTAINER_IMAGE_TAG}"

docker pull "${S3CMD_DOCKER}"

# This is where I'll put all the files that I want to send (or sync) to the bucket
mkdir -p ./bucket-content
# The s3cmd configuration files, which includes the credentials
export SECRETHUB_ORG=graviteeio
export SECRETHUB_ORG=gravitee-lab
export SECRETHUB_REPO=cicd

mkdir -p ./.s3cmd
secrethub read --out-file ./.s3cmd/config "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/infra/zip-bundle-server/clever-cloud-s3/s3cmd/config"

# I need 2 volumes : one to map the s3cmd config file, one for the bucket
docker run -itd --name devops-bubble -v $PWD/.s3cmd/config:/root/.s3cfg -v $PWD/bucket-content:/gio/devops/bucket "${S3CMD_DOCKER}" bash
docker exec -it devops-bubble bash -c "s3cmd --version"
docker exec -it devops-bubble bash -c "ls -allh . && ls -allh /root/.s3cmd && ls -allh /gio/devops/ && ls -allh /gio/devops/bucket "

# Ok, now we have everything we need inside container to run s3cmd commands

# create the s3 bucket
export S3_BUCKET_NAME=${S3_BUCKET_NAME:-"gravitee-releases-downloads"}
docker exec -it devops-bubble bash -c "s3cmd ls s3://${S3_BUCKET_NAME}"



# quick test

mkdir -p $PWD/bucket-content/repertoire1/repertoire2
mkdir -p $PWD/bucket-content/repertoire3/repertoire4
mkdir -p $PWD/bucket-content/repertoire5/repertoire6
touch $PWD/bucket-content/repertoire1/gravitee-example1-standalone-3.5.3-full.zip
touch $PWD/bucket-content/repertoire1/repertoire2/gravitee-example2-standalone-3.5.3-full.zip
touch $PWD/bucket-content/repertoire3/gravitee-example3-standalone-3.5.3-full.zip
touch $PWD/bucket-content/repertoire3/repertoire4/gravitee-example4-standalone-3.5.3-full.zip
touch $PWD/bucket-content/repertoire5/gravitee-example5-standalone-3.5.3-full.zip
touch $PWD/bucket-content/repertoire5/repertoire6/gravitee-example6-standalone-3.5.3-full.zip

curl -o $PWD/bucket-content/graviteeio-full-jdbc-3.4.1.zip -L https://download.gravitee.io/graviteeio-apim/distributions/graviteeio-full-jdbc-3.4.1.zip

cp -f $PWD/bucket-content/graviteeio-full-jdbc-3.4.1.zip $PWD/bucket-content/repertoire1/gravitee-example1-standalone-3.5.3-full.zip
cp -f $PWD/bucket-content/graviteeio-full-jdbc-3.4.1.zip $PWD/bucket-content/repertoire1/repertoire2/gravitee-example2-standalone-3.5.3-full.zip
cp -f $PWD/bucket-content/graviteeio-full-jdbc-3.4.1.zip $PWD/bucket-content/repertoire3/gravitee-example3-standalone-3.5.3-full.zip
cp -f $PWD/bucket-content/graviteeio-full-jdbc-3.4.1.zip $PWD/bucket-content/repertoire3/repertoire4/gravitee-example4-standalone-3.5.3-full.zip
cp -f $PWD/bucket-content/graviteeio-full-jdbc-3.4.1.zip $PWD/bucket-content/repertoire5/gravitee-example5-standalone-3.5.3-full.zip
cp -f $PWD/bucket-content/graviteeio-full-jdbc-3.4.1.zip $PWD/bucket-content/repertoire5/repertoire6/gravitee-example6-standalone-3.5.3-full.zip


docker exec -it devops-bubble bash -c "tree -alh /gio/devops/bucket/"
docker exec -it devops-bubble bash -c "s3cmd sync --acl-public /gio/devops/bucket/ s3://${S3_BUCKET_NAME}/"

# And now changing the files actual binary content locally, to sync it with remote
curl -o $PWD/bucket-content/graviteeio-full-3.1.2.zip -L https://download.gravitee.io/graviteeio-apim/distributions/graviteeio-full-3.1.2.zip

cp -f $PWD/bucket-content/graviteeio-full-3.1.2.zip $PWD/bucket-content/repertoire1/gravitee-example1-standalone-3.5.3-full.zip
cp -f $PWD/bucket-content/graviteeio-full-3.1.2.zip $PWD/bucket-content/repertoire1/repertoire2/gravitee-example2-standalone-3.5.3-full.zip
cp -f $PWD/bucket-content/graviteeio-full-3.1.2.zip $PWD/bucket-content/repertoire3/gravitee-example3-standalone-3.5.3-full.zip
cp -f $PWD/bucket-content/graviteeio-full-3.1.2.zip $PWD/bucket-content/repertoire3/repertoire4/gravitee-example4-standalone-3.5.3-full.zip
cp -f $PWD/bucket-content/graviteeio-full-3.1.2.zip $PWD/bucket-content/repertoire5/gravitee-example5-standalone-3.5.3-full.zip
cp -f $PWD/bucket-content/graviteeio-full-3.1.2.zip $PWD/bucket-content/repertoire5/repertoire6/gravitee-example6-standalone-3.5.3-full.zip


docker exec -it devops-bubble bash -c "tree -alh /gio/devops/bucket/"
docker exec -it devops-bubble bash -c "s3cmd sync --acl-public /gio/devops/bucket/ s3://${S3_BUCKET_NAME}/"


# Exemple pour faire une supression recusive d'un répertoire entier :
docker exec -it devops-bubble bash -c "s3cmd rm --recursive s3://${S3_BUCKET_NAME}/repertoire1/"
docker exec -it devops-bubble bash -c "s3cmd rm --recursive s3://${S3_BUCKET_NAME}/repertoire3/"
docker exec -it devops-bubble bash -c "s3cmd rm --recursive s3://${S3_BUCKET_NAME}/repertoire5/"
docker exec -it devops-bubble bash -c "s3cmd rm s3://${S3_BUCKET_NAME}/*.zip"



# ---
# --- --- ---
#  Here an experiment to simulate how maven project zip files
#  can be synced to the S3 bucket
# --- --- ---
# ---
# ---
# The idea: put the zip files in the [$PWD/bucket-content/] local folder, and
# the [$PWD/bucket-content/] is synced to the S3 bucket as is.
# so just consider the [$PWD/bucket-content/] as if it was the S3 butcket root.
# ---
# ---

# Ok, example for the [gravitee-management-rest-api] :

export ZIP_PATH_IN_REMOTE=${ZIP_PATH_IN_REMOTE:-"/graviteeio-ee/distributions/"}
export ZIP_PATH_IN_REMOTE=${ZIP_PATH_IN_REMOTE:-"/graviteeio-cockpit/distributions/"}
export ZIP_PATH_IN_REMOTE=${ZIP_PATH_IN_REMOTE:-"/graviteeio-ae/distributions/"}
export ZIP_PATH_IN_REMOTE=${ZIP_PATH_IN_REMOTE:-"/graviteeio-am/distributions/"}
export ZIP_PATH_IN_REMOTE=${ZIP_PATH_IN_REMOTE:-"/graviteeio-apim/distributions/"}

# /usr/src/giomaven_project/gravitee-rest-api-standalone/gravitee-rest-api-standalone-distribution/gravitee-rest-api-standalone-distribution-zip/target/gravitee-rest-api-standalone-3.5.3-SNAPSHOT.zip
# example https://gravitee-releases-downloads.cellar-c2.services.clever-cloud.com/graviteeio-cockpit/distributions/gravitee-cockpit-management-api-full-3.0.0.zip
mkdir -p $PWD/bucket-content/${ZIP_PATH_IN_REMOTE}

export LOCAL_FILE_PATH="./varying/complex/path/to/maven/project/target/gravitee-cockpit-management-api-standalone-distribution-zip-3.0.0-20210108.152536-1.zip"
export FILE_NAME=$(echo "${LOCAL_FILE_PATH}" | awk -F '/' '{print $NF}')
export ZIP_PATH_IN_REMOTE=/graviteeio-apim/distributions/
echo "s3cmd put --acl-public /gio/devops/bucket/${LOCAL_FILE_PATH} s3://${S3_BUCKET_NAME}/${ZIP_PATH_IN_REMOTE}/${FILE_NAME}"

docker exec -it devops-bubble bash -c "s3cmd put --acl-public /gio/devops/bucket/${LOCAL_FILE_PATH} s3://${S3_BUCKET_NAME}/${ZIP_PATH_IN_REMOTE}/${FILE_NAME}"
# how to delete from remote
docker exec -it devops-bubble bash -c "s3cmd rm s3://${S3_BUCKET_NAME}/${ZIP_PATH_IN_REMOTE}/${FILE_NAME}"

```

* About s3cmd and metadata : S3 supports custom metadata, but those are S3 object metadata, not files attributes. Never the less, those metadata could be used to persist metada about each object, see https://community.exoscale.com/documentation/storage/metadata/ :

```bash

# this is how to modify an already pused object's metadata
s3cmd modify --add-header x-amz-meta-foo:bar s3://<bucket>/<object>
# and this is how you viw those metadata :
s3cmd info s3://<bucket>/<object>/

```


* Okay, so now I'll try another tool : https://github.com/bloomreach/s4cmd , only what I do not like about it, is that it does not seem to evolve a lot.

```bash

```

* I tried a utility which preserves file attributes, but its a pue backup/restore tool, and does not push the local folder structure to remote. This tool could never the less be used to backup / restore the full content of the server, incrementally, at every content change operation    :

```bash

# ---
# This will be my future Circle CI Orb command shell script file
# ---
#
export CICD_LIB_OCI_REPOSITORY_ORG=${CICD_LIB_OCI_REPOSITORY_ORG:-"quay.io/gravitee-lab"}
export CICD_LIB_OCI_REPOSITORY_NAME=${CICD_LIB_OCI_REPOSITORY_NAME:-"cicd-restic"}
export RESTIC_CONTAINER_IMAGE_TAG=${RESTIC_CONTAINER_IMAGE_TAG:-"stable-latest"}
export RESTIC_DOCKER="${CICD_LIB_OCI_REPOSITORY_ORG}/${CICD_LIB_OCI_REPOSITORY_NAME}:${RESTIC_CONTAINER_IMAGE_TAG}"

docker pull "${RESTIC_DOCKER}"

mkdir -p ./.s3cmd

export SECRETHUB_ORG=graviteeio
export SECRETHUB_ORG=gravitee-lab
export SECRETHUB_REPO=cicd

secrethub read --out-file ./.s3cmd/config "${SECRETHUB_ORG}/${SECRETHUB_REPO}/graviteebot/infra/zip-bundle-server/clever-cloud-s3/s3cmd/config"

export AWS_ACCESS_KEY_ID=$(cat ./.s3cmd/config | grep 'access_key' | awk -F '=' '{print $2}' | awk '{print $1}')
export AWS_SECRET_ACCESS_KEY=$(cat ./.s3cmd/config | grep 'secret_key' | awk -F '=' '{print $2}' | awk '{print $1}')

mkdir -p ./.restic/
if [ -f ./.restic/config ]; then
  rm ./.restic/config
fi;
export S3_BUCKET_NAME="gravitee-releases-downloads"
export RESTIC_REPOSITORY=s3:https://cellar-c2.services.clever-cloud.com/${S3_BUCKET_NAME}
export RESTIC_PASSWORD="s0m33x@mp1eP@ssW0rd"
echo "export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" | tee -a ./.restic/config
echo "export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" | tee -a ./.restic/config
echo "export RESTIC_PASSWORD=${RESTIC_PASSWORD}" | tee -a ./.restic/config
echo "export RESTIC_REPOSITORY=${RESTIC_REPOSITORY}" | tee -a ./.restic/config


# I need 2 volumes : one to map the s3cmd config file, one for the bucket
docker run -itd --name devops-bubble -v $PWD/.restic/config:/root/.restic.cfg -v $PWD/bucket-content:/gio/devops/bucket "${RESTIC_DOCKER}" bash
docker exec -it devops-bubble bash -c "restic version"
docker exec -it devops-bubble bash -c "cat ~/.restic.cfg"

# this below is interactive, and I tested it works to initialaize the restic repository (the password must noteverbhe lost, or the restic backup is for ever lost):
docker exec -it devops-bubble bash -c "source ~/.restic.cfg && restic -r s3:https://cellar-c2.services.clever-cloud.com/${S3_BUCKET_NAME} init"
docker exec -it devops-bubble bash -c "source ~/.restic.cfg && restic snapshots -r s3:https://cellar-c2.services.clever-cloud.com/${S3_BUCKET_NAME}"

docker stop devops-bubble && docker rm devops-bubble

mkdir -p ./.restic/
if [ -f ./.restic/config ]; then
  rm ./.restic/config
fi;
export S3_BUCKET_NAME="gravitee-releases-downloads"
export RESTIC_REPOSITORY=s3:https://cellar-c2.services.clever-cloud.com/${S3_BUCKET_NAME}
export RESTIC_PASSWORD="s0m33x@mp1eP@ssW0rd"
echo "export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" | tee -a ./.restic/config
echo "export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" | tee -a ./.restic/config
echo "export RESTIC_PASSWORD=${RESTIC_PASSWORD}" | tee -a ./.restic/config
echo "export RESTIC_REPOSITORY=${RESTIC_REPOSITORY}" | tee -a ./.restic/config

docker run -itd --name devops-bubble -v $PWD/.restic/config:/root/.restic.cfg -v $PWD/bucket-content:/gio/devops/bucket "${RESTIC_DOCKER}" bash
docker exec -it devops-bubble bash -c "source ~/.restic.cfg && restic snapshots"





# quick test
docker stop devops-bubble && docker rm devops-bubble

mkdir -p $PWD/bucket-content/repertoire1/repertoire2
mkdir -p $PWD/bucket-content/repertoire3/repertoire4
mkdir -p $PWD/bucket-content/repertoire5/repertoire6
touch $PWD/bucket-content/repertoire1/gravitee-example1-standalone-3.5.3-full.zip
touch $PWD/bucket-content/repertoire1/repertoire2/gravitee-example2-standalone-3.5.3-full.zip
touch $PWD/bucket-content/repertoire3/gravitee-example3-standalone-3.5.3-full.zip
touch $PWD/bucket-content/repertoire3/repertoire4/gravitee-example4-standalone-3.5.3-full.zip
touch $PWD/bucket-content/repertoire5/gravitee-example5-standalone-3.5.3-full.zip
touch $PWD/bucket-content/repertoire5/repertoire6/gravitee-example6-standalone-3.5.3-full.zip

curl -o $PWD/bucket-content/graviteeio-full-jdbc-3.4.1.zip -L https://download.gravitee.io/graviteeio-apim/distributions/graviteeio-full-jdbc-3.4.1.zip

cp -f $PWD/bucket-content/graviteeio-full-jdbc-3.4.1.zip $PWD/bucket-content/repertoire1/gravitee-example1-standalone-3.5.3-full.zip
cp -f $PWD/bucket-content/graviteeio-full-jdbc-3.4.1.zip $PWD/bucket-content/repertoire1/repertoire2/gravitee-example2-standalone-3.5.3-full.zip
cp -f $PWD/bucket-content/graviteeio-full-jdbc-3.4.1.zip $PWD/bucket-content/repertoire3/gravitee-example3-standalone-3.5.3-full.zip
cp -f $PWD/bucket-content/graviteeio-full-jdbc-3.4.1.zip $PWD/bucket-content/repertoire3/repertoire4/gravitee-example4-standalone-3.5.3-full.zip
cp -f $PWD/bucket-content/graviteeio-full-jdbc-3.4.1.zip $PWD/bucket-content/repertoire5/gravitee-example5-standalone-3.5.3-full.zip
cp -f $PWD/bucket-content/graviteeio-full-jdbc-3.4.1.zip $PWD/bucket-content/repertoire5/repertoire6/gravitee-example6-standalone-3.5.3-full.zip

docker exec -it devops-bubble bash -c "tree /gio/devops/bucket/"

# create a fist backup
docker exec -it devops-bubble bash -c "source ~/.restic.cfg && restic backup /gio/devops/bucket/"
# list snapshots
docker exec -it devops-bubble bash -c "source ~/.restic.cfg && restic snapshots"
# list files in the latest backup
docker exec -it devops-bubble bash -c "source ~/.restic.cfg && restic ls -l latest"

# Ok, all of this worked great, Now only probelmthat I've got here :
# User in container, and the fact that I have tosudo to copy into volume etc...
# So I'll have to do it for the Circle CI User I believe, althoguh not necessary I
# can delete container and restart a fresh one at will, it is really fast...


# Oh, only problem here with restic : It DOES NOT AT ALL STORE THE FILES WITH SAME folder structure and everything !!! Of course it's a backup restore tool! ...

```

* About the `restic` password :

>
>
> Almost all data in a `restic` repository is encrypted with a master key.
> The master key is chosen randomly when the repository is initialized.
> The password entered at initialization time is used (together with the Key Derivation Function `scrypt`) to derive a key for that password.
> The master key is then encrypted for the key derived from the password, the encrypted master key (together with some other data needed for `scrypt`) is saved to a file in the `keys/` subdir in the repo.
>
> The construction is very similar to other solutions use (e.g. the `Linux Unified Key Setup` (`LUKS`) used for disk encryption on `Linux`).
>
> https://forum.restic.net/t/is-storing-key-in-the-backup-location-really-safe/2021/2
>
> https://github.com/restic/restic/blob/master/doc/design.rst#keys-encryption-and-mac
>

* Only problem here with restic : It DOES NOT AT ALL STORE THE FILES WITH SAME folder structure. Well ofcourse it really is just meant to backup restore...




### Migration operation from Git LFS to the S3 Bucket

* specs :
  * we want all files that are in https://download.gravitee.io
  * we want every file to keep its file attributes (chmod , owner gid uid, last modified datetime,etc...)

* Now, here is the recipe, and itmust be adapted so as to use a tool which meets specs requerements, such as `restic` (a backup tool) :

```bash
# ---
# MIGRATION FROM GIT LFS TO S3 BUTCKET :
# => requires at least 2 hours of operations
# => requires git
# => requires docker
# => requires git lfs git module
# => requires at least 150 GB of disk partition
# ---
# And now, migrating the full content of https://download.gravitee.io to the new bucket (very long, given the number of the files)

# ---
# First I need to locally install Git LFS Client
# ---

cat << EOF >./install-git-lfs-client.sh
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
EOF
chmod +x ./install-git-lfs-client.sh
sudo ./install-git-lfs-client.sh

docker stop devops-bubble && docker rm devops-bubble
rm -fr $PWD/bucket-content
mkdir $PWD/bucket-content


git clone git@github.com:gravitee-io/dist.gravitee.io.git $PWD/bucket-content
# git lfs pull will be very long, more than a 130 GB to pull...
# (with 48MB/sec I figured this is about 35 minutes loong to get 100 GB, so, ok let's say around 45 minutes)
#
cd $PWD/bucket-content && git lfs pull && git lfs checkout && cd ../

docker run -itd --name devops-bubble -v $PWD/.s3cmd/config:/root/.s3cfg -v $PWD/bucket-content:/gio/devops/bucket "${S3CMD_DOCKER}" bash
# And go for syncing the whole thing (very long, given the number of the files)

# After i had retireved allfiles with `git lfs pull && git lfs checkout`, then
# I am astonished to witness, that most of the disk usage is in the `./.git/` directory :
# And what if I did not sync the .git/ directory ?
# let's try that :

docker exec -it devops-bubble bash -c "s3cmd sync -v --acl-public /gio/devops/bucket/graviteeio-ae/ s3://${S3_BUCKET_NAME}/graviteeio-ae/"
docker exec -it devops-bubble bash -c "s3cmd sync -v --acl-public /gio/devops/bucket/graviteeio-am/ s3://${S3_BUCKET_NAME}/graviteeio-am/"
docker exec -it devops-bubble bash -c "s3cmd sync -v --acl-public /gio/devops/bucket/graviteeio-apim/ s3://${S3_BUCKET_NAME}/graviteeio-apim/"
docker exec -it devops-bubble bash -c "s3cmd sync -v --acl-public /gio/devops/bucket/graviteeio-ee/ s3://${S3_BUCKET_NAME}/graviteeio-ee/"
docker exec -it devops-bubble bash -c "s3cmd sync -v --acl-public /gio/devops/bucket/plugins/ s3://${S3_BUCKET_NAME}/plugins/"
docker exec -it devops-bubble bash -c "s3cmd sync -v --acl-public /gio/devops/bucket/community/ s3://${S3_BUCKET_NAME}/community/"

docker exec -it devops-bubble bash -c "s3cmd put --acl-public /gio/devops/bucket/cla.pdf s3://${S3_BUCKET_NAME}/cla.pdf"

# docker exec -it devops-bubble bash -c "s3cmd sync --acl-public /gio/devops/bucket/ s3://${S3_BUCKET_NAME}/"
# verbose s3cmd is better, when really a lot of files : at least you know if anything at all happens ... :)
# docker exec -it devops-bubble bash -c "s3cmd sync -v --acl-public /gio/devops/bucket/ s3://${S3_BUCKET_NAME}/"

```



* Neverthe less, to go quicker to aim, I will use `s3cmd`, to avoid the task of converting `s3cmd` config file to `rclone` config file :

```bash
# Create a bucket
export S3_BUCKET_NAME="gravitee-releases-downloads"
s3cmd mb s3://${S3_BUCKET_NAME}
echo "------------------------------------------------------------------------------------------------------------"
echo "The bucket is now available at https://${S3_BUCKET_NAME}.cellar-c2.services.clever-cloud.com/"
echo "------------------------------------------------------------------------------------------------------------"
# bucket file browser
git clone https://github.com/qoomon/aws-s3-bucket-browser/
s3cmd put --acl-public aws-s3-bucket-browser/favicon.ico s3://${S3_BUCKET_NAME}/favicon.ico
s3cmd put --acl-public aws-s3-bucket-browser/index.html s3://${S3_BUCKET_NAME}/index.html
s3cmd put --acl-public aws-s3-bucket-browser/logo.png s3://${S3_BUCKET_NAME}/logo.png

# Circle CI Orb Command will just push zip files like this :
# (by configuration param set the path of the target folder into the bucket)
# [ --acl-public] option makes the files publicly available
s3cmd put --acl-public image.jpg s3://${S3_BUCKET_NAME}
# ls into bucket
s3cmd ls s3://${S3_BUCKET_NAME}
# cors config based on xml, set allowed  origin to domain name set for CNAME : https://www.clever-cloud.com/doc/deploy/addon/cellar/#cors-configuration



```

* domain name config :  create a CNAME record on your domain pointing to cellar-c2.services.clever-cloud.com

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

touch ./.my.rclone.config.file
echo "resolve [./.my.rclone.config.file] config file from secret manager"
docker run -itd --name devops-bubble -v $PWD/.my.rclone.config.file:/root/.config/rclone/rclone.conf -v $PWD/local/files/to/s3/:/gio/devops/s3bucket graviteeio/rclone:clever-cloud-0.0.1 bash
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

cat <<EOF >./install-s3cmd.sh
#!/bin/bash
export INSTALL_OPS_HOME=\$(mktemp -d -t "s3cmd_install_ops-XXXXXXXXXX")
export S3CMD_VERSION=\${S3CMD_VERSION:-'2.1.0'}
curl -LO https://github.com/s3tools/s3cmd/releases/download/v\${S3CMD_VERSION}/s3cmd-\${S3CMD_VERSION}.zip
curl -LO https://github.com/s3tools/s3cmd/releases/download/v\${S3CMD_VERSION}/s3cmd-\${S3CMD_VERSION}.zip.asc
# okay this is a GPG based signature check
# Si need GPG installed, a GPG keyring context
# gpg --keyid-format long --list-options show-keyring s3cmd-${S3CMD_VERSION}.zip.asc
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
RUN mkdir -p /gio/devops/bucket
VOLUME /gio/devops/bucket
# /root/.s3cmd is a file
# VOLUME /root/.s3cmd
WORKDIR /gio/devops
COPY install-s3cmd.sh /gio/devops
RUN chmod +x ./install-s3cmd.sh && ./install-s3cmd.sh
# ENTRYPOINT [ "/gio/devops/install-s3cmd.sh" ]
CMD [ "/bin/bash" ]
EOF

docker build -t graviteeio/s3cmd:clever-cloud-0.0.1 .

# this is where I'll put all the files that I want to send (or sync) to the bucket
mkdir -p ./bucket-content
# The s3cmd configuration files, which includes the credentials
mkdir -p ./.s3cmd
touch ./.s3cmd/config
echo "resolve ./.s3cmd/config with secret manager"
# I need 2 volumes : one to map the s3cmd config file, one for the bucket
docker run -itd --name devops-bubble -v $PWD/.s3cmd/config:/root/.s3cfg -v $PWD/bucket-content:/gio/devops/bucket graviteeio/s3cmd:clever-cloud-0.0.1 bash
docker exec -it devops-bubble bash -c "s3cmd --version"
docker exec -it devops-bubble bash -c "ls -allh . && ls -allh /root/.s3cmd && ls -allh /gio/devops/ && ls -allh /gio/devops/bucket "

```

## ANNEX : A candidate Next Target Design

Note finally that The https://dist.gravitee.io/ service :
* only cares about on Gravitee Product `Gravitee APIM`.
* Well, we probably would want to generalize the https://dist.gravitee.io/ service to be responsible of serving distrib files, of Nightly Releases, for all Gravitee Products, not just `Gravitee APIM`.
* Indeed, we can easily conceive :
  * a "Nightly Release" concept for any Gravitee.io Product
  * and therefore a "Deliver Nightly Release" CI CD Process, just like we have begun doing so for Gravitee Cockpit, see [Gravitee Cockpit (work in progress)](#gravitee-cockpit-work-in-progress)

## S3 Buckets, S3 clients, and files attributes

For the record :

>
> azize  9 minutes ago
> possible de conserver les dates ?
> JB  8 minutes ago
> hum, j'examine la question
> JB  < 1 minute ago
> eh ben très bonne question, parcequ'en fait :
>
> * mis à part la date,
> * il y a tous les autres attributs de ficheirs que j'aielrai conservés
> * et il se trouve que non suelement ave l'outil que j'utilise,mais aussi avec aws cli, eh ben c'est la merde, cette question ....
> * du coup j'en ai trouvé un qui devrait nous permettre de cosnervver une ensembledécent d'attributs de fihiers : https://restic.readthedocs.io/en/latest/manual_rest.html?highlight=metadata#metadata-handling
>

So basically, when we store such files, especially that are going to be used in an execution envrionment, well I particularly want those fiels to keep the exact files attributes they were set in the first place.

Anyway , acorss all files operations :
* once a file is created by Gravitee,
* from then on
* all of its files attributes should never ever change, as we move them from one storage, to another
* and especially when we move store, backup and restore themto the S3 butvcket we'll use as https://download.gravitee.io

For this matter, https://restic.readthedocs.io/en/latest/manual_rest.html?highlight=metadata#metadata-handling

## ANNEX S3 clients behavior and huge list of files.

One thing I noticed about `s3cmd`, is that it calculates checksums for all files, before doing any upload to the remote.

In the example below, `s3cmd` calculatesthe checksum for 15 thousand files, before uploading them to the S3 bucket.

```bash
jbl@pc-alienware-jbl:~/s3cmd$ docker exec -it devops-bubble bash -c "s3cmd sync -v --acl-public /gio/devops/bucket/ s3://${S3_BUCKET_NAME}/"
INFO: No cache file found, creating it.
INFO: Compiling list of local files...
WARNING: Skipping over symbolic link: /gio/devops/bucket/graviteeio-apim/distributions/graviteeio-full-jdbc-3.0.15.zip.md5
WARNING: Skipping over symbolic link: /gio/devops/bucket/graviteeio-apim/distributions/graviteeio-full-jdbc-3.0.15.zip
WARNING: Skipping over symbolic link: /gio/devops/bucket/graviteeio-apim/distributions/graviteeio-full-jdbc-3.0.15.zip.sha1
WARNING: Skipping over symbolic link: /gio/devops/bucket/graviteeio-apim/distributions/graviteeio-full-jdbc-3.0.14.zip
WARNING: Skipping over symbolic link: /gio/devops/bucket/graviteeio-apim/distributions/graviteeio-full-jdbc-3.0.14.zip.md5
WARNING: Skipping over symbolic link: /gio/devops/bucket/graviteeio-apim/distributions/graviteeio-full-jdbc-3.0.14.zip.sha1
INFO: Running stat() and reading/calculating MD5 values on 15876 files, this may take some time...
INFO: [1000/15876]
INFO: [2000/15876]
INFO: [3000/15876]
INFO: [4000/15876]
INFO: [5000/15876]
INFO: [6000/15876]
INFO: [7000/15876]
INFO: [8000/15876]
INFO: [9000/15876]
INFO: [10000/15876]
INFO: [11000/15876]
INFO: [12000/15876]
INFO: [13000/15876]
INFO: [14000/15876]
INFO: [15000/15876]
INFO: Retrieving list of remote files for s3:/// ...
INFO: Found 15876 local files, 0 remote files
INFO: Verifying attributes...
INFO: Summary: 10542 local files to upload, 5334 files to remote copy, 0 remote files to delete
WARNING: .git/FETCH_HEAD: Owner username not known. Storing UID=1000 instead.
WARNING: .git/FETCH_HEAD: Owner groupname not known. Storing GID=1000 instead.
upload: '/gio/devops/bucket/.git/FETCH_HEAD' -> 's3://.git/FETCH_HEAD'  [1 of 10542]
 101 of 101   100% in    0s    13.06 KB/s  done
ERROR: S3 error: 400 (InvalidBucketName)
```

And the funny thing is that it take a very, very long time bedfore realizing I forgot to set the value of the `S3_BUCKET_NAME` env.var., before running the `s3cmd` command.

Ok, so maybe it would be good, to find, if they exists, tools that are a little better at working with huge amounts of files. That behave differently.

## About the migration operation from Git LFS to the S3 butcket

After i had retireved allfiles with `git lfs pull && git lfs checkout`, then I am astonished to witness, that most of the disk usage is in the `./.git/` directory :

```bash
du -h -d1 ./bucket-content/
122G	./bucket-content/.git
200K	./bucket-content/plugins
1.5G	./bucket-content/graviteeio-ae
904K	./bucket-content/graviteeio-ee
12M	./bucket-content/community
20M	./bucket-content/sample-apis
27M	./bucket-content/graviteeio-apim
4.0M	./bucket-content/graviteeio-am
124G	./bucket-content/
```

And what if I did not sync the .git/ directory ?

let's try that :


cla.pdf
community
graviteeio-ae
graviteeio-am
graviteeio-apim
graviteeio-ee
plugins


## ANNEX : Misc Resources

* A tutorial from Clever Cloud : https://www.clever-cloud.com/blog/features/2020/10/08/s3-directory-listing/
* Rclone https://rclone.org/install/
* advised palylist while working :
  * ["Creedence Revival Clearwater Greatest Hits (Full Album) Best Songs (HQ)"](https://www.youtube.com/watch?v=05JgKtm9ZKU)
