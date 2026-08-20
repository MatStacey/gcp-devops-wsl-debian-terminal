#!/usr/bin/env bash
# Execution Context: $SYNC_REPO_DIR/.dev

# Safely resolve the README path whether SYNC_REPO_DIR is active or not
README_FILE="${SYNC_REPO_DIR:-$(cd .. && pwd)}/README.md"

if [ ! -f "$README_FILE" ]; then
  echo "🚨 Error: Could not find README.md at $README_FILE"
  exit 1
fi

echo "🔄 Patching README.md with the latest enhancements..."

python3 -c '
import sys

filepath = sys.argv[1]

with open(filepath, "r", encoding="utf-8") as f:
    content = f.read()

recent_updates = r"""## 🚀 Recent Updates & Enhancements

* **Intelligent Git Automation:**
  * Replaced manual pushing with `git-raise-pr`: A robust, universal function that automatically creates Pull Requests via the GitHub CLI (`gh`), or constructs the correct UI URLs for Bitbucket and GitLab.
  * `mt-push-update` now intelligently detects branch states, prunes dead/merged PR branches, and gracefully handles merge conflicts automatically.
  * Added `git-clean-merged` to comprehensively sweep and delete local and remote branches that have been safely merged into `main`.
* **Advanced AI Integration:**
  * Integrated **Claude Code** (`claude`) directly into the local bootstrap, Dockerfile, and Dev Container environments.
  * Smart terminal profiles now only warn about missing API keys for the *actively selected* AI provider (Gemini or Claude), keeping terminal startups clean.
* **Seamless Dev Containers:**
  * Configured VS Code `dotfiles` integration to automatically clone and initialize the MT DevOps Framework inside *any* newly spun-up Dev Container.
  * Hardened the base `Dockerfile` for security scanners while optimizing layer caching for `gh`, Node.js, and Terraform.
* **Quality of Life:**
  * Added `cd-win-docker`, dynamically parsing `config.yaml` using Python to open your internal Docker directory in Windows Explorer directly from WSL.
  * Structured `.gitignore` for better maintainability across Secrets, State caches, Python tooling, and Build artifacts.

---

## 🚀 Key Features"""

if "## 🚀 Recent Updates" in content:
    print("⚠️  Recent Updates section already exists in README.md.")
elif "## 🚀 Key Features" in content:
    content = content.replace("## 🚀 Key Features", recent_updates)
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(content)
    print("✅ Successfully injected Recent Updates into README.md!")
else:
    print("🚨 Error: Could not find '\''## 🚀 Key Features'\'' in README.md.")
' "$README_FILE"
