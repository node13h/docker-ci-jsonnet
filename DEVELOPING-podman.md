## Setting up a local development environment

Local development has been tested on Fedora 39 with Podman as the container
executable. Root privileges are not needed for running local builds.

### Install prerequisites

- [gitlab-ci-local](https://github.com/firecow/gitlab-ci-local).
- Podman
- GNU Make
- `qemu-user-static` to enable cros-platform builds.

### Set up a container network for builds

To run CI jobs locally, a Podman network with DNS for container names enabled
is necessary. The default network has it disabled, so not suitable.
To create a new network named `localci` run

```shell
podman network create localci
```

### Set up a local container registry

Container builds need a registry to store and pass built images between jobs.
To start a local registry container named `localci-registry` in background run

```
podman run -d --restart=on-failure -p 5000:5000 --name localci-registry --network localci \
    docker.io/library/registry:2
```

### Define local CI variables

Use the following example to create `.gitlab-ci-local-variables.yml`. Note
the `localci-registry` address matching the name of the local registry container
created earlier.

```shell
{
    read -rp 'DockerHub username: ' dockerhub_user
    read -rsp 'DockerHub token: ' dockerhub_token
    dockerhub_auth=$(printf '%s:%s' "$dockerhub_user", "$dockerhub_token" | base64)

    cat <<EOF >.gitlab-ci-local-variables.yml
---
PUBLISH_IMAGE: 'docker.io/alikov/ci-jsonnet'
CI_REGISTRY: 'localci-registry:5000'
CI_REGISTRY_IMAGE: 'localci-registry:5000/ci-jsonnet'
TRIVY_INSECURE: 'true'
CONTAINERS_REGISTRIES_CONF:
  type: file
  values:
    '*': |
      [[registry]]
      location = "localci-registry:5000"
      insecure = true

REGISTRY_AUTH_FILE:
  type: file
  values:
    '*': |
      {"auths": {
        "docker.io": {
          "auth": "${dockerhub_auth}"
        }
      }}
EOF
}
```

## Running builds locally

Run `make pipeline` to run the pipeline defined in [.gitlab-ci.yml](.gitlab-ci.yml).
Run `make publish-pipeline` to run the pipeline including the manual `publish` job.

See [Makefile](Makefile) for more details. Override `CONTAINER_NETWORK` if the
default `localci` is different from the network name created earlier.

## Updating tool versions

- Update [binaries.txt](binaries.txt) with new versions/checksums/URLs.
- Update the `JB_VERSION` and `JSONNET_GO_VERSION` variables in
  [.gitlab-ci.yml](.gitlab-ci.yml).
