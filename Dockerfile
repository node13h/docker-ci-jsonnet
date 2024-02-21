# Workaround for https://github.com/containers/buildah/issues/4742
FROM docker.io/debian:12 as target

FROM --platform=$BUILDPLATFORM docker.io/busybox:1.36 AS download

ARG TARGETOS
ARG TARGETARCH

ARG JB_VERSION
ARG JSONNET_GO_VERSION

COPY download.sh binaries.txt /scripts/

RUN /scripts/download.sh /tmp/downloads/jb "jb-${JB_VERSION}-${TARGETOS}-${TARGETARCH}" \
    && mv "/tmp/downloads/jb/jb-${JB_VERSION}-${TARGETOS}-${TARGETARCH}" /tmp/downloads/jb/jb
RUN /scripts/download.sh /tmp/downloads/go-jsonnet "go-jsonnet-${JSONNET_GO_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz"
RUN tar -C /tmp/downloads/go-jsonnet -xf "/tmp/downloads/go-jsonnet/go-jsonnet-${JSONNET_GO_VERSION}-${TARGETOS}-${TARGETARCH}.tar.gz"

FROM target

ARG TARGETOS
ARG TARGETARCH
ARG SOURCE_DATE_EPOCH
ARG GIT_COMMIT_SHA

# Upgrade here for now, will move into a base image later.
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends jq yq bash make \
    && rm -rf /var/lib/apt/lists/*

COPY --from=download --chown=root:root --chmod=0755 [ \
    "/tmp/downloads/jb/jb", \
    "/tmp/downloads/go-jsonnet/jsonnet", \
    "/tmp/downloads/go-jsonnet/jsonnet-deps", \
    "/tmp/downloads/go-jsonnet/jsonnetfmt", \
    "/tmp/downloads/go-jsonnet/jsonnet-lint", \
    "/usr/bin/" ]

# https://github.com/opencontainers/image-spec/blob/main/annotations.md
LABEL org.opencontainers.image.revision=${GIT_COMMIT_SHA}
LABEL org.opencontainers.image.description="Jsonnet tooling for CI jobs"
LABEL org.opencontainers.image.authors="Sergej Alikov <sergej@alikov.com>"
LABEL org.opencontainers.image.source="https://gitlhub.com/node13h/docker-ci-jsonnet"
