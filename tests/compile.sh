#!/usr/bin/env sh
set -eu

root=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
out=${TMPDIR:-/tmp}/letter-c6-tests
mkdir -p "$out"

typst compile --root "$root" "$root/template/main.typ" "$out/letter.pdf"
typst compile --root "$root" "$root/tests/assertions.typ" "$out/assertions.pdf"
typst compile --root "$root" "$root/tests/signature-image.typ" "$out/signature-image.pdf"

if typst compile --root "$root" "$root/tests/invalid-line.typ" "$out/invalid-line.pdf" 2>"$out/invalid-line.log"; then
  printf 'Expected multi-line address field compilation to fail.\n' >&2
  exit 1
fi
rg -q 'must contain exactly one line' "$out/invalid-line.log"

printf 'Compiled letter and signature example; valid and invalid address checks passed.\n'
