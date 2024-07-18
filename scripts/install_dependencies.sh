#!/usr/bin/env bash

# Install nvim deps
curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.54.2
go install github.com/segmentio/golines@latest
go install mvdan.cc/gofumpt@latest
go install -v github.com/incu6us/goimports-reviser/v3@latest
go install github.com/cweill/gotests/gotests@latest
go install golang.org/x/tools/cmd/godoc@latest
go install github.com/go-delve/delve/cmd/dlv@v1.21.0

# Install go tools
go install github.com/spf13/cobra-cli@latest
go install github.com/a-h/templ/cmd/templ@latest
go install github.com/air-verse/air@latest
go install github.com/swaggo/swag/cmd/swag@latest

# Install python tools (requires rust cargo path)
curl -LsSf https://astral.sh/uv/install.sh | sh
curl -LsSf https://astral.sh/ruff/install.sh | sh
curl -sSf https://rye.astral.sh/get | bash
