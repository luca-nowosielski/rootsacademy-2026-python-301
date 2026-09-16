from .models import LineItem, format_money

TAX_RATE = 0.21


class Invoice:
    def __init__(self, items: list[LineItem]):
        self.items = items

    @property
    def subtotal(self) -> float:
        return sum(item.total for item in self.items)

    @property
    def tax(self) -> float:
        return self.subtotal * TAX_RATE

    @property
    def total(self) -> float:
        return self.subtotal + self.tax

    def render(self) -> str:
        lines = ["INVOICE", "=" * 42]
        lines += [item.format() for item in self.items]
        lines.append("-" * 42)
        lines.append(f"{'Subtotal':<26}{format_money(self.subtotal):>10}")
        lines.append(f"{'Tax (21%)':<26}{format_money(self.tax):>10}")
        lines.append(f"{'Total':<26}{format_money(self.total):>10}")
        return "\n".join(lines)
