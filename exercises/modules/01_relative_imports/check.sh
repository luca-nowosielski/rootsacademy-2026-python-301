#!/usr/bin/env bash
# Reports whether the exercise is solved. Safe to run as often as you like.
set -uo pipefail
cd "$(dirname "$0")"
source ../_lib.sh

output="$(python3 main.py 2>&1)"
expected=$'Hello, Ada!\nBONJOUR, GRACE!!!'

if [[ "$output" == "$expected" ]]; then
    pass "main.py prints both greetings correctly"
else
    fail "main.py did not produce the expected output"
    echo "$output"
fi

report "Next: ../02_refactor_to_modules"
