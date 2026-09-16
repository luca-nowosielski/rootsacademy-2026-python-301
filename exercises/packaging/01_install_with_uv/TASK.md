# Exercise 1: install packages with uv

This directory is empty except for this file and the checker — you're
starting a project from nothing, the way you would for real. Everything
goes through `uv`; there is no `pip install` or `python -m venv` anywhere in
this exercise, and none anywhere else in this course either. That's
deliberate: `uv` owns the environment, and a `pyproject.toml` is what
records what your project needs, not a requirements file or your shell
history.

**Goal**

- A project here, scaffolded by `uv init` — a `pyproject.toml` with a
  `[project]` table, and a `.python-version` pinning the interpreter.
- `cowsay` added as a real, declared dependency (check `pyproject.toml`
  after you add it — it should be right there in `dependencies`).
- `uv.lock` present — the exact, resolved versions of everything, meant to
  be committed.
- `main.py` uses `cowsay` to print a message, and `uv run main.py` works.

**Steps**

```console
$ uv init --vcs none --no-readme --name packages-demo .
$ uv add cowsay
```

Edit the generated `main.py` so `main()` calls `cowsay.cow("...")` with a
message of your choice, instead of the default `print`. Then:

```console
$ uv run main.py
```

Check with `./check.sh`.

**Before moving on**, look at three things:

- `uv.lock` versus `pyproject.toml`. The lock file is what actually gets
  installed — exact versions, every transitive dependency, hashes. The
  `pyproject.toml` is what you asked for; the lock is what you got. Commit
  both.
- `uv run` reads `pyproject.toml`, checks whether `.venv` matches
  `uv.lock`, syncs it if not, and only then runs your command. You never
  have to think about "did I activate the right environment" — there's
  nothing to activate.
- `.python-version`. It pins the interpreter the same way `uv.lock` pins
  dependencies — so `uv run` gets the same Python everywhere, not whatever
  happens to be first on `$PATH`.
