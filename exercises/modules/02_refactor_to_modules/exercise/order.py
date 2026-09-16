BULK_QTY = 10
BULK_DISCOUNT = 0.1


def format_money(amount):
    return f"EUR {amount:,.2f}"


class Order:
    def __init__(self, name, qty, unit_price):
        self.name = name
        self.qty = qty
        self.unit_price = unit_price

    def line_total(self):
        total = self.qty * self.unit_price
        if self.qty >= BULK_QTY:
            total -= total * BULK_DISCOUNT
        return total

    def format_line(self):
        total = self.line_total()
        marker = " (bulk)" if self.qty >= BULK_QTY else ""
        qty = f"x{self.qty}"
        return f"{self.name:<20}{qty:<6}{format_money(total):>10}{marker}"
