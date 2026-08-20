#!/usr/bin/env bash
# Execution Context: $SYNC_REPO_DIR/.dev

BOOTSTRAP_FILE="$HOME/.bash.d/00-system/04-bootstrap.sh"

if [ ! -f "$BOOTSTRAP_FILE" ]; then
  echo "🚨 Error: Could not find $BOOTSTRAP_FILE"
  exit 1
fi

echo "🔄 Injecting GH CLI and Claude Code into bootstrap..."

python3 -c '
import os, re

filepath = os.path.expanduser("~/.bash.d/00-system/04-bootstrap.sh")
with open(filepath, "r") as f:
    content = f.read()

# The installation block to inject
tool_injection = r"""
  # Install GitHub CLI (gh)
  if ! command -v gh >/dev/null 2>&1; then
    echo -e "${CB_BLUE}📦 Installing GitHub CLI...${C_RESET}"
    if command -v apt-get >/dev/null 2>&1; then
      curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg >/dev/null 2>&1
      sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
      sudo apt-get update >/dev/null 2>&1
      sudo apt-get install -y gh >/dev/null 2>&1
    else
      echo -e "${CB_YELLOW}⚠️ apt-get not found. Please install GitHub CLI manually.${C_RESET}"
    fi
  fi

  # Install Claude Code (claude)
  if ! command -v claude >/dev/null 2>&1; then
    if command -v npm >/dev/null 2>&1; then
      echo -e "${CB_BLUE}📦 Installing Claude Code...${C_RESET}"
      sudo npm install -g @anthropic-ai/claude-code >/dev/null 2>&1
    else
      echo -e "${CB_YELLOW}⚠️ npm not found. Skipping Claude Code install. (Please install Node.js first)${C_RESET}"
    fi
  fi
"""

# Find the end of the bootstrap() function and inject the code just before the closing brace
# Using a regex to find the last closing brace of the bootstrap function
bootstrap_pattern = re.compile(r"(bootstrap\(\)\s*\{.*?)(^\}$)", re.DOTALL | re.MULTILINE)

if "githubcli-archive-keyring" in content:
    print("⚠️  Tools appear to already be in the bootstrap script. Skipping injection.")
elif bootstrap_pattern.search(content):
    content = bootstrap_pattern.sub(lambda m: m.group(1) + tool_injection + m.group(2), content)
    with open(filepath, "w") as f:
        f.write(content)
    print("✅ Successfully added gh and claude to bootstrap!")
else:
    print("🚨 Could not safely find the end of the bootstrap function.")
'

echo "🚀 Run 'bootstrap' in your terminal at any time to install the new tools."
