.phony: all build clean

build:
	mkdir -p dark light
	jsonnet -m . jsonnet/main.jsonnet

clean:
	rm -rf dark light