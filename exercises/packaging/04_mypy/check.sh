#!/usr/bin/env bash
# Reports whether the exercise is solved. Safe to run as often as you like.
set -uo pipefail
cd "$(dirname "$0")"
source ../_lib.sh

grep -q '\[tool.mypy\]' pyproject.toml && pass "pyproject.toml has a [tool.mypy] table" \
    || fail "no [tool.mypy] table in pyproject.toml"
grep -q 'disallow_untyped_defs' pyproject.toml && pass "disallow_untyped_defs is set" \
    || fail "add disallow_untyped_defs = true under [tool.mypy]"

if uv run --quiet mypy textkit >/tmp/textkit-mypy.log 2>&1; then
    pass "mypy reports zero errors"
else
    fail "mypy still finds errors"
    cat /tmp/textkit-mypy.log
fi

if uv run --quiet pytest -q >/tmp/textkit-pytest.log 2>&1; then
    pass "uv run pytest still passes"
else
    fail "pytest broke while you were fixing types"
    cat /tmp/textkit-pytest.log
fi

report "Next: ../05_ruff"
