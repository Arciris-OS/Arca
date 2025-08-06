
#!/bin/bash
set -e

# ビルド対象ディレクトリ一覧
modules=(
  "arca-backgrounds"
  "arca-control-center"
  "arca-session"
  "arca-settings-daemon"
  "arca-shell"
  "mutter"
)


for module in "${modules[@]}"; do
  echo "==== Building $module ===="
  cd "$module"
  if [ ! -d build ] || [ ! -f build/build.ninja ]; then
    rm -rf build
    ~/.local/bin/meson setup build
  fi
  ninja -C build
  cd ..
done

echo "All modules built successfully."
