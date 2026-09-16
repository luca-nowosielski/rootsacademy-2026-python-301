def slugify(text: str) -> str:
    return "-".join(text.lower().split())


def titleize(text: str) -> str:
    return " ".join(word.capitalize() for word in text.split())


def word_count(text: str) -> dict[str, int]:
    counts: dict[str, int] = {}
    for word in text.lower().split():
        counts[word] = counts.get(word, 0) + 1
    return counts
