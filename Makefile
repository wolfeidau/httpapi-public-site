GOLANGCI_VERSION = 1.27.0

STAGE ?= dev
BRANCH ?= master

WATCH := (.go$$)|(.html$$)

default: generate lint test build bundle package deploy ##=> Run all default targets
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

bin/reflex:
	env GOBIN=$(shell pwd)/bin GO111MODULE=on go install github.com/cespare/reflex

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

package:
	@echo "--- package lambdas and upload to $(S3_BUCKET)"
	@echo "Running as: $(shell aws sts get-caller-identity --query Arn --output text)"
	@aws cloudformation package \
		--template-file sam/api.sam.yaml \
		--output-template-file api.out.yaml \
		--s3-bucket $(S3_BUCKET) \
		--s3-prefix sam
.PHONY: package

deploy:
	@echo "--- deploy lambdas into aws"
	@aws cloudformation deploy \
		--no-fail-on-empty-changeset \
		--template-file api.out.yaml \
		--capabilities CAPABILITY_IAM \
		--stack-name httpapi-public-site-$(STAGE)-$(BRANCH) \
    --parameter-overrides \
      Stage=$(STAGE) \
			Branch=$(BRANCH)
.PHONY: deploy

watch: bin/reflex
	@STAGE=local bin/reflex -R '^static/' -r "$(WATCH)" -s -- go run cmd/server-local/main.go
.PHONY: watch