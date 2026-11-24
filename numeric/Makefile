.PHONY: all compile build clean

JSONNET ?= jrsonnet

all: build

clean:
	rm -rf dark light *.hskin *.zip *.yaml build

compile: clean
	mkdir -p dark light
	$(JSONNET) -S -m . jsonnet/main.jsonnet

build: compile
	rm -rf build && mkdir -p build/numeric
	cp -r demo.png config.yaml light dark jsonnet build/numeric/
	cd build && zip -r numeric.cskin numeric/ -x "*.DS_Store" "*/.*" "*/Test*"