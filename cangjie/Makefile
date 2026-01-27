.PHONY: all compile build clean

all: build

clean:
	rm -rf dark light *.hskin *.zip *.yaml build

compile: clean
	mkdir -p dark light
	jsonnet -S -m . jsonnet/main.jsonnet

build: compile
	rm -rf build && mkdir -p build/cangjie
	cp -r README.md demo.png config.yaml light dark jsonnet build/cangjie/
	cd build && zip -r cangjie.cskin cangjie/ -x "*.DS_Store" "*/.*" "*/Test*"