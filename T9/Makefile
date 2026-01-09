.PHONY: all compile build clean

all: build

clean:
	rm -rf dark light *.hskin *.zip *.yaml build

compile: clean
	mkdir -p dark light
	jsonnet -S -m . jsonnet/main.jsonnet

build: compile
	rm -rf build && mkdir -p build/T9
	cp -r demo.png config.yaml light dark jsonnet build/T9/
	cd build && zip -r T9.cskin T9/ -x "*.DS_Store" "*/.*" "*/Test*"
