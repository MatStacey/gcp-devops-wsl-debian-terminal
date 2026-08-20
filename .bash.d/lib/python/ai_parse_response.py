"""
Extracts a JSON object from raw text using regex.

Large Language Models often wrap their JSON output inside conversational text
or markdown code blocks. This script reads from standard input and attempts
to extract the outermost JSON object bracket payload.
"""

import re
import sys


def main():
    """Reads STDIN, extracts a JSON-like object, and prints it to STDOUT."""
    text = sys.stdin.read()

    # Locate the first '{' and the last '}' in the text payload
    match = re.search(r"\{.*\}", text, re.DOTALL)

    if match:
        print(match.group(0))
    else:
        print(text)


if __name__ == "__main__":
    main()
