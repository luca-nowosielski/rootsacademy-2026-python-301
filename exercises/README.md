# Exercises

Self-checking, one topic per numbered directory. Each has a `TASK.md`
describing the goal and a `./check.sh` that tells you when you've met it —
run it as often as you like.

Unlike the git drills in 101, nothing here is destructive. If you make a
mess, fix it by hand or copy the file back from `solutions/`.

## Modules

```console
$ cd exercises/modules/01_relative_imports
$ cat TASK.md
$ ./check.sh
```

Two exercises, no `uv` needed — plain `python3`. They're about structuring
code, not tooling, and come before Packaging on purpose: the packaging
exercises already assume you can read a package layout.

| | |
|---|---|
| `01_relative_imports/` | a small nested package with a couple of bugs — `__init__.py` re-exports, `.` vs `..` in relative imports |
| `02_refactor_to_modules/` | take a working single-file script and rewrite it as a package: classes instead of dicts, one module per concern |

`02_refactor_to_modules` only checks behavior (same output) and a couple of
structural signals (more than one file, at least one class) — it can't
grade design, and there's more than one reasonable split. Compare your
answer against `solutions/02_refactor_to_modules/` once you're done.

## Packaging

```console
$ cd exercises/packaging/01_install_with_uv
$ cat TASK.md
$ ./check.sh
```

Five exercises, and they build on each other: 2 through 5 all work on the
same small package, `textkit`, adding one real-world wrinkle at a time. Do
them in order.

| | |
|---|---|
| `01_install_with_uv/` | `uv init` / `uv add` / `uv run` — no `pip`, no `venv` |
| `02_build_a_wheel/` | package layout, and why `uv build` needs to agree with it |
| `03_pyproject_dependencies/` | runtime vs. dev deps, plus a local path dependency via `[tool.uv.sources]` |
| `04_mypy/` | five real type errors, `[tool.mypy]` |
| `05_ruff/` | lint findings, `extend-exclude`, `[tool.ruff]` / `[tool.ruff.lint]` / `[tool.ruff.format]` |

Nothing here goes through `pip` or `python -m venv` — `uv` owns the
environment throughout, the way you'd actually run a project. Exercise 3
also introduces `vendor/textkit-stats`, a second, tiny local package that
`textkit` depends on but that isn't on PyPI — the running example for
`[tool.uv.sources]`, and it stays in the project for exercises 4 and 5 too
(exercise 5 specifically uses it to motivate `extend-exclude`, for code you
don't want to lint because you don't own its style).

Each exercise's starting state has a real bug planted in it — a build that
fails, a missing dependency, type errors, lint findings. That's the point,
not an accident. Read the error message before you read `TASK.md`; the
Python tooling ecosystem is generally good about telling you what's wrong.

Reference solutions: `exercises/packaging/solutions/`. Look after you've
tried, not before.

**Requires network** the first time each exercise resolves packages (`uv`
downloads from PyPI). Once the wheels are cached locally, re-running a
`check.sh` does not need it again.

## Prerequisites

```console
$ uv --version
$ python3 --version    # 3.11+
```

`uv` installs everything else — you do not need a system-wide `mypy` or
`ruff`.
