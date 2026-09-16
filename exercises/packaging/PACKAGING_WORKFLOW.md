# Packaging Python projects with uv

Summary of the workflow in `exercises/packaging/`: turning a folder of code
into a proper installable/distributable Python package using `uv`, plus
type-checking and linting it. Based on the five exercises here.

## 1. Scaffold and manage the environment with `uv` (ex. 1)

No `pip install` or `python -m venv` anywhere in this course — `uv` owns
the environment end-to-end.

```console
$ uv init --vcs none --no-readme --name packages-demo .
$ uv add cowsay
$ uv run main.py
```

- `uv init` creates `pyproject.toml` (a `[project]` table) and
  `.python-version` (pins the interpreter).
- `uv add <pkg>` records a real dependency in `pyproject.toml` **and**
  resolves exact versions into `uv.lock` (commit both — `pyproject.toml`
  is what you asked for, `uv.lock` is what you got).
- `uv run <script>` syncs `.venv` to match `uv.lock` if needed, then runs —
  no manual "activate the venv" step ever.

## 2. Make it buildable: the wheel (ex. 2)

```console
$ uv build
```

This needs `[build-system]` in `pyproject.toml`:

```toml
[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"
```

The build backend (`hatchling`) guesses the importable directory from the
project name. If the PyPI name uses a hyphen (`text-kit`) but the code
directory doesn't match (`textkit/`), add:

```toml
[tool.hatch.build.targets.wheel]
packages = ["textkit"]
```

`uv build` then produces a wheel + sdist in `dist/`, containing only
`textkit/` — not `scripts/` or `tests/`.

## 3. Declare dependencies correctly (ex. 3)

```console
$ uv add click                                  # runtime dependency
$ uv add --editable ./vendor/textkit-stats      # local, unpublished dependency
$ uv add --dev pytest                           # dev-only dependency
```

- Runtime deps (`click`, `textkit-stats`) go in `[project] dependencies` —
  shipped with the package.
- `--editable ./local/path` also writes a `[tool.uv.sources]` entry
  pointing uv at that path (or a `git = "..."` URL) instead of PyPI —
  needed for anything not published.
- Dev-only tools (`pytest`) go in `[dependency-groups] dev` — installed by
  `uv sync`, never shipped in the wheel.
- A CLI entry point is declared once, under `[project.scripts]`:

```toml
[project.scripts]
textkit = "textkit.cli:main"
```

## 4. Type-check with mypy, configured in `pyproject.toml` (ex. 4)

```console
$ uv add --dev mypy
$ uv run mypy textkit
```

```toml
[tool.mypy]
warn_return_any = true
disallow_untyped_defs = true   # every function must be annotated
```

A package that ships its own types marks that with an empty `py.typed`
file (see `vendor/textkit-stats/`) — that's what lets mypy trust calls
into it instead of refusing to check them.

## 5. Lint and format with ruff, configured in `pyproject.toml` (ex. 5)

```console
$ uv add --dev ruff
$ uv run ruff check .
$ uv run ruff format .
```

```toml
[tool.ruff]
line-length = 100
target-version = "py311"
extend-exclude = ["vendor"]     # don't restyle code you don't own

[tool.ruff.lint]
select = ["E", "F", "I", "UP", "B"]

[tool.ruff.format]
quote-style = "double"
```

Pin `select` and `format` settings explicitly rather than relying on
whatever ruff defaults to — defaults change between versions. `--fix` only
applies safe fixes; the rest (and anything with no autofix, like a mutable
default argument) need a manual look.

## Checklist

1. `uv init` + `uv add` — never raw `pip`/`venv`.
2. `[build-system]` (+ `[tool.hatch...]packages` if the name doesn't match
   the directory) so `uv build` works.
3. Split dependencies: `[project] dependencies` (runtime, shipped),
   `[tool.uv.sources]` (unpublished/local/git), `[dependency-groups] dev`
   (tooling only).
4. `[tool.mypy]` with strict-ish defaults; ship `py.typed` if others import
   your package.
5. `[tool.ruff]` + `[tool.ruff.lint]` + `[tool.ruff.format]`, all pinned
   explicitly.
