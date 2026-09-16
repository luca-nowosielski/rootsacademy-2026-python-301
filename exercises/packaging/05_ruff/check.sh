#!/usr/bin/env bash
# Reports whether the exercise is solved. Safe to run as often as you like.
set -uo pipefail
cd "$(dirname "$0")"
source ../_lib.sh

grep -q '\[tool.ruff\]' pyproject.toml && pass "pyproject.toml has a [tool.ruff] table" \
    || fail "no [tool.ruff] table in pyproject.toml"
grep -q 'target-version' pyproject.toml && pass "target-version is set" \
    || fail "add target-version under [tool.ruff]"
grep -q 'extend-exclude' pyproject.toml && pass "extend-exclude is set" \
    || fail "add extend-exclude = [\"vendor\"] under [tool.ruff] — don't lint code you don't own"
grep -q '\[tool.ruff.lint\]' pyproject.toml && pass "pyproject.toml has a [tool.ruff.lint] table with an explicit select" \
    || fail "no [tool.ruff.lint] table — the rule set is whatever ruff defaults to"
grep -q '\[tool.ruff.format\]' pyproject.toml && pass "pyproject.toml has a [tool.ruff.format] table" \
    || fail "no [tool.ruff.format] table — pin a quote-style"

grep -q 'import sys' vendor/textkit-stats/textkit_stats/stats.py 2>/dev/null \
    && pass "vendor/ was excluded, not hand-edited" \
    || fail "vendor/textkit-stats/textkit_stats/stats.py changed — exclude it instead of fixing it"

if uv run --quiet ruff check . >/tmp/textkit-ruff-check.log 2>&1; then
    pass "ruff check is clean"
else
    fail "ruff check still finds something"
    cat /tmp/textkit-ruff-check.log
fi

if uv run --quiet ruff format --check . >/tmp/textkit-ruff-format.log 2>&1; then
    pass "ruff format --check is clean"
else
    fail "ruff format would still change something — run: uv run ruff format ."
    cat /tmp/textkit-ruff-format.log
fi

if uv run --quiet mypy textkit >/tmp/textkit-mypy.log 2>&1; then
    pass "mypy is still clean"
else
    fail "mypy broke while you were fixing lint"
    cat /tmp/textkit-mypy.log
fi

if uv run --quiet pytest -q >/tmp/textkit-pytest.log 2>&1; then
    pass "uv run pytest still passes"
else
    fail "pytest broke while you were fixing lint"
    cat /tmp/textkit-pytest.log
fi

report "That's all five — see ../README.md for what each one taught."
