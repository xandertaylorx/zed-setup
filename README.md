<h1 align="center">Zed Setup</h1>
<p align="center">
  Small keyboard-driven tweaks that make <a href="https://zed.dev">Zed</a> feel a bit more like home.<br>
  Run any file with one shortcut · toggle the Git panel with one key · readable Java formatting.
</p>

> 🎨 Looking for the theme? It lives in its own repo: **[Crooli Dark](https://github.com/xandertaylorx/crooli-dark-theme)**.

---

## Quick install

One command sets up everything below (run-file, git panel toggle, Java formatting):

```bash
curl -fsSL https://raw.githubusercontent.com/xandertaylorx/zed-setup/main/install.sh | sh
```

It merges into your existing `~/.config/zed/` files and saves a `.bak` of each one it changes. Safe to re-run. Needs `python3` (comes with Xcode command line tools). Comments in your Zed JSON files are not kept (they're in the `.bak`). Restart Zed afterwards.

Prefer to do it by hand? Each section below says how.

---

## What's inside

| | Tweak | What you get | Key |
| --- | --- | --- | --- |
| ▶️ | **Run file** | Run the open file in any language, straight from the keyboard | `⌘ ⌃ R` |
| 🌿 | **Git panel toggle** | One key to open *and* close the Git panel | `⌘ G` |
| ☕ | **Readable Java formatting** | Keeps calls on one line when they fit instead of one argument per line | `⌘ ⇧ I` |

They're independent. Take one, take both.

```bash
git clone https://github.com/xandertaylorx/zed-setup.git
cd zed-setup
```

> Zed has no toolbar run button yet, so Run file is a shortcut plus the gutter ▶ that Zed shows on entry points.

---

## ▶️ Run file

Press **`⌘ ⌃ R`** and the file you have open is saved (if it has unsaved changes) and then runs in Zed's terminal panel. The script picks the right command from the file extension.

| Language | Runs with |
| --- | --- |
| Python | `python3` |
| JavaScript / TypeScript | `node` / `npx tsx` |
| Java | compiles all `.java` files into `bin/`, runs the class named after your file |
| Rust | `cargo run` (or `rustc` without a `Cargo.toml`) |
| Go | `go run` |
| C / C++ | `clang` / `clang++` |
| Swift, Ruby, PHP, Lua | their own interpreters |
| Shell | `zsh` |
| Kotlin | `kotlinc` |
| HTML | opens in your browser |

Anything else prints a friendly message. Add a language with one line in the `case` block of [`run/run-file.sh`](run/run-file.sh). You need the relevant toolchain installed.

**Install**

```bash
cp run/run-file.sh ~/.config/zed/run-file.sh
```

1. Add the task from [`run/tasks.snippet.json`](run/tasks.snippet.json) to `~/.config/zed/tasks.json`.
2. Add the binding from [`keymap.snippet.json`](keymap.snippet.json) to `~/.config/zed/keymap.json`.

**Bonus: the gutter ▶.** The task is tagged so Zed also shows a clickable ▶ beside Python `if __name__ == "__main__":`, Go `main()`, Rust `main()` and shell scripts. Re-run the last task with Zed's built-in `⌘ ⌥ R`.

---

## 🌿 Git panel toggle

Zed's default key only *focuses* the Git panel, so you often press twice to close it. This binding opens it when closed and closes it when open, wherever your cursor is.

```json
{ "context": "Workspace", "bindings": { "cmd-g": "git_panel::Toggle" } }
```

`⌘ G` is also "find next" while a search bar is open, and that takes priority then.

---

## ☕ Readable Java formatting

Zed formats Java with Prettier by default, which puts **every argument on its own line** once a call passes 80 columns:

```java
newPlayer(
    "Kevin",
    11,
    4500,
    LocalDate.of(2023, 4, 22),
    1700,
    LocalDateTime.of(2026, 11, 5, 17, 25)
);
```

This switches Java to the Eclipse formatter (jdtls, which the Java extension already runs) with a profile that only wraps when a line won't fit in 120 columns:

```java
newPlayer("Kevin", 11, 4500, LocalDate.of(2023, 4, 22), 1700, LocalDateTime.of(2026, 11, 5, 17, 25));
```

**By hand:** copy [`java/java-formatter.xml`](java/java-formatter.xml) to `~/.config/zed/` and merge [`java/settings.snippet.json`](java/settings.snippet.json) into `settings.json` (replace `__ZED_DIR__` with your Zed config path). Want a different width? Change `lineSplit` in the XML.

---

## Optional: fonts

macOS system fonts, see [`settings.snippet.json`](settings.snippet.json):

```json
"ui_font_family": ".SystemUIFont",
"buffer_font_family": "SF Mono",
"buffer_font_fallbacks": ["Menlo"]
```

## Files

```text
├── install.sh                one-command installer
├── run/run-file.sh           the run-any-file script
├── run/tasks.snippet.json    task for tasks.json
├── java/java-formatter.xml   readable Java format profile
├── java/settings.snippet.json  settings that enable it
├── keymap.snippet.json       key bindings (run + git panel)
└── settings.snippet.json     font settings
```

Zed config lives in `~/.config/zed/`. Snippets are meant to be merged into your own files, not replace them. Tested on Zed 1.27 on macOS.

## License

MIT
