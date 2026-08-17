#!/usr/bin/env bash
set -e

LOCK_FILE="/tmp/.mt_vsix_installed"

# 1. Fast idempotency check (avoids calling the CLI repeatedly)
if [ -f "$LOCK_FILE" ]; then
  echo "✅ Extension pack already processed for this session. Skipping."
  exit 0
fi

# 2. Wait for VS Code Server to finish injecting the 'code' CLI into PATH
echo "⏳ Waiting for VS Code CLI..."
for i in {1..60}; do
  if command -v code > /dev/null 2>&1; then
    break
  fi
  sleep 2
done

if ! command -v code > /dev/null 2>&1; then
  echo "🚨 Error: 'code' CLI not found. VS Code Server is too slow to start."
  exit 1
fi

# Deep check in case it's already installed
if code --list-extensions | grep -qi "mt-devops-vscode-extension-pack"; then
  echo "✅ Extension pack is already installed. Skipping."
  touch "$LOCK_FILE"
  exit 0
fi

# 3. Bypass GitHub API Rate Limits by querying the release web redirect
echo "📦 Fetching latest MT DevOps Extension Pack..."
LATEST_URL=$(curl -Ls -o /dev/null -w %{url_effective} "https://github.com/MatStacey/mt-devops-vscode-extension-pack/releases/latest")
TAG=$(basename "$LATEST_URL")

if [[ "$TAG" != v* ]]; then
  echo "🚨 Error: Could not determine latest release tag (Got: $TAG)."
  exit 1
fi

# Extract version number without the 'v' prefix (e.g., v0.0.5 -> 0.0.5)
VERSION="${TAG#v}"
VSIX_URL="https://github.com/MatStacey/mt-devops-vscode-extension-pack/releases/download/${TAG}/mt-devops-vscode-extension-pack-${VERSION}.vsix"

echo "⬇️ Downloading ${VSIX_URL}..."
curl -L -# --fail "$VSIX_URL" -o /tmp/extension.vsix

echo "⚙️ Installing extension pack..."
code --install-extension /tmp/extension.vsix --force
rm -f /tmp/extension.vsix

touch "$LOCK_FILE"
echo "✅ Extension pack installed successfully!"
