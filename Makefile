GOLANGCI_VERSION = 1.21.0

default: generate lint test build bundle ##=> Run all default targets
.PHONY: default

ci: deps generate lint test ##=> Run all CI targets
.PHONY: ci

generate: ##=> generate all the things
	@echo "--- generate all the things"
	@go generate ./...
.PHONY: generate

bin/golangci-lint: bin/golangci-lint-${GOLANGCI_VERSION}
	@ln -sf golangci-lint-${GOLANGCI_VERSION} bin/golangci-lint
bin/golangci-lint-${GOLANGCI_VERSION}:
	curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | BINARY=golangci-lint bash -s -- v${GOLANGCI_VERSION}
	@mv bin/golangci-lint $@

lint: bin/golangci-lint ##=> Lint all the things
	@echo "--- lint all the things"
	@$(shell pwd)/bin/golangci-lint run
.PHONY: lint

clean: ##=> Clean all the things
	$(info [+] Clean all the things...")
.PHONY: clean

test: ##=> Run the tests
	$(info [+] Run tests...")
	@go test -v -cover ./...
.PHONY: test

build: ##=> build all the things
	@echo "--- build all the things"
	@GOOS=linux GOARCH=amd64 go build -o dist/server-httpapi ./cmd/server-httpapi 
.PHONY: build

bundle: ##=> Build the bundle
	$(info [+] Build bundle...")
	@zip -r -q ./handler.zip public
	@cd dist && zip -r -q ../handler.zip .
.PHONY: bundle