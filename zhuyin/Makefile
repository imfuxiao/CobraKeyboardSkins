.PHONY: all compile build clean

all: build

clean:
	rm -rf dark light *.hskin *.zip *.yaml build

compile: clean
	mkdir -p dark light
	jsonnet -S -m . jsonnet/main.jsonnet

build: compile
	rm -rf build && mkdir -p build/zhuyin
	cp -r README.md demo.png config.yaml light dark jsonnet build/zhuyin/
	cd build && zip -r zhuyin.cskin zhuyin/ -x "*.DS_Store" "*/.*" "*/Test*"