"""调用皮肤校验器，兼容尚未收录候选筛选面板的版本。"""
from pathlib import Path
import runpy
import sys


if __name__ == "__main__":
    script = Path.home() / ".claude/skills/hamster-skin-skill/scripts/validate_skin.py"
    validator = runpy.run_path(str(script))
    for table, value in (("SHORTCUTS", "#candidateFilterPanelToggle"),
                         ("STRUCTURAL_KEYS", "candidateFilterPanelStyle")):
        if value not in validator[table]:
            validator[table].append(value)
    sys.exit(validator["main"](sys.argv))
