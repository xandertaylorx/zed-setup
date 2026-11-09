#!/bin/sh
# Run the current file based on its extension (like VS Code's Run button).
f="$1"
[ -z "$f" ] && { echo "No file open"; exit 1; }
dir=$(dirname "$f")
base=$(basename "$f")
stem="${base%.*}"
ext="${base##*.}"
out="${TMPDIR:-/tmp}/zed-run-$stem"

case "$ext" in
  py)    python3 "$f" ;;
  js|mjs|cjs) node "$f" ;;
  ts|tsx) npx --yes tsx "$f" ;;
  java)
    mkdir -p bin
    find . -name '*.java' -not -path './bin/*' -print0 | xargs -0 javac -d bin && java -cp bin "$stem" ;;
  rs)
    if [ -f Cargo.toml ]; then cargo run; else rustc "$f" -o "$out" && "$out"; fi ;;
  go)    go run "$f" ;;
  c)     clang "$f" -o "$out" && "$out" ;;
  cpp|cc|cxx) clang++ -std=c++17 "$f" -o "$out" && "$out" ;;
  swift) swift "$f" ;;
  rb)    ruby "$f" ;;
  php)   php "$f" ;;
  lua)   lua "$f" ;;
  sh|zsh) zsh "$f" ;;
  kt)    kotlinc "$f" -include-runtime -d "$out.jar" && java -jar "$out.jar" ;;
  html)  open "$f" ;;
  *)     echo "No run command set for .$ext files (edit ~/.config/zed/run-file.sh)"; exit 1 ;;
esac
