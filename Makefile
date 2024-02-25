CONTAINER_EXECUTABLE ?= docker
CONTAINER_NETWORK := localci
GIT_TAG = $(shell git tag --points-at HEAD | { grep '^v[[:digit:]]\+\.[[:digit:]]\+\.[[:digit:]]' || test $? = 1; })

.PHONY: pipeline publish-pipeline

pipeline: .gitlab-ci-local-variables.yml
	gitlab-ci-local --network $(CONTAINER_NETWORK) --container-executable $(CONTAINER_EXECUTABLE)

publish-pipeline: .gitlab-ci-local-variables.yml
	-- gitlab-ci-local --network $(CONTAINER_NETWORK) --manual publish --container-executable $(CONTAINER_EXECUTABLE) --variable CI_COMMIT_TAG=$(GIT_TAG)
