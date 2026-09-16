# Exercise 4: mypy, configured in pyproject.toml

`textkit/core.py` and `textkit/cli.py` have real type errors — not style
nits, bugs. Find them with mypy instead of at runtime.

**Goal**

- `mypy` is a dev dependency.
- `pyproject.toml` has a `[tool.mypy]` table that turns on, at minimum,
  `disallow_untyped_defs` (every function must be annotated — no exceptions,
  no partial credit) and `warn_return_any`.
- `uv run mypy textkit` reports zero errors.
- `uv run pytest` still passes — fixing types must not change behaviour.

**Commands you'll want**

```console
$ uv add --dev mypy
$ uv run mypy textkit
```

Check with `./check.sh`.

There are five errors, each a different category. Fix them one at a time and
re-run mypy after each — don't try to read all five error messages at once
and patch blind.

Two are worth a second look once you're done:

- The `limit: int = None` default. mypy rejects it even with no extra config
  — a `None` default makes the real type `int | None`, and the annotation
  has to say so.
- The call in `cli.py`. mypy caught this one *at the call site*, not inside
  the function it's calling. That's the difference between a type checker
  and a test: it checks every call, not just the ones you thought to test.

The other line in `cli.py`, the one calling `textkit_stats.average_word_length`,
is already clean — that's not an accident either. `vendor/textkit-stats/`
ships a `py.typed` marker file, which is what tells mypy "trust this
package's own annotations." Without it, mypy would refuse to check calls
into it at all and flag the import instead.
