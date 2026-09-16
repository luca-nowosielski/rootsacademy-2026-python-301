# Exercise 5: ruff, configured in pyproject.toml

`textkit/core.py` and `textkit/cli.py` picked up a handful of lint issues.
Right now `pyproject.toml` has no `[tool.ruff]` table at all, so ruff is
running on whatever its own defaults happen to be this week. Fix that first.

**Goal**

- `ruff` is a dev dependency.
- `pyproject.toml` has a `[tool.ruff]` table with an explicit `line-length`
  and `target-version` (match `requires-python`), and a `[tool.ruff.lint]`
  table that explicitly `select`s rule families — at minimum `E`
  (pycodestyle), `F` (pyflakes, unused imports/names), `I` (import
  sorting), `UP` (modern syntax) and `B` (bugbear, common bug patterns).
  Pin the rule set on purpose; don't inherit whatever ruff defaults to.
- `uv run ruff check .` is clean.
- `uv run ruff format --check .` is clean.
- `uv run mypy textkit` and `uv run pytest` still pass — a lint pass that
  breaks types or tests is not a lint pass.

**Commands you'll want**

```console
$ uv add --dev ruff
$ uv run ruff check .
```

Run that last command before changing anything. One of the findings is
*outside* `textkit/` — in `vendor/textkit-stats/`, the local package from
exercise 3. Don't fix it there. That code isn't yours to restyle every time
you touch this repo, and "vendored code we don't own the style of" is
exactly what `[tool.ruff] extend-exclude` is for. Add
`extend-exclude = ["vendor"]` and confirm the finding disappears — the file
itself should be untouched.

**Read before you `--fix`** on what's left, inside `textkit/`. `ruff check
--fix .` only applies fixes ruff considers safe — you'll see one unused
import disappear. The rest stay, and `--fix` will tell you they're
available only behind `--unsafe-fixes`. Don't reach for that flag; fix the
remaining findings by hand instead, so you actually read what ruff is
telling you rather than trusting it blind. One of them (a mutable default
argument) has no autofix at all, safe or not — it needs you to change how
the function is called, not just its syntax.

Check with `./check.sh`.

**Last step:** add `[tool.ruff.format]` with `quote-style = "double"` (or
`"single"`, your call — just pick one on purpose), then run
`uv run ruff format .`. Same reasoning as pinning `select`: an explicit
choice that survives a ruff upgrade, instead of whatever the formatter
defaults to this year.
