# Splitting Python code into modules and packages

This note walks through the workflow used in this `exercises/modules/`
folder: turning a pile of code into packages and modules, and the exact
Python mechanics needed to wire it back together with imports. It follows
the two exercises here (`01_relative_imports/`, `02_refactor_to_modules/`)
and their solutions.

## 1. Vocabulary: module vs. package

- **Module** — any single `.py` file. `greetings/core.py` is a module.
- **Package** — a directory that contains an `__init__.py` file. The
  `__init__.py` is what tells Python "treat this directory as an
  importable package," not just a folder of loose scripts. It can be
  empty — `greetings/langs/__init__.py` and `greetings/formatting/__init__.py`
  in this repo are both empty, and that's fine.
- A package can contain **subpackages** (packages nested inside packages),
  each with its own `__init__.py`. `greetings/langs/` and
  `greetings/formatting/` are subpackages of `greetings/`.

A typical shape, taken from `01_relative_imports/`:

```
greetings/
├── __init__.py
├── core.py
├── langs/
│   ├── __init__.py
│   ├── english.py
│   └── french.py
└── formatting/
    ├── __init__.py
    └── shout.py
```

## 2. The workflow for splitting a script into modules

This is the process exercise 2 (`02_refactor_to_modules/`) walks through,
starting from a single `main.py` that mixes data, business logic and
printing:

1. **Identify the seams.** Look for groups of functions/data that belong
   together conceptually — e.g. "everything about a single order line"
   vs. "everything about the invoice as a whole." In the exercise this
   became a `LineItem` concept and an `Invoice` concept.
2. **Turn loose functions + dicts into classes where it clarifies
   ownership.** `line_total(order)` operated on a plain dict with no
   guarantees about its shape. Turning it into `LineItem.total` ties the
   data (`name`, `qty`, `unit_price`) and the one calculation that only
   makes sense for that data into a single object.
3. **Create a package directory** for the new code (a folder + empty
   `__init__.py` to start), e.g. `billing/`.
4. **Split responsibilities across modules inside that package.** Here:
   `billing/models.py` (the `LineItem` data model and money formatting)
   and `billing/invoice.py` (the `Invoice` class that composes line items
   and renders the report).
5. **Re-export the public API from `__init__.py`.** So callers can do
   `from billing import Invoice, LineItem` instead of reaching into
   `billing.models` / `billing.invoice` directly:

   ```python
   # billing/__init__.py
   from .invoice import Invoice
   from .models import LineItem

   __all__ = ["Invoice", "LineItem"]
   ```

6. **Shrink the entry-point script to wiring only.** `main.py` no longer
   contains business logic — it just builds the data, hands it to the
   classes, and prints the result:

   ```python
   # main.py
   from billing import Invoice, LineItem

   ORDERS = [
       ("Hex Bolt M6", 25, 0.15),
       ("Washer M6", 25, 0.05),
   ]

   def main() -> None:
       invoice = Invoice([LineItem(*order) for order in ORDERS])
       print(invoice.render())

   if __name__ == "__main__":
       main()
   ```

7. **Verify nothing observable changed.** The whole point of a refactor is
   that behavior is identical before and after — same `python3 main.py`
   output, just reorganized code. (`check.sh` in each exercise folder
   automates this.)

## 3. The essential Python code to assemble and use the pieces

### a) `__init__.py` marks a directory as a package

Even an empty file is enough:

```python
# greetings/langs/__init__.py
```

### b) Re-exporting names at the package level

If `__init__.py` does nothing, callers must import from the submodule
directly (`from greetings.core import greet`). To offer a cleaner public
surface, import the name into `__init__.py` and list it in `__all__`:

```python
# greetings/__init__.py
from .core import greet

__all__ = ["greet"]
```

This lets callers simply write:

```python
from greetings import greet
```

`__all__` isn't required for the import to work — it documents (and
constrains `from greetings import *`) what the package considers public.

### c) Relative imports — the dots, and how many

Inside a package, modules import siblings/parents with relative imports
(`.` / `..`), never absolute paths like `greetings.formatting`:

- `.` — the current package.
- `..` — go up one level, then back down.

```python
# greetings/core.py  (imports siblings inside the same package)
from .langs import english, french
```

```python
# greetings/langs/french.py  (formatting is a SIBLING of langs, one level up)
from ..formatting.shout import shout
```

A common mistake (the bug exercise 1 asks you to fix) is writing `from
.formatting.shout import shout` inside `langs/french.py` — a single dot
looks for `formatting` *inside* `langs`, but `formatting` actually lives
next to `langs`, one level up, so it needs `..`.

Relative imports only make sense *inside* a package. The script you run
directly (`main.py`) is not itself part of a package, so it always imports
the package the normal, absolute way:

```python
# main.py
from greetings import greet
```

### d) Assembling multiple modules inside one package (`billing/` example)

```python
# billing/models.py
class LineItem:
    def __init__(self, name: str, qty: int, unit_price: float):
        self.name = name
        self.qty = qty
        self.unit_price = unit_price

    @property
    def total(self) -> float:
        ...
```

```python
# billing/invoice.py
from .models import LineItem, format_money   # relative import: same package

class Invoice:
    def __init__(self, items: list[LineItem]):
        self.items = items

    @property
    def subtotal(self) -> float:
        return sum(item.total for item in self.items)
```

```python
# billing/__init__.py
from .invoice import Invoice     # re-export for callers
from .models import LineItem

__all__ = ["Invoice", "LineItem"]
```

```python
# main.py
from billing import Invoice, LineItem   # absolute import, from outside the package
```

### e) Quick reference

| You're writing code...            | Import style                          |
|------------------------------------|----------------------------------------|
| inside a package, importing a sibling module in the *same* package | `from .module import name` |
| inside a package, importing something one level *up* | `from ..package import name` |
| in a top-level script (e.g. `main.py`), importing a package | `from package import name` (absolute) |
| in a package's `__init__.py`, re-exporting a submodule's name | `from .submodule import name` + add to `__all__` |

## 4. Checklist for splitting your own script into modules

1. Group related data + behavior; consider promoting dict-shaped data to
   a class if it has its own calculations.
2. Make a package directory with an `__init__.py`.
3. Move each group into its own module file inside that package.
4. Fix all imports to be relative (`.`/`..`) *within* the package.
5. Re-export the public names from `__init__.py` so outside code has a
   clean, single import line.
6. Reduce the original script to the thin entry point: build data, call
   into the package, print/return results.
7. Re-run and diff the output to confirm the refactor changed nothing
   observable.
