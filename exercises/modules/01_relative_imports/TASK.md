# Exercise 1: packages, `__init__.py`, and relative imports

`greetings/` is a small package, already split into two subpackages:
`greetings/langs/` (one module per language) and `greetings/formatting/`
(text styling, used by more than one language). Every directory that's a
package has an `__init__.py` — that's what tells Python "this is a
package," as opposed to just a folder of scripts.

```console
$ python3 main.py
```

That fails. Read the traceback — it names the exact import that's broken.

**Goal**

- `python3 main.py` runs and prints two greetings.
- `greetings/__init__.py` re-exports `greet`, so callers can do
  `from greetings import greet` instead of reaching into `greetings.core`.
- `greetings/langs/french.py` imports `shout` from `greetings/formatting/`
  using the correct number of dots.

**Steps**

1. `greetings/__init__.py` is empty. `main.py` does
   `from greetings import greet` — for that to work, something in
   `greetings/__init__.py` has to make `greet` available at the package's
   top level. Add the import that does that.
2. Run `python3 main.py` again. You'll hit a second error, inside
   `greetings/langs/french.py`. It imports from `formatting`, but
   `formatting` isn't inside `langs` — it's a sibling package, one level
   up. One `.` means "this package"; `..` means "go up one level, then
   back down." Fix the import.

Check with `./check.sh`.

**Before moving on**, look at two things:

- `greetings/langs/__init__.py` and `greetings/formatting/__init__.py` are
  both empty, and that's fine — a package's `__init__.py` doesn't have to
  export anything. `greetings/__init__.py` re-exporting `greet` is a
  choice, made because `greet` is the one name this package wants to
  expose. `main.py` importing straight from `greetings.core` would work
  too; it would just mean every caller needs to know the internal layout.
- Relative imports (`.` / `..`) only make sense *inside* a package.
  `main.py` imports `greetings` the normal, absolute way — a script you run
  directly isn't part of a package itself.
