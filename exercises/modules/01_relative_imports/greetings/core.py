from .langs import english, french

_SPEAKERS = {"en": english.say_hello, "fr": french.say_hello}


def greet(name: str, lang: str = "en") -> str:
    say_hello = _SPEAKERS[lang]
    return say_hello(name)
