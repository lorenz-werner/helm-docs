#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/.."
export GOTOOLCHAIN=local

# Keep the existing module paths (including Helm v3).
# Major-version migrations require separate source changes.
go version
go get -u -t ./...
go mod tidy
go mod verify
go test ./...
CGO_ENABLED=0 go build -trimpath -o "${TMPDIR:-/tmp}/helm-docs-security" ./cmd/helm-docs
go version -m "${TMPDIR:-/tmp}/helm-docs-security"
