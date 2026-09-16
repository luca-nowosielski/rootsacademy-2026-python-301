from .order import format_money

TAX_RATE = 0.21


class Invoice:
    def __init__(self, orders):
        self.orders = orders

    @property
    def subtotal(self):
        return sum(order.line_total() for order in self.orders)

    @property
    def tax(self):
        return self.subtotal * TAX_RATE

    @property
    def total(self):
        return self.subtotal + self.tax

    def render(self):
        lines = ["INVOICE", "=" * 42]
        lines += [order.format_line() for order in self.orders]
        lines.append("-" * 42)
        lines.append(f"{'Subtotal':<26}{format_money(self.subtotal):>10}")
        lines.append(f"{'Tax (21%)':<26}{format_money(self.tax):>10}")
        lines.append(f"{'Total':<26}{format_money(self.total):>10}")
        return "\n".join(lines)
