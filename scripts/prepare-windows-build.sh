#!/usr/bin/env bash
set -euo pipefail

# DuckDB's prebuilt Windows archive uses the Universal C Runtime.
gcc_dir="$(cygpath -u "$MSYS2_LOCATION")/ucrt64/bin"
test -f "$gcc_dir/gcc.exe"
cygpath -w "$gcc_dir" >> "$GITHUB_PATH"

# sqlite-vec expects sqlite3.h. Use the header from the same Go module
# that compiles the SQLite implementation into the binary.
go mod download github.com/mattn/go-sqlite3
sqlite_module="$(cygpath -u "$(go list -m -f '{{.Dir}}' github.com/mattn/go-sqlite3)")"
include_dir="$(cygpath -u "$RUNNER_TEMP")/weknora-sqlite-headers"
mkdir -p "$include_dir"
cp "$sqlite_module/sqlite3-binding.h" "$include_dir/sqlite3.h"
printf 'CGO_CPPFLAGS=-I "%s"\n' "$(cygpath -m "$include_dir")" >> "$GITHUB_ENV"
