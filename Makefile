tag := latest
include ./image.properties

build-container:
	docker build --build-arg UBUNTU_VERSION=${UBUNTU_VERSION} --build-arg MONIT_DOWNLOAD_URL=${MONIT_DOWNLOAD_URL} -t monit:${tag} .

push:
	docker buildx build --push --platform linux/arm/v7,linux/arm64/v8,linux/amd6 --tag clickbg/${tag} .

.PHONY: all push build-container
