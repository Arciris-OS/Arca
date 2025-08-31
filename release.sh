#!/bin/bash

set -e

targets=("Arca" "Arca-Dark-nord" "Arca-Light-nord" "dock")
outdir="tmp"
mkdir -p "$outdir"

for dir in "${targets[@]}"; do
    if [ -d "$dir" ]; then
        tar -cJf "$outdir/${dir}.tar.xz" "$dir"
        echo "$dir を $outdir/${dir}.tar.xz に圧縮しました"

        verify_toml="${dir}/verify.toml"
        : > "$verify_toml"

        for file in "$dir/usr/bin/"*; do
            [ -f "$file" ] || continue
            sha256=$(sha256sum "$file" | awk '{print $1}')
            md5=$(md5sum "$file" | awk '{print $1}')
            blake3=$(b3sum "$file" | awk '{print $1}')

            cat >> "$verify_toml" <<EOF

[[verify]]
file = "$(basename "$file")"
sha256 = "$sha256"
blake3 = "$blake3"
md5    = "$md5"
EOF
        done
        echo "$verify_toml を生成しました"
    else
        echo "ディレクトリ $dir が存在しません。スキップします。"
    fi
done