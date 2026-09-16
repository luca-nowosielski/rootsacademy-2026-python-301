from .formatting.shout import shout


def say_hello(name: str) -> str:
    return shout(f"Bonjour, {name}")
