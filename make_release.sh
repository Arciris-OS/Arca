#!/bin/bash
set -e


RELEASE_NAME="arca"
ARCHIVE_NAME="${RELEASE_NAME}.tar.xz"
RELEASE_ROOT="release_root"

modules=(
  "arca-backgrounds"
  "arca-control-center"
  "arca-session"
  "arca-settings-daemon"
  "arca-shell"
  "mutter"
)

echo "== Cleaning up old archive and temp =="
rm -f "$ARCHIVE_NAME"
rm -rf "$RELEASE_ROOT"
mkdir -p "$RELEASE_ROOT"


for module in "${modules[@]}"; do
  echo "==== Installing $module to $RELEASE_ROOT ===="
  cd "$module"
  if [ -d build ]; then
    ninja -C build install DESTDIR="$(realpath ../$RELEASE_ROOT)"
  else
    echo "  [WARN] build dir is not found: $module"
  fi
  cd ..
done

echo "== Creating release archive: $ARCHIVE_NAME =="
tar -C "$RELEASE_ROOT" -cJf "$ARCHIVE_NAME" .

echo "== Release archive created: $ARCHIVE_NAME =="
rm -rf "$RELEASE_ROOT"
