.PHONY: all compile build clean

all: build

clean:
	rm -rf dark light *.hskin *.zip *.yaml build

compile: clean
	mkdir -p dark light
	jsonnet -S -m . jsonnet/main.jsonnet

build: compile
	rm -rf build && mkdir -p build/sbxlm46
	cp -r README.md demo.png config.yaml light dark jsonnet build/sbxlm46/
	cd build && zip -r sbxlm46.cskin sbxlm46/ -x "*.DS_Store" "*/.*" "*/Test*"