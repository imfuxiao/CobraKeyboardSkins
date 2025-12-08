.PHONY: all clean build

build:
	@echo "Building the project..."
	$(MAKE) -C default
	$(MAKE) -C numeric
	$(MAKE) -C sbxlm46
	$(MAKE) -C hamster
	rm -rf build && mkdir -p build/
	cp -r default/build/*.cskin numeric/build/*.cskin sbxlm46/build/*.cskin hamster/build/*.cskin build/

clean:
	@echo "Cleaning the project..."
	$(MAKE) -C default clean
	$(MAKE) -C numeric clean
	$(MAKE) -C sbxlm46 clean
	$(MAKE) -C hamster clean
	rm -rf build

all: build