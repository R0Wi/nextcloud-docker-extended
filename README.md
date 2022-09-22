# Nextcloud Docker image (extended)

[![](https://img.shields.io/badge/Docker-Hub-green)](https://hub.docker.com/repository/docker/r0wi/nextcloud-extended)
![Docker Image Version (latest semver)](https://img.shields.io/docker/v/r0wi/nextcloud-extended?sort=semver)

A docker image based on the official Nextcloud image with additional tools and dependencies.

- [Nextcloud Docker image (extended)](#nextcloud-docker-image-extended)
  - [Additional tools and dependencies packaged inside this container](#additional-tools-and-dependencies-packaged-inside-this-container)
  - [Usage](#usage)

## Additional tools and dependencies packaged inside this container

Currently the following tools and dependencies are installed inside the container (additionally to the ones already available in the official image):

* [**`ocrMyPdf`**](https://ocrmypdf.readthedocs.io/en/latest/): makes it possible to use the [`workflow_ocr`](https://github.com/R0Wi/workflow_ocr) app
* [**`smbclient`**](https://docs.nextcloud.com/server/latest/admin_manual/configuration_files/external_storage/smb.html): makes it possible to mount Samba shares inside the container

You can find more information by having a look into the [`Dockerfile`](https://github.com/R0Wi/Nextcloud-Docker-extended/Dockerfile).

## Usage

Since the image is based on the [official Nextcloud docker image](https://github.com/nextcloud/docker), you can use it exactly the same way. The only thing you have to change is the image name, which sould be changed to `r0wi/nextcloud-extended:<TAG>`. For example:

```bash
$ docker run -d -p 8080:80 r0wi/nextcloud-extended:24-apache
```

Please refer to the [official documentation](https://github.com/nextcloud/docker) for further details.

## How the image is updated

An update script runs every night to ensure that the image inherits all changes from the official Nextcloud image. The script itself searches for all `apache`-based Nextcloud images on the Docker Hub which are updated within the last 14 days. These images will be taken as base images.