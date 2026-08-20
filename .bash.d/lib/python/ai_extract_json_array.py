"""
Extracts and parses a JSON array from raw LLM text input.

Large Language Models may return arrays hidden inside standard dictionaries
(e.g., {"message": "[...]"}) or wrapped in markdown. This script attempts
to locate, sanitize, and parse the array payload securely.
"""

import ast
import contextlib
import json
import re
import sys
from typing import Any


def try_parse(val: Any) -> list | None:
    """Attempts to parse a given value into a JSON list."""
    if isinstance(val, list):
        return val

    if isinstance(val, str):
        val_clean = val.strip()
        with contextlib.suppress(ValueError, TypeError):
            res = json.loads(val_clean)
            if isinstance(res, list):
                return res
        with contextlib.suppress(ValueError, TypeError, SyntaxError):
            res = ast.literal_eval(val_clean)
            if isinstance(res, list):
                return res
    return None


def _extract_from_json(text: str) -> list | None:
    """Attempts to directly parse the payload as JSON."""
    with contextlib.suppress(ValueError, TypeError):
        data = json.loads(text)
        if isinstance(data, dict):
            for key in ("message", "code"):
                if key in data:
                    parsed = try_parse(data[key])
                    if parsed is not None:
                        return parsed
        elif isinstance(data, list):
            return data
    return None


def _extract_from_regex(text: str) -> list | None:
    """Attempts to extract a JSON array wrapped in text/markdown via Regex."""
    match = re.search(r"(\[.*\])", text, re.DOTALL)
    if match:
        parsed = try_parse(match.group(1))
        if parsed is not None:
            return parsed
    return None


def main():
    """Reads raw text from STDIN and attempts to extract a JSON list payload."""
    text = sys.stdin.read().strip()
    result = _extract_from_json(text)
    if result is None:
        result = _extract_from_regex(text)
    print(json.dumps(result if result is not None else []))


if __name__ == "__main__":
    main()
