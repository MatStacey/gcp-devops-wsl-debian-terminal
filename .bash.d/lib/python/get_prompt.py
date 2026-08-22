"""
Retrieves AI system and workflow prompts from a centralized YAML configuration.

Reads the specific prompt key passed via CLI arguments from the `prompts.yaml`
file and prints the prompt string to standard output.
"""

import contextlib
import os
import sys


def main():
    """Loads the YAML prompt file, retrieves the requested key, and prints it."""
    if len(sys.argv) < 2:
        return

    try:
        import yaml
    except ImportError:
        # Printed to stderr, not stdout: this script's stdout is captured
        # directly as prompt text by the caller, never sourced as bash.
        print("🚨 PyYAML is missing. Run bootstrap to install it.", file=sys.stderr)
        return

    prompt_key = sys.argv[1]
    prompts_file = os.path.expanduser("~/.bash.d/config/ai/prompts.yaml")

    if not os.path.exists(prompts_file):
        return

    with contextlib.suppress(OSError, yaml.YAMLError):
        with open(prompts_file, "r", encoding="utf-8") as f:
            prompts = yaml.safe_load(f) or {}

        val = prompts.get(prompt_key, "")
        if val and isinstance(val, str):
            print(val.strip())


if __name__ == "__main__":
    main()
