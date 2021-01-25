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

# The Zip bundles Downloads Server(s) (Work in progress)

### The problem

The docker images of __Gravitee APIM__, and other Gravitee.io Products, are defined by Dockerfiles, using two "downloads" servers :
* https://dist.gravitee.io/
* and https://download.gravitee.io/

The `Dockerfile`s defined for the 4 Gravitee APIM components are :
* in the https://github.com/gravitee-io/gravitee-docker repo
* Gravitee APIM Management API :
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

Now, for each of those container image definition, I syntnetized the download servers usage,and it makes clear that :
* https://dist.gravitee.io/ is used to build nightly images
* and https://download.gravitee.io/is used to build release images

Those two servers are therefore, two compoents of the infrastructure of the global Gravitee CICD System.

__Gravitee APIM__ :

{{< tables/1/table id="sample" class="bordered" data-sample=10 >}}

| Gravitee Product             | nightly or release | Download(s) server(s) used          | Check this in the git repo 's master branch          |
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


__Gravitee AM (coming soon)__ :

{{< tables/1/table id="sample" class="bordered" data-sample=10 >}}

| Gravitee Product             | nightly or release | Download(s) server(s) used          | Check this in the git repo 's master branch          |
|------------------------------|--------------------|-------------------------------------|------------------------------------------------------|
<!--
| Gravitee AM Management API | nightly            | https://dist.gravitee.io/           | [`./images/management-api/Dockerfile-nightly` line 21](https://github.com/gravitee-io/gravitee-docker/blob/2ba64162af7717ccbcb79025e221e997846a34ae/images/management-api/Dockerfile-nightly#L21) |
| Gravitee AM Management UI  | release            | https://download.gravitee.io/       | [`./images/management-ui/Dockerfile` ligne 26](https://github.com/gravitee-io/gravitee-docker/blob/2ba64162af7717ccbcb79025e221e997846a34ae/images/management-ui/Dockerfile#L26)  |
-->
{{</ tables/1/table >}}


### Overview

* Legacy :
  * Apache HttpServer
  * content defined by


* New design main points :
  * must keep the old URLs, all based on https://download.gravitee.io/
  * S3 bucket based (clever cloud)
  * I will add a hugo theme to browse at least main pages and to start with for the home landing page (explaining what's there, the policy about not keeping files older than ...e tc...)

### Misc Resources

* A tutorial form Clever Cloud : https://www.clever-cloud.com/blog/features/2020/10/08/s3-directory-listing/
