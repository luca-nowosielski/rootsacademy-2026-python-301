#!/usr/bin/env bash
# Reports whether the exercise is solved. Safe to run as often as you like.
set -uo pipefail
cd "$(dirname "$0")"
source ../_lib.sh

grep -q '\[tool.uv.sources\]' pyproject.toml && pass "pyproject.toml has a [tool.uv.sources] table" \
    || fail "no [tool.uv.sources] table — uv add --editable ./vendor/textkit-stats"

if uv sync --quiet >/tmp/textkit-sync.log 2>&1; then
    pass "uv sync succeeds"
else
    fail "uv sync fails"
    cat /tmp/textkit-sync.log
fi

output="$(uv run --quiet textkit "Hello World" 2>&1)"
grep -q 'hello-world' <<< "$output" && pass "uv run textkit prints the slug (click is declared)" \
    || fail "uv run textkit failed: $output"
grep -qi 'avg word length' <<< "$output" && pass "uv run textkit prints the stat (textkit-stats resolves)" \
    || fail "the stats line is missing: $output"

if uv run --quiet pytest -q >/tmp/textkit-pytest.log 2>&1; then
    pass "uv run pytest passes (pytest is a dev dependency)"
else
    fail "uv run pytest failed"
    cat /tmp/textkit-pytest.log
fi

report "Next: ../04_mypy"
