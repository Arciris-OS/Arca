#!/bin/bash

set -e

targets=("Arca" "Arca-Dark-nord" "Arca-Light-nord" "dock" "bg")
outdir="tmp"
mkdir -p "$outdir"

for dir in "${targets[@]}"; do
    if [ -d "$dir" ]; then
        verify_toml="${dir}/verify.toml"
        > "$verify_toml"

        bin_dir="$dir/data"
        if [ -d "$bin_dir" ] && compgen -G "$bin_dir/*" > /dev/null; then
            for file in "$bin_dir/"*; do
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
            echo "$bin_dir が存在しないか、ファイルがありません。verify.toml は空です。"
        fi

        tar -cJf "$outdir/${dir}.tar.xz" "$dir"
        echo "$dir を $outdir/${dir}.tar.xz に圧縮しました"
    else
        echo "ディレクトリ $dir が存在しません。スキップします。"
    fi
done