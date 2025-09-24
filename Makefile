.PHONY: all compile build clean

all: build

clean:
	rm -rf dark light *.hskin *.zip *.yaml build

compile: clean
	mkdir -p dark light
	jsonnet -S -m . jsonnet/main.jsonnet

build: compile
	rm -rf build && mkdir -p build/default
	cp -r demo.png config.yaml light dark jsonnet build/default/
	cd build && zip -r default.cskin default/ -x "*.DS_Store" "*/.*" "*/Test*"
