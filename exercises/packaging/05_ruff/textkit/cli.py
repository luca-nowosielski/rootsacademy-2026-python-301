import sys

import click
from textkit_stats import average_word_length

from .core import slugify


@click.command()
@click.argument("text")
def main(text: str) -> None:
    click.echo(slugify(text))
    click.echo(f"avg word length: {average_word_length(text):.1f}")
