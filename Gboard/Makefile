.PHONY: all compile build clean preview validate

SKIN = Gboard

# 背景模式：true 为 iOS 版（筛选面板使用系统内置背景，默认），false 为纯色版 / Android（筛选面板铺主题底板色）。例：make build GRADIENT=false
GRADIENT ?= true
# 编译用的源码暂存目录。Options.libsonnet 在这里按 GRADIENT 重写，仓库里的文件不动
STAGE = build/src

all: build

clean:
	rm -rf dark light *.hskin *.zip *.yaml build

compile: clean
	@case "$(GRADIENT)" in true|false) ;; *) echo "GRADIENT 只能是 true 或 false：$(GRADIENT)"; exit 1;; esac
	mkdir -p dark light "$(STAGE)"
	cp -r jsonnet "$(STAGE)/"
	sed 's/^  gradient: .*/  gradient: $(GRADIENT),/' jsonnet/Constants/Options.libsonnet > "$(STAGE)/jsonnet/Constants/Options.libsonnet"
	jsonnet -S -m . "$(STAGE)/jsonnet/main.jsonnet"

# 结构校验：查出引用了不存在的样式名这类会让按键静默变空白的问题
validate: compile
	python3 ../tests/validate_skin.py .

# 渲染预览图，几何问题（键太矮、某行没铺满）只能看图
preview: compile
	python3 ~/.claude/skills/hamster-skin-skill/scripts/preview_skin.py . build/preview

build: compile
	mkdir -p "build/$(SKIN)"
	cp -r README.md demo.png config.yaml light dark "$(STAGE)/jsonnet" "build/$(SKIN)/"
	cd build && zip -r "$(SKIN).cskin" "$(SKIN)/" -x "*.DS_Store" "*/.*" "*/Test*"
