# Solution: exercise 1

```console
$ uv init --vcs none --no-readme --name packages-demo .
$ uv add cowsay
```

Then `main.py`:

```python
import cowsay


def main() -> None:
    cowsay.cow("Hello from uv!")


if __name__ == "__main__":
    main()
```

```console
$ uv run main.py
```

No `pip` or `venv` command anywhere — `uv init` scaffolds the project, `uv add`
declares and installs the dependency, `uv run` syncs `.venv` to match
`uv.lock` and runs the script.
