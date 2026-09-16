#!/usr/bin/env bash
# Reports whether the exercise is solved. Safe to run as often as you like —
# it rebuilds dist/ and throws away the scratch venv it creates.
set -uo pipefail
cd "$(dirname "$0")"
source ../_lib.sh

rm -rf dist
if uv build --quiet >/tmp/textkit-build.log 2>&1; then
    pass "uv build succeeds"
else
    fail "uv build fails — see the hint in TASK.md"
    cat /tmp/textkit-build.log
fi

wheel="$(ls dist/*.whl 2>/dev/null | head -n1)"
if [[ -n "$wheel" ]]; then
    contents="$(unzip -l "$wheel" 2>/dev/null)"
    grep -q "textkit/core.py" <<< "$contents" && pass "the wheel contains textkit's code" || fail "textkit/core.py is not in the wheel"
    grep -q "scripts/" <<< "$contents" && fail "the wheel also ships scripts/ — scope the fix to textkit/" || pass "scripts/ is not in the wheel"
    grep -q " tests/" <<< "$contents" && fail "the wheel also ships tests/ — scope the fix to textkit/" || pass "tests/ is not in the wheel"
else
    fail "no wheel in dist/"
fi

scratch="$(mktemp -d)"
if [[ -n "$wheel" ]] && uv venv --quiet "$scratch/venv" >/dev/null 2>&1 \
    && uv pip install --quiet --python "$scratch/venv" "$wheel" >/dev/null 2>&1; then
    output="$(cd /tmp && "$scratch/venv/bin/python" -c "import textkit; print(textkit.slugify('It works'))" 2>&1)"
    [[ "$output" == "it-works" ]] && pass "the installed wheel works from outside this directory" \
        || fail "importing the installed wheel failed: $output"
else
    fail "could not install the wheel into a fresh environment"
fi
rm -rf "$scratch"

report "Next: ../03_pyproject_dependencies"
