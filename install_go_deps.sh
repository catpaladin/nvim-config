#!/usr/bin/env bash

curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/
bin v1.54.2
go install github.com/segmentio/golines@latest
go install mvdan.cc/gofumpt@latest
go install -v github.com/incu6us/goimports-reviser/v3@latest
go install github.com/cweill/gotests/gotests@latest
go install golang.org/x/tools/cmd/godoc@latest
