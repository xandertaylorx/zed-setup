#!/bin/sh
# Zed setup installer: run-file shortcut, git panel toggle, readable Java formatting.
# Safe to re-run. Backs up every file it changes to <file>.bak.
set -e

ZED_DIR="${ZED_CONFIG_DIR:-$HOME/.config/zed}"
REPO_URL="https://github.com/xandertaylorx/zed-setup.git"

command -v python3 >/dev/null 2>&1 || { echo "python3 is required (install Xcode command line tools: xcode-select --install)"; exit 1; }

# Use the local checkout if we're in one, otherwise download a copy.
SRC=$(cd "$(dirname "$0")" 2>/dev/null && pwd || true)
if [ ! -f "$SRC/run/run-file.sh" ]; then
  command -v git >/dev/null 2>&1 || { echo "git is required"; exit 1; }
  SRC=$(mktemp -d)
  git clone --quiet --depth 1 "$REPO_URL" "$SRC"
fi

mkdir -p "$ZED_DIR"
cp "$SRC/run/run-file.sh" "$ZED_DIR/run-file.sh"
cp "$SRC/java/java-formatter.xml" "$ZED_DIR/java-formatter.xml"

python3 - "$SRC" "$ZED_DIR" <<'PY'
import json, os, re, shutil, sys

src, zed = sys.argv[1], sys.argv[2]

def load_jsonc(text):
    """Parse JSON with // and /* */ comments and trailing commas (what Zed allows)."""
    out, i, n, in_str = [], 0, len(text), False
    while i < n:
        c = text[i]
        if in_str:
            out.append(c)
            if c == "\\":
                out.append(text[i + 1]); i += 1
            elif c == '"':
                in_str = False
        elif c == '"':
            in_str = True; out.append(c)
        elif text.startswith("//", i):
            while i < n and text[i] != "\n": i += 1
            continue
        elif text.startswith("/*", i):
            i = text.index("*/", i) + 2
            continue
        else:
            out.append(c)
        i += 1
    s, res, in_str, i = "".join(out), [], False, 0
    while i < len(s):
        c = s[i]
        if in_str:
            res.append(c)
            if c == "\\":
                res.append(s[i + 1]); i += 1
            elif c == '"':
                in_str = False
        elif c == '"':
            in_str = True; res.append(c)
        elif c == "," and re.match(r"\s*[}\]]", s[i + 1:]):
            pass
        else:
            res.append(c)
        i += 1
    return json.loads("".join(res) or "null")

def read(path, default):
    if not os.path.exists(path):
        return default
    with open(path) as f:
        text = f.read()
    if not text.strip():
        return default
    try:
        return load_jsonc(text)
    except Exception as e:
        sys.exit(f"Could not parse {path} ({e}). Nothing changed; merge the snippets by hand (see README).")

def write(path, data):
    if os.path.exists(path):
        shutil.copy(path, path + ".bak")
    with open(path, "w") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
        f.write("\n")
    print("updated", path)

def snippet(rel):
    with open(os.path.join(src, rel)) as f:
        return json.loads(f.read().replace("__ZED_DIR__", zed))

def deep_merge(dst, new):
    for k, v in new.items():
        if isinstance(v, dict) and isinstance(dst.get(k), dict):
            deep_merge(dst[k], v)
        else:
            dst[k] = v

# settings.json: Java formatting
p = os.path.join(zed, "settings.json")
settings = read(p, {})
deep_merge(settings, snippet("java/settings.snippet.json"))
write(p, settings)

# tasks.json: replace/add "Run file"
p = os.path.join(zed, "tasks.json")
tasks = read(p, [])
new = snippet("run/tasks.snippet.json")
labels = {t["label"] for t in new}
write(p, [t for t in tasks if t.get("label") not in labels] + new)

# keymap.json: add our bindings unless already bound the same way
p = os.path.join(zed, "keymap.json")
keymap = read(p, [])
for block in snippet("keymap.snippet.json"):
    have = {}
    for b in keymap:
        if b.get("context") == block.get("context"):
            have.update(b.get("bindings", {}))
    missing = {k: v for k, v in block["bindings"].items() if have.get(k) != v}
    if missing:
        keymap.append({"context": block["context"], "bindings": missing})
write(p, keymap)
PY

echo
echo "Done. Restart Zed (or run 'editor: restart language server') and you're set:"
echo "  cmd-ctrl-r  save + run the current file"
echo "  cmd-g       toggle the Git panel"
echo "  cmd-shift-i format Java the readable way"
