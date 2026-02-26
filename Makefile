.PHONY: all clean build

build:
	@echo "Building the project..."
	$(MAKE) -C default
	$(MAKE) -C numeric
	$(MAKE) -C sbxlm46
	$(MAKE) -C hamster
	$(MAKE) -C T9
	$(MAKE) -C cangjie
	$(MAKE) -C zhuyin
	rm -rf build && mkdir -p build/
	cp -r default/build/*.cskin \
	numeric/build/*.cskin \
	sbxlm46/build/*.cskin \
	hamster/build/*.cskin \
	T9/build/*.cskin \
	cangjie/build/*.cskin \
	zhuyin/build/*.cskin \
	build/

clean:
	@echo "Cleaning the project..."
	$(MAKE) -C default clean
	$(MAKE) -C numeric clean
	$(MAKE) -C sbxlm46 clean
	$(MAKE) -C hamster clean
	$(MAKE) -C T9 clean
	$(MAKE) -C cangjie clean
	$(MAKE) -C zhuyin clean
	rm -rf build

all: build
