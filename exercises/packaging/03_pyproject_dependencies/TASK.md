# Exercise 3: dependencies in pyproject.toml

`textkit` now has a CLI, built on `click`, wired up as a `[project.scripts]`
entry point. It also reports a stat computed by `textkit_stats` — a second,
tiny package that lives right here in `vendor/textkit-stats/`, not on PyPI.
And there's a test in `tests/`. Try any of these:

```console
$ uv run textkit "Hello World"
$ uv sync
$ uv run pytest
```

All three fail, for three different reasons — none of them a code bug.
`dependencies = []` says this package needs nothing to run, which isn't
true twice over, and there's no dev dependency group at all.

**Goal**

- `click` is a declared runtime dependency.
- `textkit-stats` is a declared runtime dependency too — but `uv add` alone
  won't be enough for this one; read on.
- `pytest` is a *dev* dependency: needed to work on this package, not to
  use it, and never shipped in the wheel.
- `uv run textkit "Hello World"` prints the slug and the stat line.
- `uv run pytest` passes.

**Commands you'll want**

```console
$ uv add click
$ uv add --editable ./vendor/textkit-stats
$ uv add --dev pytest
```

Check with `./check.sh`.

**The interesting one is the second command.** `textkit-stats` isn't on
PyPI — plain `uv add textkit-stats` would try to fetch it from there and
fail with "not found in the package registry". `--editable ./vendor/...`
adds it as a dependency *and* writes a `[tool.uv.sources]` entry that tells
uv where to actually get it: this local path, installed editable, so
changes to `vendor/textkit-stats/` show up immediately without
reinstalling. Open `pyproject.toml` after running it and read what it wrote
— that table is the uv-specific piece; there's no equivalent in a plain
`requirements.txt`. `[tool.uv.sources]` also accepts a `git = "..."` URL the
same way, for a dependency that lives in another repo but isn't published
either.

Then open `pyproject.toml` in full and look at where each of the three
commands wrote. `click` and `textkit-stats` go into `[project]
dependencies` — real requirements, shipped with the package. `pytest` goes
into a separate `[dependency-groups]` table — needed to work on the repo,
never shipped. `uv sync` installs both by default because you're developing
the project; `pip install text-kit` only ever pulls in the first two.

**Two more `[tool.uv]` knobs worth knowing, not needed here:**
`default-groups` controls which dependency groups `uv sync` installs
without being asked — by default that's just `dev`, so a second group
(say, `docs`) would need `uv sync --group docs` unless you list it there
too. `[[tool.uv.index]]` points uv at a private package index instead of
PyPI, for packages that are real releases, just not public ones — the
alternative to `[tool.uv.sources]`'s path/git entries for something one-off
like this vendored helper.
