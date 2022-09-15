# TODO :: make this an array and loop below
BASE_IMAGE=nextcloud:24-apache

get-image = $(firstword $(subst :, ,$1))
get-tag = $(lastword $(subst :, ,$1))

image=$(call get-image,$(BASE_IMAGE))
tag=$(call get-tag,$(BASE_IMAGE))

.PHONY: build
build:
	docker build -t r0wi/$(image)-extended:$(tag) --build-arg BASE_IMAGE=$(BASE_IMAGE) .

.PHONY: push
push:
	docker push r0wi/$(image)-extended:$(tag)

.PHONY: build-push
build-push: build push