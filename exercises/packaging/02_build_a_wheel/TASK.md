# Exercise 2: build a package (wheel)

`textkit` is a tiny package: `slugify`, `titleize`, `word_count`, plus a demo
script and a test. Build it.

```console
$ uv build
```

That fails. Read the error — it tells you exactly what's missing and links
to the docs for it. The short version: the project is called `text-kit`, but
the importable code lives in a directory called `textkit`. That's normal —
PyPI names commonly use hyphens, and a hyphen can't appear in a Python
import — but the build backend (`hatchling`) guesses which directory to ship
from the project name, and the guess fails when the two don't line up.

**Goal**

- `uv build` succeeds and produces both a wheel and an sdist in `dist/`.
- The wheel contains `textkit/`'s code — nothing from `scripts/` or `tests/`.
- Installed into a fresh environment, `import textkit` works from *outside*
  this directory, using only what's in the wheel.

**Steps**

1. Fix `pyproject.toml` so `uv build` succeeds without renaming anything.
   The error message names the config table you need.
2. Confirm what actually shipped:
   ```console
   $ unzip -l dist/*.whl
   ```
3. Prove it installs and works standalone:
   ```console
   $ uv venv /tmp/textkit-check
   $ uv pip install --python /tmp/textkit-check dist/*.whl
   $ cd /tmp && /tmp/textkit-check/bin/python -c "import textkit; print(textkit.slugify('It works'))"
   ```

Check with `./check.sh`.
