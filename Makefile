# This Makefile assists in creating and managing the container. Make you life
# easer and use it :wink:
#
# Run `make image` to build the image
# Run `make list-containers` to list the runway-server containers
# Run `make list-images` to list the runway-server images
# Run `make clean-containers`
# Run `make clean-image`
# Run `make shell` to drop in at the shell of the container
SHELL=/bin/sh
DOCKER=docker
GIT=git

include configuration.mk

OWNER=vidbina
PROJECT=scala-env
VERSION=$(shell cat VERSION)
REVISION=$(shell git rev-parse HEAD)

LIST_FILTER=-f "label=owner=${OWNER}" -f "label=project=${PROJECT}"
LIST_IMAGES=${DOCKER} images -a ${LIST_FILTER}
LIST_CONTAINERS=${DOCKER} ps -a ${LIST_FILTER}

image: Dockerfile
	${DOCKER} build \
		--rm --force-rm \
		--build-arg SBT_VERSION=${SBT_VERSION} \
		--build-arg SCALA_VERSION=${SCALA_VERSION} \
		-t "${OWNER}/${PROJECT}:latest" \
		-t "${OWNER}/${PROJECT}:${VERSION}" \
		--label "owner=${OWNER}" \
		--label "project=${PROJECT}" \
		.

clean-containers:
	$(eval CONTAINERS=$(shell ${LIST_CONTAINERS} -q))
	@if [ -n "${CONTAINERS}" ]; \
		then echo "removing containers ${CONTAINERS}" && \
		${DOCKER} rm ${CONTAINERS}; \
		else echo "No containers to remove"; \
		fi

clean-images-by-force:
	$(eval IMAGES=$(shell ${LIST_IMAGES} -q))
	@if [ -n "${IMAGES}" ]; \
		then echo "removing images ${IMAGES}" && \
		${DOCKER} rmi --force ${IMAGES}; \
		else echo "No images to remove"; \
		fi

clean-images:
	$(eval IMAGES=$(shell ${LIST_IMAGES} -q))
	@if [ -n "${IMAGES}" ]; \
		then echo "removing images ${IMAGES}" && \
		${DOCKER} rmi ${IMAGES}; \
		else echo "No images to remove"; \
		fi

list-containers: 
	${LIST_CONTAINERS}

list-images: 
	${LIST_IMAGES}

run:
	${DOCKER} run \
		--rm \
		-it \
		-v ${PWD}:/src \
		${OWNER}/${PROJECT}:${VERSION} 

shell:
	${DOCKER} run \
		--rm \
		-it \
		-e SBT_OPTS=${SBT_OPTS} \
		${OWNER}/${PROJECT}:${VERSION} \
		/bin/bash

.PHONY: \
	clean-containers clean-images clean-images-by-force \
	image \
	list-containers list-images \
	run \
	shell \
	pull \
