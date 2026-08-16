import os
import sys

import yaml


def main():
    if len(sys.argv) < 2:
        return

    prompt_key = sys.argv[1]
    prompts_file = os.path.expanduser("~/.bash.d/config/prompts.yaml")

    if not os.path.exists(prompts_file):
        return

    try:
        with open(prompts_file, "r") as f:
            prompts = yaml.safe_load(f) or {}

        val = prompts.get(prompt_key, "")
        print(val.strip())
    except Exception:
        pass


if __name__ == "__main__":
    main()
