# Crooli Dark for Zed

A near-black dark theme for [Zed](https://zed.dev), with a neutral grey UI and a soft blue accent. Code is coloured with the same syntax palette as VS Code's Dark+ theme, so it should feel familiar if you're coming from VS Code.

## Colours

| Role | Colour |
| --- | --- |
| Background | `#0a0a0a` |
| Panels / surfaces | `#111111` – `#1c1c1c` |
| Text | `#ededed` |
| Accent | `#52a8ff` |
| Error / success | `#ff6b5e` / `#3fcf75` |

Syntax colours follow Dark+: keywords blue, strings orange-brown, comments green, functions yellow, types teal, variables light blue.

## Install

Zed loads any theme file placed in `~/.config/zed/themes/`.

```bash
git clone https://github.com/xandertaylorx/zed-crooli-theme.git
mkdir -p ~/.config/zed/themes
cp zed-crooli-theme/themes/crooli.json ~/.config/zed/themes/
```

Then pick the theme in Zed:

- Open the command palette (`cmd-shift-p`), run **theme selector: toggle**, and choose **Crooli Dark**.
- Or add this to your `settings.json` (`cmd-,`):

```json
"theme": "Crooli Dark"
```

If it doesn't show up straight away, restart Zed.

## Optional: fonts

The theme doesn't set fonts. For a clean look similar to the original, add to `settings.json`:

```json
"ui_font_family": ".SystemUIFont",
"buffer_font_family": "SF Mono",
"buffer_font_fallbacks": ["Menlo"]
```

See [`settings.snippet.json`](settings.snippet.json). These are macOS fonts, so use your own on other systems.

## Optional: `cmd-g` toggles the Git panel

Add the binding from [`keymap.snippet.json`](keymap.snippet.json) to your `keymap.json` (command palette → **zed: open keymap file**). Pressing `cmd-g` then opens the Git panel if it's closed and closes it if it's open.

Note that `cmd-g` is also "find next" while a search bar is open, and that takes priority in that case.

## Customising

Edit `~/.config/zed/themes/crooli.json`. Zed reloads theme files as you save. Colours are plain hex values, and syntax colours live under `"syntax"`.

## License

MIT
