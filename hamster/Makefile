.PHONY: all compile build clean

JSONNET ?= jrsonnet

all: build

clean:
	rm -rf dark light *.hskin *.zip *.yaml build

compile: clean
	mkdir -p dark light
	$(JSONNET) -S -m . jsonnet/main.jsonnet

build: compile
	rm -rf build && mkdir -p build/hamster
	cp -r README.md demo.png config.yaml light dark jsonnet build/hamster/
	cd build && zip -r hamster.cskin hamster/ -x "*.DS_Store" "*/.*" "*/Test*"