"""Print an invoice for a small hardware order."""

TAX_RATE = 0.21
BULK_QTY = 10
BULK_DISCOUNT = 0.1

ORDERS = [
    {"name": "Hex Bolt M6", "qty": 25, "unit_price": 0.15},
    {"name": "Washer M6", "qty": 25, "unit_price": 0.05},
    {"name": "Cordless Drill", "qty": 1, "unit_price": 89.99},
    {"name": "Drill Bit Set", "qty": 3, "unit_price": 12.50},
]


def line_total(order):
    total = order["qty"] * order["unit_price"]
    if order["qty"] >= BULK_QTY:
        total -= total * BULK_DISCOUNT
    return total


def format_money(amount):
    return f"EUR {amount:,.2f}"


def format_line(order):
    total = line_total(order)
    marker = " (bulk)" if order["qty"] >= BULK_QTY else ""
    qty = f"x{order['qty']}"
    return f"{order['name']:<20}{qty:<6}{format_money(total):>10}{marker}"


def main():
    print("INVOICE")
    print("=" * 42)
    for order in ORDERS:
        print(format_line(order))

    subtotal = sum(line_total(order) for order in ORDERS)
    tax = subtotal * TAX_RATE
    total = subtotal + tax

    print("-" * 42)
    print(f"{'Subtotal':<26}{format_money(subtotal):>10}")
    print(f"{'Tax (21%)':<26}{format_money(tax):>10}")
    print(f"{'Total':<26}{format_money(total):>10}")


if __name__ == "__main__":
    main()
