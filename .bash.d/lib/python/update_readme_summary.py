"""
Updates the 'Recent Updates & Enhancements' section of a Markdown file.

This script reads a target Markdown file, locates the section starting with 
'## 🚀 Recent Updates & Enhancements' and ending with '---', and replaces 
its contents with the provided text.

Usage:
    python update_readme_summary.py <file_path> <new_content>
"""

import re
import sys

def main():
    """Reads the target file, replaces the updates section, and overwrites the file."""
    if len(sys.argv) < 3:
        sys.exit(1)

    file_path = sys.argv[1]
    new_content = sys.argv[2]

    with open(file_path, "r", encoding="utf-8") as f:
        c = f.read()

    updates = f"## 🚀 Recent Updates & Enhancements\n\n{new_content}\n\n---"
    c_new = re.sub(r"## 🚀 Recent Updates & Enhancements.*?---", updates, c, flags=re.DOTALL)
    
    with open(file_path, "w", encoding="utf-8") as f:
        f.write(c_new)

if __name__ == "__main__":
    main()
