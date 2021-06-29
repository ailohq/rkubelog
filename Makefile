# Copyright 2019 SolarWinds Worldwide, LLC.
# SPDX-License-Identifier: Apache-2.0

lint:
	docker run --rm -v $(PWD):/app -w /app golangci/golangci-lint:v1.27.0 golangci-lint run --allow-parallel-runners --timeout 3m ./...

vet:
	go vet ./...

tests:
	go test -v ./...

build:
	go build -mod vendor -o bin/rkubelog

docker:
	DOCKER_BUILDKIT=1 docker build -t quay.io/solarwinds/rkubelog .

release-helm-chart:
	rm -rf .cr-release-packages
	docker run -w /app -v $(PWD):/app --entrypoint /usr/local/bin/cr quay.io/helmpack/chart-releaser package charts/rkubelog
	docker run -w /app -v $(PWD):/app --entrypoint /usr/local/bin/cr quay.io/helmpack/chart-releaser upload --owner ailohq --git-repo rkubelog --token ${GITHUB_TOKEN}