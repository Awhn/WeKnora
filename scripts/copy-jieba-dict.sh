#!/usr/bin/env bash
set -euo pipefail

dest="${1:?Usage: copy-jieba-dict.sh DESTINATION_DIRECTORY}"
go mod download github.com/yanyiwu/gojieba
module_dir="$(go list -m -f '{{.Dir}}' github.com/yanyiwu/gojieba)"
if command -v cygpath >/dev/null 2>&1; then
    module_dir="$(cygpath -u "$module_dir")"
fi
cppjieba_dir="$module_dir/deps/cppjieba"
dict_dir="$cppjieba_dir/dict"

mkdir -p "$dest/jieba-dict"
cp "$dict_dir"/{jieba.dict.utf8,hmm_model.utf8,user.dict.utf8,idf.utf8,stop_words.utf8} "$dest/jieba-dict/"
cp "$cppjieba_dir/LICENSE" "$dest/jieba-dict/LICENSE.cppjieba"
cp "$module_dir/LICENSE" "$dest/jieba-dict/LICENSE.gojieba"
