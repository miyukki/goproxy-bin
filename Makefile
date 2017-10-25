NAME := goproxy

GO_ENV := CGO_ENABLED=0
GO := go
GO_PKGS := $(shell go list ./... | grep -vE "(vendor|tools|proto|hack|.codeship)")
GODEP := godep
GOLINT := golint
GOVENDOR := govendor

.PHONY: all
all: build

.PHONY: build
build: BUILD_DIR ?= ./build
build: BUILD_OPTS ?= -ldflags "-w"
build: BUILD_ENV ?= GOOS=linux GOARCH=amd64
build:
	$(BUILD_ENV) $(GO_ENV) $(GO) build $(BUILD_OPTS) -o $(BUILD_DIR)/$(NAME) ./main.go

.PHONY: run
run:
	$(GO_ENV) $(GO) run ./main.go

.PHONY: vet
vet:
	$(GO_ENV) $(GO) vet $(GO_PKGS)

.PHONY: lint
lint:
	for pkg in $(GO_PKGS); do \
		$(GOLINT) $$pkg; \
	done

.PHONY: test
test: FLAGS ?=
test:
	$(GO_ENV) ABM_ENV=test $(GO) test $(FLAGS) $(GO_PKGS)
