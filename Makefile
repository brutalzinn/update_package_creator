# Makefile for building Flutter desktop executables for Windows, Mac, and Linux

FLUTTER = flutter

.PHONY: all build clean

all: build

build: build-windows build-mac build-linux

build-windows:
	@echo "Building Windows executable..."
	@$(FLUTTER) build windows

build-mac:
	@echo "Building Mac executable..."
	@$(FLUTTER) build macos

build-linux:
	@echo "Building Linux executable..."
	@$(FLUTTER) build linux

clean:
	@echo "Cleaning up..."
	@$(FLUTTER) clean
