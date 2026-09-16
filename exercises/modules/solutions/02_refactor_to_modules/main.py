from billing import Invoice, LineItem

ORDERS = [
    ("Hex Bolt M6", 25, 0.15),
    ("Washer M6", 25, 0.05),
    ("Cordless Drill", 1, 89.99),
    ("Drill Bit Set", 3, 12.50),
]


def main() -> None:
    invoice = Invoice([LineItem(*order) for order in ORDERS])
    print(invoice.render())


if __name__ == "__main__":
    main()
