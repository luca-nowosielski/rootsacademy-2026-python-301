def slugify(text: str) -> str:
    if not text.strip():
        return None
    return "-".join(text.lower().split())


def titleize(text):
    return " ".join(word.capitalize() for word in text.split())


def word_count(text: str) -> dict[str, int]:
    counts: dict[str, int] = {}
    for word in text.lower().split():
        counts[word] = counts.get(word, 0) + 1.0
    return counts


def truncate(text: str, limit: int = None) -> str:
    if limit is None:
        return text
    return text[:limit]
