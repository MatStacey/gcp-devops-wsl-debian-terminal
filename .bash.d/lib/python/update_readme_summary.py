"""
Updates the 'Recent Updates & Enhancements' section of a Markdown file.

This script reads a target Markdown file, locates the section starting with
'## 🚀 Recent Updates & Enhancements' and ending with a standalone '---'
horizontal rule, and replaces its contents with the provided text.

Usage:
    python update_readme_summary.py <file_path> <new_content>
"""

import json
import re
import sys

HEADING = "## 🚀 Recent Updates & Enhancements"

# The section's own closing delimiter: a "---" alone on its line. Only
# consumes through that line's own newline, so any blank line separating it
# from the next section is left untouched.
SECTION_PATTERN = re.compile(
    re.escape(HEADING) + r".*?\n-{3,}[ \t]*(?:\n|$)", re.DOTALL)

# Fallback if a prior run left the section without its closing "---":
# stop at the next top-level heading instead.
NEXT_HEADING_PATTERN = re.compile(
    re.escape(HEADING) + r".*?(?=\n## )", re.DOTALL)


def _looks_like_code_or_raw_json(text):
    """Heuristic: does this look like leaked code/JSON rather than prose?"""
    stripped = text.strip()
    if not stripped:
        return False
    try:
        json.loads(stripped)
        return True
    except (json.JSONDecodeError, ValueError):
        pass
    # Escaped quotes are a strong signal of a raw JSON string body leaking in.
    if '\\"' in stripped:
        return True
    # Shebangs or shell heredoc markers.
    return bool(re.search(r"^\s*#!/|<<['\"]?[A-Z_]+['\"]?\s*$", stripped, re.MULTILINE))


def main():
    """Reads the target file, replaces the updates section, and overwrites the file."""
    if len(sys.argv) < 3:
        sys.exit(1)

    file_path = sys.argv[1]
    new_content = sys.argv[2]

    with open(file_path, "r", encoding="utf-8") as f:
        c = f.read()

    # Strip any standalone "---" lines from the incoming content so it can
    # never be mistaken for the section's own closing delimiter on a later run.
    new_content = re.sub(r"(?m)^-{3,}\s*$", "", new_content).strip()

    if _looks_like_code_or_raw_json(new_content):
        new_content = f"```\n{new_content}\n```"

    updates = f"{HEADING}\n\n{new_content}\n\n---\n"

    if SECTION_PATTERN.search(c):
        c_new = SECTION_PATTERN.sub(updates, c, count=1)
    elif NEXT_HEADING_PATTERN.search(c):
        c_new = NEXT_HEADING_PATTERN.sub(updates, c, count=1)
    else:
        print(
            f"update_readme_summary.py: could not locate '{HEADING}' section in {file_path}, leaving file untouched",
            file=sys.stderr,
        )
        return

    with open(file_path, "w", encoding="utf-8") as f:
        f.write(c_new)


if __name__ == "__main__":
    main()
