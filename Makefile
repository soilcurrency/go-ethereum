# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: gsoil gsoil-cross evm all test travis-test-with-coverage xgo clean
.PHONY: gsoil-linux gsoil-linux-arm gsoil-linux-386 gsoil-linux-amd64
.PHONY: gsoil-darwin gsoil-darwin-386 gsoil-darwin-amd64
.PHONY: gsoil-windows gsoil-windows-386 gsoil-windows-amd64
.PHONY: gsoil-android gsoil-android-16 gsoil-android-21

GOBIN = build/bin

CROSSDEPS = https://gmplib.org/download/gmp/gmp-6.0.0a.tar.bz2
GO ?= latest

gsoil:
	build/env.sh go install -v $(shell build/flags.sh) ./cmd/gsoil
	@echo "Done building."
	@echo "Run \"$(GOBIN)/gsoil\" to launch gsoil."

gsoil-cross: gsoil-linux gsoil-darwin gsoil-windows gsoil-android
	@echo "Full cross compilation done:"
	@ls -l $(GOBIN)/gsoil-*

gsoil-linux: xgo gsoil-linux-arm gsoil-linux-386 gsoil-linux-amd64
	@echo "Linux cross compilation done:"
	@ls -l $(GOBIN)/gsoil-linux-*

gsoil-linux-arm: xgo
	build/env.sh $(GOBIN)/xgo --go=$(GO) --dest=$(GOBIN) --deps=$(CROSSDEPS) --targets=linux/arm -v $(shell build/flags.sh) ./cmd/gsoil
	@echo "Linux ARM cross compilation done:"
	@ls -l $(GOBIN)/gsoil-linux-* | grep arm

gsoil-linux-386: xgo
	build/env.sh $(GOBIN)/xgo --go=$(GO) --dest=$(GOBIN) --deps=$(CROSSDEPS) --targets=linux/386 -v $(shell build/flags.sh) ./cmd/gsoil
	@echo "Linux 386 cross compilation done:"
	@ls -l $(GOBIN)/gsoil-linux-* | grep 386

gsoil-linux-amd64: xgo
	build/env.sh $(GOBIN)/xgo --go=$(GO) --dest=$(GOBIN) --deps=$(CROSSDEPS) --targets=linux/amd64 -v $(shell build/flags.sh) ./cmd/gsoil
	@echo "Linux amd64 cross compilation done:"
	@ls -l $(GOBIN)/gsoil-linux-* | grep amd64

gsoil-darwin: xgo gsoil-darwin-386 gsoil-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -l $(GOBIN)/gsoil-darwin-*

gsoil-darwin-386: xgo
	build/env.sh $(GOBIN)/xgo --go=$(GO) --dest=$(GOBIN) --deps=$(CROSSDEPS) --targets=darwin/386 -v $(shell build/flags.sh) ./cmd/gsoil
	@echo "Darwin 386 cross compilation done:"
	@ls -l $(GOBIN)/gsoil-darwin-* | grep 386

gsoil-darwin-amd64: xgo
	build/env.sh $(GOBIN)/xgo --go=$(GO) --dest=$(GOBIN) --deps=$(CROSSDEPS) --targets=darwin/amd64 -v $(shell build/flags.sh) ./cmd/gsoil
	@echo "Darwin amd64 cross compilation done:"
	@ls -l $(GOBIN)/gsoil-darwin-* | grep amd64

gsoil-windows: xgo gsoil-windows-386 gsoil-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -l $(GOBIN)/gsoil-windows-*

gsoil-windows-386: xgo
	build/env.sh $(GOBIN)/xgo --go=$(GO) --dest=$(GOBIN) --deps=$(CROSSDEPS) --targets=windows/386 -v $(shell build/flags.sh) ./cmd/gsoil
	@echo "Windows 386 cross compilation done:"
	@ls -l $(GOBIN)/gsoil-windows-* | grep 386

gsoil-windows-amd64: xgo
	build/env.sh $(GOBIN)/xgo --go=$(GO) --dest=$(GOBIN) --deps=$(CROSSDEPS) --targets=windows/amd64 -v $(shell build/flags.sh) ./cmd/gsoil
	@echo "Windows amd64 cross compilation done:"
	@ls -l $(GOBIN)/gsoil-windows-* | grep amd64

gsoil-android: xgo gsoil-android-16 gsoil-android-21
	@echo "Android cross compilation done:"
	@ls -l $(GOBIN)/gsoil-android-*

gsoil-android-16: xgo
	build/env.sh $(GOBIN)/xgo --go=$(GO) --dest=$(GOBIN) --deps=$(CROSSDEPS) --targets=android-16/* -v $(shell build/flags.sh) ./cmd/gsoil
	@echo "Android 16 cross compilation done:"
	@ls -l $(GOBIN)/gsoil-android-16-*

gsoil-android-21: xgo
	build/env.sh $(GOBIN)/xgo --go=$(GO) --dest=$(GOBIN) --deps=$(CROSSDEPS) --targets=android-21/* -v $(shell build/flags.sh) ./cmd/gsoil
	@echo "Android 21 cross compilation done:"
	@ls -l $(GOBIN)/gsoil-android-21-*

evm:
	build/env.sh $(GOROOT)/bin/go install -v $(shell build/flags.sh) ./cmd/evm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/evm to start the evm."

all:
	build/env.sh go install -v $(shell build/flags.sh) ./...

test: all
	build/env.sh go test ./...

travis-test-with-coverage: all
	build/env.sh build/test-global-coverage.sh

xgo:
	build/env.sh go get github.com/karalabe/xgo

clean:
	rm -fr build/_workspace/pkg/ Godeps/_workspace/pkg $(GOBIN)/*
