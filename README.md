<h1 align="center">Zed Setup</h1>
<p align="center">
  A small, opinionated pack of tweaks that makes <a href="https://zed.dev">Zed</a> feel a bit more like home.<br>
  A dark theme · a run-anything shortcut · a one-key Git panel.
</p>

---

## What's inside

| | Tweak | What you get | Key |
| --- | --- | --- | --- |
| 🎨 | **Crooli Dark** | Near-black theme with VS Code Dark+ code colours | - |
| ▶️ | **Run file** | Run the open file in any language, straight from the keyboard | `⌘ ⌃ R` |
| 🌿 | **Git panel toggle** | One key to open *and* close the Git panel | `⌘ G` |

Everything is independent. Take one, take all.

> Zed has no toolbar run button yet, so Run file is a shortcut plus the gutter ▶ that Zed shows on entry points.

---

## 🎨 Crooli Dark

A near-black UI with neutral greys and a soft blue accent. Code uses the same syntax palette as VS Code's Dark+, so it looks familiar if you're coming from VS Code.

| Role | Colour |
| --- | --- |
| Background | `#0a0a0a` |
| Panels / surfaces | `#111111` – `#1c1c1c` |
| Text | `#ededed` |
| Accent | `#52a8ff` |
| Error / success | `#ff6b5e` / `#3fcf75` |

Syntax: keywords **blue**, strings **orange-brown**, comments **green**, functions **yellow**, types **teal**, variables **light blue**.

**Install**

```bash
mkdir -p ~/.config/zed/themes
cp themes/crooli.json ~/.config/zed/themes/
```

Then run **theme selector: toggle** from the command palette (`⌘ ⇧ P`) and pick **Crooli Dark**, or set it in `settings.json`:

```json
"theme": "Crooli Dark"
```

Optional fonts (macOS), see [`settings.snippet.json`](settings.snippet.json):

```json
"ui_font_family": ".SystemUIFont",
"buffer_font_family": "SF Mono",
"buffer_font_fallbacks": ["Menlo"]
```

---

## ▶️ Run file

Press **`⌘ ⌃ R`** and the file you have open runs in Zed's terminal panel. The script picks the right command from the file extension.

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

## Files

```text
├── themes/crooli.json        the theme
├── run/run-file.sh           the run-any-file script
├── run/tasks.snippet.json    task for tasks.json
├── keymap.snippet.json       key bindings (run + git panel)
└── settings.snippet.json     theme + font settings
```

Zed config lives in `~/.config/zed/`. Snippets are meant to be merged into your own files, not replace them. Tested on Zed 1.27 on macOS.

## License

MIT
