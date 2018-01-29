NAME := rocknsm/base
REV := $(shell git log -1 --pretty=%h)
VERSION := $(shell cat Dockerfile | awk -F= '/io.rocknsm.base/ { print $$2 }' | tr -d '"')
TAG := ${VERSION}-${REV}
IMG := ${NAME}:${TAG}
LATEST := ${NAME}:latest

build:
	@docker build -t ${IMG} .
	@docker tag ${IMG} ${LATEST}

push:
	@docker push ${NAME}

login:
	@docker log -u ${DOCKER_USER} -p ${DOCKER_PASS}
