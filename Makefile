.PHONY: all clean build

build:
	@echo "Building the project..."
	$(MAKE) -C default
	$(MAKE) -C numeric
	$(MAKE) -C sbxlm46

clean:
	@echo "Cleaning the project..."
	$(MAKE) -C default clean
	$(MAKE) -C numeric clean
	$(MAKE) -C sbxlm46 clean

all: build