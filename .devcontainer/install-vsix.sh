#!/usr/bin/env bash
set -e

echo "📦 Fetching latest MT DevOps Extension Pack..."
RELEASE_DATA=$(curl -s "https://api.github.com/repos/MatStacey/mt-devops-vscode-extension-pack/releases/latest")
VSIX_URL=$(echo "$RELEASE_DATA" | jq -r '.assets[] | select(.name | endswith(".vsix")) | .browser_download_url')

if [ -z "$VSIX_URL" ] || [ "$VSIX_URL" == "null" ]; then
  echo "🚨 Error: Could not find .vsix asset in latest release."
  exit 1
fi

echo "⬇️ Downloading ${VSIX_URL}..."
curl -L -# --fail "$VSIX_URL" -o /tmp/extension.vsix

echo "⚙️ Installing extension pack..."
# The 'code' CLI is available in the Dev Container to manage extensions
code --install-extension /tmp/extension.vsix --force
rm -f /tmp/extension.vsix

echo "✅ Extension pack installed successfully!"
