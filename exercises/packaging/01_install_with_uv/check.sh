#!/usr/bin/env bash
# Reports whether the exercise is solved. Safe to run as often as you like.
set -uo pipefail
cd "$(dirname "$0")"
source ../_lib.sh

[[ -f pyproject.toml ]] && pass "pyproject.toml exists" || fail "no pyproject.toml — run: uv init --vcs none --no-readme --name packages-demo ."
[[ -f .python-version ]] && pass ".python-version exists" || fail "no .python-version — uv init should have created one"

grep -q 'cowsay' pyproject.toml 2>/dev/null && pass "cowsay is a declared dependency" \
    || fail "cowsay is not in pyproject.toml's dependencies — uv add cowsay"

[[ -f uv.lock ]] && pass "uv.lock exists" || fail "no uv.lock — run: uv add cowsay (or: uv lock)"

output="$(uv run --quiet main.py 2>&1)"
grep -qi 'cowsay\|moo\|(oo)' <<< "$output" && pass "uv run main.py uses cowsay" \
    || fail "uv run main.py didn't look like cowsay output: $output"

report "Next: ../02_build_a_wheel"
