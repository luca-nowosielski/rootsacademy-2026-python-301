BULK_QTY = 10
BULK_DISCOUNT = 0.1


def format_money(amount: float) -> str:
    return f"EUR {amount:,.2f}"


class LineItem:
    def __init__(self, name: str, qty: int, unit_price: float):
        self.name = name
        self.qty = qty
        self.unit_price = unit_price

    @property
    def is_bulk(self) -> bool:
        return self.qty >= BULK_QTY

    @property
    def total(self) -> float:
        total = self.qty * self.unit_price
        if self.is_bulk:
            total -= total * BULK_DISCOUNT
        return total

    def format(self) -> str:
        marker = " (bulk)" if self.is_bulk else ""
        qty = f"x{self.qty}"
        return f"{self.name:<20}{qty:<6}{format_money(self.total):>10}{marker}"
