.PHONY: all clean build solid

SKINS = default numeric sbxlm46 hamster T9 cangjie zhuyin 胭云 莫吉托 彩虹 Gboard Noctua
# 支持 GRADIENT 参数（渐变 / 纯色背景）的皮肤，其余皮肤两个版本完全相同
GRADIENT_SKINS = 胭云 莫吉托 彩虹 Noctua

# 渐变背景版，产物在 build/
build:
	@echo "Building the project..."
	@for s in $(SKINS); do $(MAKE) -C "$$s" || exit 1; done
	rm -rf build && mkdir -p build/
	@for s in $(SKINS); do cp -r "$$s"/build/*.cskin build/ || exit 1; done

# 纯色背景（无渐变）版，产物在 build-solid/。皮肤名与渐变版相同，可直接替换
solid:
	@echo "Building the project (solid background)..."
	@for s in $(SKINS); do \
		case " $(GRADIENT_SKINS) " in \
			*" $$s "*) $(MAKE) -C "$$s" GRADIENT=false || exit 1;; \
			*) $(MAKE) -C "$$s" || exit 1;; \
		esac; \
	done
	rm -rf build-solid && mkdir -p build-solid/
	@for s in $(SKINS); do cp -r "$$s"/build/*.cskin build-solid/ || exit 1; done

clean:
	@echo "Cleaning the project..."
	@for s in $(SKINS); do $(MAKE) -C "$$s" clean || exit 1; done
	rm -rf build build-solid

all: build
