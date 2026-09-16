def slugify(text: str) -> str:
    if not text.strip():
        return ""
    return "-".join(text.lower().split())


def titleize(text: str) -> str:
    return " ".join(word.capitalize() for word in text.split())


def word_count(text: str, stopwords: list[str] | None = None) -> dict[str, int]:
    stopwords = stopwords or []
    counts: dict[str, int] = {}
    for word in text.lower().split():
        if word in stopwords:
            continue
        counts[word] = counts.get(word, 0) + 1
    return counts


def describe(text: str) -> str:
    result = titleize(text)
    if result is None:
        return ""
    return f"{result} ({len(text.split())} words)"
