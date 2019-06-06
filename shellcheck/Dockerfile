# Build-only image
FROM fedora:30 AS build

RUN dnf install -y --setopt=tsflags=nodocs \
  find ShellCheck && \
  dnf clean all && \
  rm -rf /var/cache/dnf 
