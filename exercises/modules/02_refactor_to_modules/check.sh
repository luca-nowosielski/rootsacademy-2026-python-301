#!/usr/bin/env bash
# Reports whether the exercise is solved. Safe to run as often as you like.
# This can't grade design, only behavior — see TASK.md.
set -uo pipefail
cd "$(dirname "$0")"
source ../_lib.sh

output="$(python3 main.py 2>&1)"
if [[ "$output" == "$(cat expected_output.txt)" ]]; then
    pass "main.py still prints the same invoice"
else
    fail "output changed — a refactor should not change behavior"
    diff <(echo "$output") expected_output.txt
fi

py_files="$(find . -name '*.py' | wc -l | tr -d ' ')"
[[ "$py_files" -gt 1 ]] && pass "the code is split across more than one file" \
    || fail "everything is still in main.py — pull the data model and invoice logic into their own modules"

main_lines="$(grep -cve '^[[:space:]]*$' main.py)"
[[ "$main_lines" -le 25 ]] && pass "main.py reads like a thin entry point ($main_lines non-blank lines)" \
    || fail "main.py is still $main_lines non-blank lines long — move logic out into the modules you created"

grep -rq '^class ' --include='*.py' . && pass "at least one class models part of the domain" \
    || fail "no class definition found — LineItem and Invoice belong in TASK.md's goal for a reason"

report "That's both — compare your split against ../solutions/02_refactor_to_modules/ once you're done."
