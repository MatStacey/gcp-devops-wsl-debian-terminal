# MT DevOps Framework

A high-performance, fully modular Bash environment engineered specifically for Senior Cloud, Platform, and DevOps Engineers. Originally built for Windows Subsystem for Linux (WSL2), it now natively supports macOS (Darwin) and standard Linux distributions.

This configuration adheres to DRY principles, relies on native Bash and standalone Python script execution for zero-latency loading, and aggregates modern CLI tools for Google Cloud Platform, Kubernetes, Terraform, and Python development.

## 🚀 Recent Updates & Enhancements

Added the `mtupd-ai` alias to `.bash.d/02-utilities/20-aliases.sh`. This alias executes `mt-push-update` with flags `-s` (shellcheck), `-b` (backup), and `-g` (git auto-sync/merge) for AI-driven framework updates.

----------------------------------------------------------${C_RESET}\"

  eval \"$cmd\"
}

#######################################
# System: Interactively create and document a new alias
# Usage: mt-alias
#######################################
mt-alias() {
  if [[ \"$1\" == \"-h\" || \"$1\" == \"--help\" ]]; then
    mt-help \"${FUNCNAME[0]}\"
    return 0
  fi

  echo -e \"${CB_BLUE}==========================================================${C_RESET}\"
  echo -e \"${CB_CYAN} 🛠️  Create New Alias${C_RESET}\"
  echo -e \"${CB_BLUE}==========================================================${C_RESET}\"

  local alias_name=\"\"
  local alias_cmd=\"\"
  local alias_cat=\"\"
  local alias_desc=\"\"

  read -r -p \"1️⃣  Alias Name (e.g., kgpo)     : \" alias_name
  if [ -z \"$alias_name\" ]; then
    echo -e \"${CB_RED}🚨 Alias name is required. Aborting.${C_RESET}\"
    return 1
  fi

  local aliases_file=\"$HOME/.bash.d/02-utilities/20-aliases.sh\"
  if grep -qE \"^alias ${alias_name}=\" \"$aliases_file\"; then
    echo -e \"${CB_RED}🚨 Error: Alias '${alias_name}' already exists in 20-aliases.sh.${C_RESET}\"
    return 1
  fi

  read -r -p \"2️⃣  Target Command             : \" alias_cmd
  if [ -z \"$alias_cmd\" ]; then
    echo -e \"${CB_RED}🚨 Target command is required. Aborting.${C_RESET}\"
    return 1
  fi

  read -r -p \"3️⃣  Category (e.g., Docker)    : \" alias_cat
  [ -z \"$alias_cat\" ] && alias_cat=\"User Custom\"

  read -r -p \"4️⃣  Description                : \" alias_desc
  [ -z \"$alias_desc\" ] && alias_desc=\"Custom shortcut for ${alias_cmd}\"

  echo -e \"\n${CB_BLUE}Generating and saving alias...${C_RESET}\"

  cat << ALIASEOF >> \"$aliases_file\"

#######################################
# ${alias_cat}: ${alias_desc}
#######################################
alias ${alias_name}='${alias_cmd}'
ALIASEOF

  echo -e \"${CB_GREEN}✅ Alias saved to 20-aliases.sh!${C_RESET}\"

  # Source the updated file to make it available immediately in the current shell
  source \"$aliases_file\"

  # Quietly rebuild the mytools cache so mt-lookup and mt-help recognize it
  if declare -f mt-refresh-caches > /dev/null 2>&1; then
    mt-refresh-caches > /dev/null 2>&1
  fi

  echo -e \"${CB_CYAN}ℹ️  Alias '${alias_name}' is now active in your current session.${C_RESET}\"
}
",
  "message": "I have reviewed your Git diff patch and completed the truncated `mt-alias` wizard implementation at the end of `.bash.d/02-utilities/99-utils.sh`.

### Summary of Changes in this Patch:
1. **`mtupd` Alias Addition (`20-aliases.sh`)**: Shortcut for `mt-push-update -s -b` to run updates with Shellcheck validation and backup creation enabled.
2. **File Logging with Rotation (`mt-log`)**: `mt-log` now appends timestamps and log levels to `$LOG_DIR/framework.log` with an automated 1MB file size rotation strategy (`framework.log.old`).
3. **Log Viewer (`mt-logs`)**: Added CLI options for log filtering (`-l/--level`), text searching (`-s/--search`), live tailing (`-f/--follow`), log clearing (`-c/--clear`), and IDE inspection (`-o/--open`).
4. **Interactive Alias Generator (`mt-alias`)**: Completed the function to interactively prompt for alias details, prevent duplicates, persist them to `20-aliases.sh`, reload the environment, and refresh internal help caches."
}

---

## 📋 Prerequisites

Before installing this terminal environment, ensure your local workstation meets the following baseline requirements:

* **Operating System:** Officially supports WSL2 (Debian/Ubuntu), macOS (via Homebrew), and native Linux.
* **Visual Studio Code:** Required for seamless IDE integration. Ensure the **WSL Extension** is installed if running on Windows.
* **VSCode Extension Pack:** It is highly recommended to install the standardized extension pack to ensure all linting, formatting, and infrastructure integrations (like Terraform and Checkov) function perfectly alongside this terminal environment. You can install it from the dedicated repository here: [MatStacey/mt-devops-vscode-extension-pack](https://github.com/MatStacey/mt-devops-vscode-extension-pack).
* **Git:** Required to clone the initial repository and handle ongoing AI-assisted profile synchronization.

---

## 🚀 Key Features

* **Cross-Platform Compatibility:** Native OS detection dynamically maps clipboard (`pbcopy`, `clip.exe`), file explorer (`open`, `explorer.exe`), and package manager (`brew`, `apt`) utilities based on your host architecture.
* **Zero-Lag Dynamic Prompt:** Real-time, color-coded Git status, Kubernetes context, and GCP project/account tracking optimized for minimal latency by prioritizing native file reads over subshells where possible. Includes OSC 8 clickable hyperlinking for Git branches and GCP consoles.
* **Asynchronous Update Checks:** Silently checks for system package updates, as well as upstream terminal profile updates, in the background on a configurable TTL timer without blocking terminal initialization.
* **Decoupled Python Configuration:** A dedicated standalone Python manager (`lib/python/config_manager.py`) reads `~/.bash.d/config/config.yaml` to dynamically inject customizable directory paths, API keys, and remote repository URLs directly into the shell environment.
* **Modular Theme Engine:** Color themes are fully externalized into standalone files under `~/.bash.d/config/themes/`, allowing custom aesthetic definitions and instant switching via an interactive `fzf` menu (`mt-select-theme`).
* **Automated Bootstrapping:** Built-in `bootstrap` function automatically resolves and installs required APT/Homebrew packages, Python linters (`ruff`, `checkov`), formatters (`yapf`, `shfmt`), and modern CLI binaries (`yq`, `eza`, `batcat`, `zoxide`).
* **Multi-Provider AI Architecture:** Consult universal AI via the `ai` command with support for **Gemini**, **Claude**, and **Local LLMs** (via Ollama or any OpenAI-compatible endpoint). Background workflows like `git-ai-push-all` dynamically respect your active `DEFAULT_AI` setting.
* **Multi-Threaded Validation:** The `tf-val-all` command leverages `xargs -P` with configurable thread limits to concurrently validate and run Checkov security scans across all Terraform modules.

---

## 🛠️ Setup & Installation

This environment is designed to work out-of-the-box on a fresh WSL2 Debian/Ubuntu instance or macOS machine.

### 1. Download and Extract

Download the latest compiled release and extract it into a permanent directory. The installation script will automatically bind this location as your synchronized workspace.

```bash
# Create a dedicated directory
mkdir -p ~/vcs/personal/mt-devops-framework
cd ~/vcs/personal/mt-devops-framework

# Download and extract the latest release
wget [https://github.com/MatStacey/mt-devops-framework/releases/latest/download/mt-devops-framework-v1.0.0.zip](https://github.com/MatStacey/mt-devops-framework/releases/latest/download/mt-devops-framework-v1.0.0.zip)
unzip mt-devops-framework-v1.0.0.zip

```

### 2. Run the Installer

Execute the installation script. This safely backs up your default `.bashrc`, copies over the modular `.bash.d/` structure, and dynamically scaffolds your local configurations.

```bash
./install.sh

```

### 3. Automated Bootstrapping

At the end of the installation, you will be prompted to bootstrap system dependencies:
`🔍 Would you like to run 'bootstrap' to install system dependencies (jq, fzf, PyYAML, terraform, etc.) now? [Y/n]`

Press **Enter** (or `Y`). The system will automatically update your package manager, install core binaries, and configure isolated Python linters via `pipx`.

### 4. Interactive Setup

Initialize the dynamic prompt, custom themes, and run the automated setup wizard to configure your environment:

```bash
reload
mt-setup

```

The interactive wizard will seamlessly guide you through setting your default IDE, AI provider, secure API keys, and Git synchronization repository.

### 5. Keeping Your Profile Updated

If you have linked your environment to a remote Git repository, you can easily pull the latest configuration changes across multiple workstations. Simply run:

```bash
mt-get-update

```

This command securely fetches your upstream commits and safely synchronizes them into your local `~/.bash.d/` workspace.

---

## 🐳 Docker & Dev Container Integration

This framework includes a fully functional `Dockerfile` and `.devcontainer` configuration, allowing you to instantly spin up a pristine, isolated development environment without installing local dependencies.

When launched, the Dev Container automatically builds the base image, installs all framework tooling, and securely sideloads the latest release of our companion [MT DevOps VSCode Extension Pack](https://github.com/MatStacey/mt-devops-vscode-extension-pack) directly from GitHub.

### 📋 Dev Container Prerequisites

* **Docker Desktop** (or a standard Docker Engine setup).
* **Visual Studio Code**.
* The **Dev Containers** extension (`ms-vscode-remote.remote-containers`) installed in VS Code.

### 🚀 Launch Steps

1. Download or clone this repository to your local machine.
2. Open the `mt-devops-framework` folder in Visual Studio Code.
3. Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on macOS) to open the Command Palette.
4. Type and select **Dev Containers: Reopen in Container**.
5. VS Code will build the image, initialize the framework, fetch the latest extension pack `.vsix` release, and drop you into a ready-to-use terminal!

---

## 📂 Directory Structure

| Module | Description |
| --- | --- |
| `00-system/` | OS detection, path definitions, package management, and the `mt-setup` wizard. |
| `01-ui/` | Color variables and the dynamic terminal prompt. |
| `02-utilities/` | General purpose aliases, Docker handlers, path launchers, and centralized `mt-log`. |
| `03-mytools/` | The core documentation engine and your LLM context extractors. |
| `10-infra/` | GCP authentication/project switchers, concurrent Terraform validation, and comprehensive Kubectl aliases. |
| `20-vcs/` | Git wrappers, AI-assisted feature-grouped commit automation (`git-ai-push-all`), profile syncing, and web launching. |
| `30-ai/` | API integrations for Google Gemini, Anthropic Claude, local OpenAI-compatible endpoints, and debugging tools (`mt-ai-debug`). |
| `config/` | Core YAML files, AI configurations (`config/ai/`), secure `.env` caching, `.syncignore`, and themes (`config/themes/`). |
| `lib/` | Categorized subdirectories for `awk/`, `python/`, and `windows/` helper scripts, alongside `templates/`. |

---

## 🐛 Troubleshooting & Debugging

If you encounter missing commands, broken aliases, or stale environment variables, use the following built-in tools to resolve issues quickly:

* **`reload`:** Instantly re-sources your `~/.bashrc` without needing to restart your terminal session. Perfect for testing quick alias changes.
* **`mt-refresh-caches`:** Forcefully clears and rebuilds all background caches, including `.env.cache`, `mytools` indexes, and system update markers. Use this if your `mt` menu is missing newly added tools or configuration variables aren't persisting.
* **`bootstrap`:** Re-scans your host machine for missing dependencies (like `jq`, `fzf`, or Python linters) and installs them via `apt` or `brew`.
* **`sys-install`:** Installs all pending system OS updates and clears the pending-update marker from your prompt.
* **`sys-update`:** Manually triggers a standard OS package update check (`apt` or `brew` based on your OS).

---

## ❓ FAQ

**Q: Why didn't my new configuration variable apply immediately?**
**A:** The environment uses a high-performance cache to ensure zero-lag loading. If you manually edited `config.yaml` outside of the `mt-` configuration functions, run `mt-refresh-caches` to regenerate the environment cache.

**Q: How do I backup my custom profile modifications?**
**A:** First, ensure you have linked a remote repository using `mt-add-sync-url` or the `mt-setup` wizard. Then, run `mt-push-update`. This uses AI (if enabled) to group your changes into systematic commits and pushes them to your remote repository.

**Q: I am getting an "Argument list too long" error when using the AI tools.**
**A:** This issue was resolved by utilizing temporary payload files. If you are experiencing this on an older version, run `mt-get-update` to automatically pull down the latest codebase fixes.