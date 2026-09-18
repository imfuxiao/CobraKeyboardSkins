.PHONY: all compile build clean preview validate

SKIN = Noctua

all: build

clean:
	rm -rf dark light *.hskin *.zip *.yaml build

compile: clean
	mkdir -p dark light
	jsonnet -S -m . jsonnet/main.jsonnet

# 结构校验：查出引用了不存在的样式名这类会让按键静默变空白的问题
validate: compile
	python3 ~/.claude/skills/hamster-skin-skill/scripts/validate_skin.py .

# 渲染预览图，几何问题（键太矮、某行没铺满）只能看图
preview: compile
	python3 ~/.claude/skills/hamster-skin-skill/scripts/preview_skin.py . build/preview

build: compile
	rm -rf build && mkdir -p "build/$(SKIN)"
	cp -r README.md demo.png config.yaml light dark jsonnet "build/$(SKIN)/"
	cd build && zip -r "$(SKIN).cskin" "$(SKIN)/" -x "*.DS_Store" "*/.*" "*/Test*"
