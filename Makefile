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
	$(MAKE) -C 胭云
	$(MAKE) -C 莫吉托
	$(MAKE) -C 彩虹
	$(MAKE) -C Gboard
	$(MAKE) -C Noctua
	rm -rf build && mkdir -p build/
	cp -r default/build/*.cskin \
	numeric/build/*.cskin \
	sbxlm46/build/*.cskin \
	hamster/build/*.cskin \
	T9/build/*.cskin \
	cangjie/build/*.cskin \
	zhuyin/build/*.cskin \
	胭云/build/*.cskin \
	莫吉托/build/*.cskin \
	彩虹/build/*.cskin \
	Gboard/build/*.cskin \
	Noctua/build/*.cskin \
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
	$(MAKE) -C 胭云 clean
	$(MAKE) -C 莫吉托 clean
	$(MAKE) -C 彩虹 clean
	$(MAKE) -C Gboard clean
	$(MAKE) -C Noctua clean
	rm -rf build

all: build
