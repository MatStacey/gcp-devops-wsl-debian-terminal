"""
Extracts a JSON object from raw text using regex.

Large Language Models often wrap their JSON output inside conversational text
or markdown code blocks. This script reads from standard input and attempts
to extract the outermost JSON object bracket payload.
"""

import json
import re
import sys


def main():
    """Reads STDIN, extracts a JSON-like object, and prints it to STDOUT."""
    text = sys.stdin.read()
    match = re.search(r"\{.*\}", text, re.DOTALL)

    if match:
        candidate = match.group(0)
        try:
            json.loads(candidate)
        except (ValueError, TypeError):
            print(text)
        else:
            print(candidate)
    else:
        print(text)


if __name__ == "__main__":
    main()
