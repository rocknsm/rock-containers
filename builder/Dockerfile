FROM centos:8

LABEL RUN docker run -ti --rm -v $(pwd):/build -v ${HOME}/.gnupg/pubring.kbx:/root/.gnupg/pubring.kbx -v ${HOME}/.gnupg/trustdb.gpg:/root/.gnupg/trustdb.gpg -v ${HOME}/.gnupg/S.gpg-agent:/root/.gnupg/S.gpg-agent -v ${SSH_AUTH_SOCK}:${SSH_AUTH_SOCK} -e SSH_AUTH_SOCK=${SSH_AUTH_SOCK} ${IMAGE}

RUN dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm && \
    dnf install -y --setopt=install_weak_deps=False --nodocs tito && \
    dnf clean all

RUN git config --system user.email "security@rocknsm.io"
RUN git config --system user.name  "ROCK Lobster"
RUN git config --system commit.gpgsign true

ENV LANG=C.utf8
WORKDIR /build
