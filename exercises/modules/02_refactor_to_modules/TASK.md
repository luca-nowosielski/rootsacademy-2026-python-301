# Exercise 2: from script to modules and classes

`main.py` prints an invoice. It works — run it:

```console
$ python3 main.py
```

But it's a script that grew: one file, a handful of module-level functions,
plain dicts passed around instead of a real data model, and formatting
logic tangled up with business logic (the bulk discount) and printing.
That's normal for something that started small. It's also exactly the kind
of code that gets hard to change once it stops being small — add a second
tax rate, or a second output format, and you're editing the same functions
that print the header and the total.

**Goal**

Rewrite this into a small package, without changing what it prints:

- The order data (name, quantity, unit price) becomes a `LineItem` class —
  something with its own `total` (quantity × price, minus the bulk
  discount) instead of a free function that takes a dict apart.
- An `Invoice` class holds a list of line items and knows how to compute
  its own subtotal, tax, and total.
- The code is split into more than one file — for example, a module for
  the data model and one for the invoice/report logic — inside a package
  you create (a directory with an `__init__.py`, the way `greetings/` was
  built in the previous exercise).
- `main.py` shrinks to a handful of lines: build the data, hand it to your
  classes, print the result. No business logic left in it.
- `python3 main.py` prints **exactly** the same invoice as before.

**Why classes here**

`line_total(order)` has to be told what an order is — a dict, and only by
convention (`order["qty"]`, `order["unit_price"]`, nothing enforcing that
shape). A `LineItem` class ties the data and the one calculation that only
makes sense for that data into a single thing. That's the difference
between "a function that happens to operate on this shape of dict" and "a
type that owns its own behavior" — the core idea behind encapsulation.

**Why modules here**

Once `LineItem` and `Invoice` exist, they don't need to live in the same
file as `main.py`, and they shouldn't: `main.py` is the entry point (read
data, wire objects together, print), the rest is the domain logic that
entry point depends on. Separating them means you can change how an
invoice is rendered without touching how it's assembled, and test one
without importing the other's `if __name__ == "__main__":` block.

Check with `./check.sh` — it verifies the output is unchanged and that you
actually split the code up. It can't check whether your specific classes
and modules are well designed; there's more than one reasonable split.
Once you're done, compare against `../solutions/02_refactor_to_modules/`,
which is *a* solution, not *the* solution.
