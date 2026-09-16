# Shared by every check.sh in this directory. Not an exercise itself.
pass() { printf '  ok    %s\n' "$1"; }
fail() { printf '  FAIL  %s\n' "$1"; FAILED=1; }
FAILED=0

report() {
    if [[ $FAILED -eq 0 ]]; then
        echo
        echo "Solved. $1"
    else
        echo
        echo "Not there yet — see TASK.md"
        exit 1
    fi
}
