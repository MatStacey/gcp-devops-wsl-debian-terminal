# GCP DevOps Terminal

A high-performance, fully modular Bash environment engineered specifically for Senior Cloud, Platform, and DevOps Engineers. Originally built for Windows Subsystem for Linux (WSL2), it now natively supports macOS (Darwin) and standard Linux distributions.

This configuration adheres to DRY principles, relies on native Bash and standalone Python script execution for zero-latency loading, and aggregates modern CLI tools for Google Cloud Platform, Kubernetes, Terraform, and Python development.

## 📋 Prerequisites

Before installing this terminal environment, ensure your local workstation meets the following baseline requirements:

*   **Operating System:** Officially supports WSL2 (Debian/Ubuntu), macOS (via Homebrew), and native Linux.
*   **Visual Studio Code:** Required for seamless IDE integration. Ensure the **WSL Extension** is installed if running on Windows.
*   **VSCode Extension Pack:** It is highly recommended to install the standardized extension pack to ensure all linting, formatting, and infrastructure integrations (like Terraform and Checkov) function perfectly alongside this terminal environment. You can install it from the dedicated repository here: [MatStacey/vscode-ext-pack](https://github.com/MatStacey/vscode-ext-pack).
*   **Git:** Required to clone the initial repository and handle ongoing AI-assisted profile synchronization.

---

## 🚀 Key Features

*   **Cross-Platform Compatibility:** Native OS detection dynamically maps clipboard (`pbcopy`, `clip.exe`), file explorer (`open`, `explorer.exe`), and package manager (`brew`, `apt`) utilities based on your host architecture.
*   **Zero-Lag Dynamic Prompt:** Real-time, color-coded Git status, Kubernetes context, and GCP project/account tracking optimized for minimal latency by prioritizing native file reads over subshells where possible. Includes OSC 8 clickable hyperlinking for Git branches and GCP consoles.
*   **Asynchronous Update Checks:** Silently checks for system package updates, as well as upstream terminal profile updates, in the background on a configurable TTL timer without blocking terminal initialization.
*   **Decoupled Python Configuration:** A dedicated standalone Python manager (`lib/config_manager.py`) reads `~/.bash.d/config/config.yaml` to dynamically inject customizable directory paths, API keys, and remote repository URLs directly into the shell environment.
*   **Modular Theme Engine:** Color themes are fully externalized into standalone files under `~/.bash.d/config/themes/`, allowing custom aesthetic definitions and instant switching via an interactive `fzf` menu (`mt-select-theme`).
*   **Automated Bootstrapping:** Built-in `bootstrap` function automatically resolves and installs required APT/Homebrew packages, Python linters (`ruff`, `checkov`), formatters (`yapf`, `shfmt`), and modern CLI binaries (`yq`, `eza`, `batcat`, `zoxide`).
*   **Multi-Provider AI Architecture:** Consult universal AI via the `ai` command with support for **Gemini**, **Claude**, and **Local LLMs** (via Ollama or any OpenAI-compatible endpoint). Background workflows like `git-ai-pc` dynamically respect your active `DEFAULT_AI` setting.
*   **Multi-Threaded Validation:** The `tf-val-all` command leverages `xargs -P` with configurable thread limits to concurrently validate and run Checkov security scans across all Terraform modules.

---

## 🛠️ Setup & Installation

This environment is designed to work out-of-the-box on a fresh WSL2 Debian/Ubuntu instance or macOS machine. 

### 1. Download and Extract
Download the latest compiled release and extract it into a permanent directory. The installation script will automatically bind this location as your synchronized workspace.

```bash
# Create a dedicated directory
mkdir -p ~/vcs/personal/gcp-devops-terminal
cd ~/vcs/personal/gcp-devops-terminal

# Download and extract the latest release
wget [https://github.com/MatStacey/gcp-devops-wsl-debian-terminal/releases/latest/download/gcp-devops-terminal-v1.0.0.zip](https://github.com/MatStacey/gcp-devops-wsl-debian-terminal/releases/latest/download/gcp-devops-terminal-v1.0.0.zip)
unzip gcp-devops-terminal-v1.0.0.zip

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

### 4. Reload & Authenticate

Initialize the dynamic prompt and custom themes by reloading your profile:

```bash
reload

```

Securely inject your preferred LLM API key, or configure your local LLM provider:

```bash
# For Gemini
mt-add-gemini-key

# For Claude
mt-add-claude-key

# Or switch to a local LLM (Ollama)
mt-set-default-ai local

```

### 5. Keeping Your Profile Updated

If you have linked your environment to a remote Git repository, you can easily pull the latest configuration changes across multiple workstations. Simply run:

```bash
mt-get-update

```

This command securely fetches your upstream commits and safely synchronizes them into your local `~/.bash.d/` workspace.

---

## 📂 Directory Structure

| Module | Description |
| --- | --- |
| `00-core/` | Core configuration, centralized dynamic color themes, cross-platform OS helpers, mytools engine, and bootstrapping utilities. |
| `10-infra/` | GCP authentication/project switchers, concurrent Terraform validation, and comprehensive Kubectl aliases. |
| `20-vcs/` | Git wrappers, AI-assisted feature-grouped commit automation (`git-ai-pc`), profile syncing, and web launching. |
| `30-ai/` | API integrations for interacting with Google Gemini, Anthropic Claude, and local OpenAI-compatible endpoints. |
| `config/` | JSON/YAML files, secure `.env` caching, and modular theme definitions (`config/themes/`). |
| `lib/` | AWK parsers (`mytools.awk`), configuration templates, and standalone Python utility scripts (`config_manager.py`). |

---

## 🧰 Command Reference

### 🔧 Bespoke Profile Utilities (`mt-*`)

These utilities are exclusive to this profile and control environment configuration, synchronization, and exports.

| Command | Description |
| --- | --- |
| `mt` / `mt-help` | Print all custom aliases and functions dynamically indexed from the codebase. |
| `mt-refresh-caches` | Forcefully clears and rebuilds all background caches (.env, mytools index, system updates). |
| `mt-get-update` | Pull latest remote profile changes and safely apply them to the local terminal workspace. |
| `mt-push-update` | Sync local bash configs to terminal repo and push (AI-powered systematic commits). |
| `mt-open-config` | Opens the bash.d configuration directory directly in the configured IDE. |
| `mt-select-theme` | Opens an interactive fuzzy-finder menu to select and apply a terminal theme. |
| `mt-set-theme` | Sets the active terminal color theme and reloads the color profile. |
| `mt-add-sync-url` | Configures the remote git URL for the bash profile synchronization tool. |
| `mt-open-homepage` | Open the sync repository's remote URL in the default web browser. |
| `mt-set-default-ide` | Sets the default local IDE for launch commands (`vscode` | `intellij`). |
| `mt-set-default-ai` | Sets the default LLM provider for the 'ai' command suite (`gemini` | `claude` | `local`). |
| `mt-toggle-ai` | Toggles global AI prompt and integration flags. |
| `mt-get-gemini-status` | Prints the current Gemini API model version and extended reasoning mode toggle. |
| `mt-toggle-gemini-extended` | Toggles the Gemini extended reasoning mode flag. |
| `mt-export` | Compiles and exports all local text/code files for LLM context injection. |
| `mt-export-terraform` | Compiles and exports local Terraform codebase. |
| `mt-export-shell` | Compiles and exports local Bash/Shell codebase. |
| `mt-export-cloudrun` | Compiles and exports local Python Cloud Run/Function codebase. |
| `mt-export-cleanup` | Cleans up and prunes old export files. |
| `mt-toggle-auto-cleanup` | Toggles the background execution of the export cleanup script. |
| `mt-set-auto-cleanup-days` | Modifies the threshold in days before exports are automatically deleted. |

---

### ⚙️ Core System & Navigation

| Command | Type | Description |
| --- | --- | --- |
| `bootstrap` | Function | Install missing dependencies for bash aliases (Debian/WSL via APT, macOS via Homebrew). |
| `sys-install` | Function | Updates system packages and clears the pending-update marker. |
| `sys-update` | Function | Updates system packages without clearing prompt markers. |
| `sys-install-reload` | Alias | Update, Upgrade, Bootstrap, Reload. |
| `reload` | Alias | Re-sources the Bash profile for instant lightweight updates. |
| `cdbashd` / `cdvcs` | Aliases | Change directory to `~/.bash.d` or `~/vcs`. |
| `cd-ai` / `cd-sync` | Functions | Config-driven directory changes to unified AI or sync repos. |
| `clip` | Function | Pipe output to the system clipboard (`clip.exe` / `pbcopy` / `xclip`). |
| `ide` | Function | Open current directory in the default IDE (VSCode/IntelliJ). |
| `win` / `win-vcs` | Functions | Open specific directories in the platform's native file manager. |
| `base64-enc` / `base64-dec` | Functions | Encode or decode strings, files, or streams to/from Base64. |

---

### ☁️ Cloud & Infrastructure

#### Google Cloud Platform (GCP)

| Command | Type | Description |
| --- | --- | --- |
| `gcp-set-project` | Function | Switch active project interactively or explicitly. |
| `gcp-login` | Function | Login to user & application default. |
| `gcl-export-vars` | Function | Export `PROJECT_ID` and `PROJECT_NUMBER` env vars to the shell. |
| `gcl-config` | Function | List active configuration properties. |
| `gcl-get-project` | Function | Print active project ID. |
| `gcl-update` | Function | Update Google Cloud CLI tools. |
| `gcp-iam-show` | Function | View IAM policy for the active project. |
| `gcp-get-secret` | Function | Read the latest payload of a Secret Manager secret. |
| `gcp-crf-logs` | Function | Tail logs of a Cloud Run Function. |
| `gce-ls` / `gce-ssh` | Aliases | List Compute VMs or SSH into an instance. |
| `bq-query` / `bq-ls` | Func/Alias | Run standard SQL queries or list BigQuery datasets. |

#### Infrastructure as Code (Terraform)

| Command | Type | Description |
| --- | --- | --- |
| `terraform` | Function | Terraform wrapper (preserves args and binary). |
| `tf` / `tfa` / `tfd` | Aliases | Base command, Apply deployment, Destroy resources. |
| `tff` | Alias | Format all TF files recursively. |
| `tf-val-all` | Function | Recursively validate and scan all Terraform directories concurrently. |
| `tf-scan` | Alias | Checkov: Scan local terraform directory. |
| `tf-clean` | Function | Aggressively clean local caching (`.terraform`, locks, plans). |
| `tf-replace` | Function | Replace a specific resource (Modern alternative to taint). |
| `tf-yaml` | Function | Wrapper to execute Terraform using a YAML config file for variables. |
| `tf-iam` | Function | Ask AI to list required Service Accounts and least-privilege roles. |

#### Container Orchestration (Docker & Kubernetes)

| Command | Type | Description |
| --- | --- | --- |
| `docker-ls` | Function | Lists all running Docker containers in a clean, readable table format. |
| `docker-nuke` | Function | Aggressive cleanup of all unused containers, dangling images, and volumes. |
| `docker-reboot-all` | Function | Gracefully restarts running containers, respecting the `restart_blocklist`. |
| `docker-sandbox` | Function | Instantly spins up a temporary container sandbox (`--rm`). |
| `docker-shell` | Function | Interactive fuzzy-finder to instantly `exec` into a running container. |
| `docker-tail` | Function | Multi-select (`TAB`) several containers via `fzf` to concurrently tail logs. |
| `k` | Alias | `kubectl` wrapper |
| `ka` / `kak` / `krm` | Aliases | Apply (`-f`, `-k`) or Delete resources. |
| `kns` | Function | View or interactively set (`TAB` completion) the default namespace context. |
| `kg*` / `kd*` | Aliases | Get or Describe resources (`kgpo`, `kgdep`, `kgsvc`, `kdcm`, `kdsec`, etc.). |
| `klo` / `kex` / `kpf` | Aliases | Tail logs, Exec interactively, or Port forward. |

---

### 💻 Development & Workflows

#### Version Control (Git)

| Command | Type | Description |
| --- | --- | --- |
| `git` | Function | Wrapper to force 'clone' into `~/vcs/` from anywhere. |
| `git-ai-pc` | Function | Add all files, intelligently group via AI (respecting active provider), and push. |
| `git-feature` | Function | Create and checkout a new feature branch using the configured prefix. |
| `git-cleanup` | Function | Safely delete all local branches merged into the default branch. |
| `git-update` | Function | Fetch upstream and rebase the current branch onto the default branch. |
| `git-nuke` | Function | Hard reset and wipe all untracked files on the current branch. |
| `git-ide` | Function | Clone a repository into `~/vcs/`, `cd` into it, and open in IDE. |
| `git-lg` | Function | Print a beautiful, color-coded, single-line graph log. |
| `git-web` | Function | Open the current repository in the default web browser. |

#### Code Formatting & CLI Replacements

| Command | Type | Description |
| --- | --- | --- |
| `google-fmt` | Function | Formats Python and Shell scripts according to Google Style Guides. |
| `ruff-fmt` | Alias | Ruff: Format Python files and imports in current directory (recursive). |
| `shfmtlw` | Alias | shfmt: Format all shell scripts in current directory (recursive). |
| `ai` | Function | Consult universal AI directly from the CLI. |
| `cat` / `ccat` | Aliases | `bat`: Print file contents with syntax highlighting and Git gutters. |
| `ll` / `ls` | Aliases | `eza`: Detailed file lists with Git status and directories first. |
| `rg` | Alias | `rg`: Search with smart case, include hidden, ignore `.git`. |
| `tree` | Alias | `eza`: Display directory structure as a tree. |
| `json-fmt` / `yaml-fmt` | Aliases | Pretty-print JSON/YAML streams (requires `jq`/`yq`). |

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
**A:** First, ensure you have linked a remote repository using `mt-add-sync-url`. Then, run `mt-push-update`. This uses AI (if enabled) to group your changes into systematic commits and pushes them to your remote repository.

**Q: I am getting an "Argument list too long" error when using the AI tools.**
**A:** This issue was resolved by utilizing temporary payload files. If you are experiencing this on an older version, run `mt-get-update` to automatically pull down the latest codebase fixes.
