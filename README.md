# MT DevOps Framework

A high-performance, fully modular Bash environment engineered specifically for Senior Cloud, Platform, and DevOps Engineers. Originally built for Windows Subsystem for Linux (WSL2), it now natively supports macOS (Darwin) and standard Linux distributions.

This configuration adheres to DRY principles, relies on native Bash and standalone Python script execution for zero-latency loading, and aggregates modern CLI tools for Google Cloud Platform, Kubernetes, Terraform, and Python development.

## 📋 Prerequisites

Before installing this terminal environment, ensure your local workstation meets the following baseline requirements:

* **Operating System:** Officially supports WSL2 (Debian/Ubuntu), macOS (via Homebrew), and native Linux.
* **Visual Studio Code:** Required for seamless IDE integration. Ensure the **WSL Extension** is installed if running on Windows.
* **VSCode Extension Pack:** It is highly recommended to install the standardized extension pack to ensure all linting, formatting, and infrastructure integrations (like Terraform and Checkov) function perfectly alongside this terminal environment. You can install it from the dedicated repository here: [MatStacey/mt-devops-vscode-extension-pack](https://github.com/MatStacey/mt-devops-vscode-extension-pack).
* **Git:** Required to clone the initial repository and handle ongoing AI-assisted profile synchronization.

---

## 🚀 Recent Updates & Enhancements

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

# Or switch to a local LLM (e.g., Ollama)
mt-set-default-ai local
mt-set-local-ai-url "http://localhost:11434/v1"
mt-set-local-ai-model "llama3.2"

```

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
| `00-system/` | OS detection, path definitions, and package management. |
| `01-ui/` | Color variables and the dynamic terminal prompt. |
| `02-utilities/` | General purpose aliases, Docker handlers, and path launchers. |
| `03-mytools/` | The core documentation engine and your LLM context extractors. |
| `10-infra/` | GCP authentication/project switchers, concurrent Terraform validation, and comprehensive Kubectl aliases. |
| `20-vcs/` | Git wrappers, AI-assisted feature-grouped commit automation (`git-ai-push-all`), profile syncing, and web launching. |
| `30-ai/` | API integrations for interacting with Google Gemini, Anthropic Claude, and local OpenAI-compatible endpoints. |
| `config/` | Core YAML files, AI configurations (`config/ai/`), secure `.env` caching, and themes (`config/themes/`). |
| `lib/` | Categorized subdirectories for `awk/`, `python/`, and `windows/` helper scripts, alongside `templates/`. |

---

## 🧰 Command Reference

### [Base64 Encoding & Decoding Utilities]

| Command | Type | Description |
| --- | --- | --- |
| `__get_prompt` | Function | AI: Retrieves a prompt string from the centralized prompts.yaml |
| `base64-dec` | Function | Base64: Decode a Base64 string, file, or stream |
| `base64-enc` | Function | Base64: Encode a string, file, or stream to Base64 |
| `docker-ls` | Function | Docker: List all running containers in a clean table format |
| `docker-nuke` | Function | Docker: Aggressive cleanup of all unused containers, images, and volumes |
| `docker-reboot-all` | Function | Docker: Restart all currently running Docker containers |
| `docker-sandbox` | Function | Docker: Spin up a temporary, throwaway container sandbox |
| `docker-shell` | Function | Docker: Interactive fuzzy-finder to exec into a running container |
| `docker-tail` | Function | Docker: Concurrently tail logs from multiple selected containers |

### [Configuration Management]

| Command | Type | Description |
| --- | --- | --- |
| `mt-add-claude-key` | Function | Config: Add Claude API key to config.yaml [Usage: mt-add-claude-key ["key"]] |
| `mt-add-gemini-key` | Function | Config: Add Gemini API key to config.yaml [Usage: mt-add-gemini-key ["key"]] |
| `mt-add-sync-url` | Function | Config: Add remote repository URL for bash sync [Usage: mt-add-sync-url "url"] |
| `mt-get-gemini-status` | Function | Prints the current Gemini API model version and extended reasoning mode toggle. |
| `mt-open-config` | Function | Config: Open bash.d directory and config.yaml in IDE [Usage: mt-open-config [-ide vscode\|intellij]] |
| `mt-select-theme` | Function | Config: Interactive menu to select and apply a theme [Usage: mt-select-theme] |
| `mt-set-auto-cleanup-days` | Function | Config: Modifies the threshold in days before exports are automatically deleted [Usage: mt-set-auto-cleanup-days 7] |
| `mt-set-claude-version` | Function | Config: Set Claude model version [Usage: smt-set-claude-version "claude-3-7-sonnet-latest"] |
| `mt-set-default-ai` | Function | Config: Set default AI model [Usage: mt-set-default-ai "gemini\|claude"] |
| `mt-set-default-ide` | Function | Config: Set default IDE [Usage: mt-set-default-ide "vscode\|intellij"] |
| `mt-set-gemini-version` | Function | Config: Set Gemini model version [Usage: mt-set-gemini-version "gemini-1.5-pro"] |
| `mt-set-local-ai-api-key` | Function | Config: Set Local AI API key [Usage: mt-set-local-ai-api-key ["key"]] |
| `mt-set-local-ai-model` | Function | Config: Set Local AI model [Usage: mt-set-local-ai-model "llama3.2"] |
| `mt-set-local-ai-url` | Function | Config: Set Local AI base URL [Usage: mt-set-local-ai-url "http://localhost:11434/v1"] |
| `mt-set-theme` | Function | Config: Set terminal color theme [Usage: mt-set-theme "theme_name"] |
| `mt-toggle-ai` | Function | Config: Toggle global AI prompt and integration true/false |
| `mt-toggle-auto-cleanup` | Function | Config: Toggle export file background cleanup script [Usage: mt-toggle-auto-cleanup] |
| `mt-toggle-gemini-extended` | Function | Config: Toggle Gemini extended mode true/false |

### [Container Orchestration]

| Command | Type | Description |
| --- | --- | --- |
| `kubectl` | Function | Kubectl wrapper (preserves args) |

### [Container Orchestration (Kubernetes)]

| Command | Type | Description |
| --- | --- | --- |
| `kns` | Function | Kubernetes: Get or explicitly set the active namespace in the current context |

### [Development & Build Tools]

| Command | Type | Description |
| --- | --- | --- |
| `boot-run` | Alias | Spring Boot: Run application |
| `mci` | Alias | Maven: Clean and Install |
| `pip-load` | Alias | Install pip requirements |
| `pip-save` | Alias | Save pip requirements |
| `ruff-fmt` | Alias | Ruff: Format Python files and imports in current directory (recursive) |
| `shfmtlw` | Alias | shfmt: Format all shell scripts in current directory (recursive) |
| `venv-make` | Alias | Create & active Python venv |
| `venv-up` | Alias | Activate existing Python venv |

### [GCP: Configuration & Authentication]

| Command | Type | Description |
| --- | --- | --- |
| `gcl-config` | Function | GCP: List active configuration properties |
| `gcl-export-vars` | Function | GCP: Export PROJECT_ID and PROJECT_NUMBER env vars to shell |
| `gcl-get-project` | Function | GCP: Print active project ID |
| `gcl-get-project-number` | Function | GCP: Print active project Number (API call required) |
| `gcl-get-region` | Function | GCP: Print active compute region |
| `gcl-get-user` | Function | GCP: Print active user account |
| `gcl-get-zone` | Function | GCP: Print active compute zone |
| `gcl-org-policies` | Function | GCP: List org policies for active project |
| `gcl-update` | Function | GCP: Update Google Cloud CLI tools |
| `gcp-login` | Function | GCP: Login to user & application default |
| `gcp-login-adc` | Function | GCP: Login to application default only |
| `gcp-set-project` | Function | GCP: Switch active project |
| `gcpp` | Alias | GCP: Legacy shortcut to set project |

### [GCP: Resources & Services]

| Command | Type | Description |
| --- | --- | --- |
| `bq-ls` | Alias | BigQuery: List datasets in project |
| `bq-query` | Function | BigQuery: Run standard SQL query |
| `gce-ls` | Alias | Compute: List all VM instances |
| `gce-ssh` | Alias | Compute: SSH into an instance |
| `gcl-as-json` | Function | Run gcloud command and output as formatted JSON |
| `gcl-gar-ls` | Alias | Artifacts: List Artifact Registry repos |
| `gcl-iam-ls` | Alias | IAM: List service accounts in active project |
| `gcl-ps-subs` | Alias | PubSub: List subscriptions |
| `gcl-ps-topics` | Alias | PubSub: List topics |
| `gcp-crf-logs` | Function | Functions: Tail logs of a function |
| `gcp-crf-ls` | Alias | Functions: List Cloud Run Functions |
| `gcp-gar-docker` | Function | Artifacts: Configure Docker auth |
| `gcp-get-secret` | Function | Secrets: Read latest payload of a secret |
| `gcp-iam-show` | Function | IAM: View IAM policy for active project |
| `gcp-ps-pull` | Function | PubSub: Pull and auto-ack one message |
| `gcs-ls` | Alias | GCS: List buckets or contents |

### [Google Style Code Formatting]

| Command | Type | Description |
| --- | --- | --- |
| `google-fmt` | Function | Formats Python and Shell scripts according to Google Style Guides. |

### [Infrastructure as Code]

| Command | Type | Description |
| --- | --- | --- |
| `__ai_build_context` | Function | Compiles local codebase files into a single context document for LLMs. |
| `__ai_extract_json_array` | Function | AI: Extracts a JSON array from raw LLM output text |
| `__ai_parse_response` | Function | AI: Parses standard single JSON object response and saves if needed. |
| `__ai_query_claude` | Function | Formats payload and queries the Anthropic Claude API. |
| `__ai_query_gemini` | Function | Formats payload and queries the Google Gemini API. |
| `__ai_query_local` | Function | Formats payload and queries a local LLM endpoint (OpenAI-compatible). |
| `__ai_save_output` | Function | Formats and saves the generated code from LLMs into standard directories. |
| `_ai_get_next_version` | Function | Calculates the next available minor patch version for a generated file. |
| `ai` | Function | Consult universal AI |
| `tf-val-all` | Function | Terraform: Recursively validate and scan all Terraform directories |

### [LLM Code Export Utilities]

| Command | Type | Description |
| --- | --- | --- |
| `mt-copy` | Function | LLM: Copy a file or directory tree to clipboard with headers and extension filters |
| `mt-export` | Function | LLM: Exports all text/code files [Usage: mt-export [-d subdir]] |
| `mt-export-cleanup` | Function | LLM: Clean up export files |
| `mt-export-cloudrun` | Function | LLM: Exports Python GCF codebase [Usage: mt-export-cloudrun [-d subdir]] |
| `mt-export-shell` | Function | LLM: Exports local .sh files [Usage: mt-export-shell [-d subdir]] |
| `mt-export-terraform` | Function | LLM: Exports local TF codebase [Usage: mt-export-terraform [-d subdir]] |

### [Modern CLI Replacements]

| Command | Type | Description |
| --- | --- | --- |
| `cat` | Alias | bat: Print file contents with syntax highlighting |
| `ccat` | Alias | bat: Print file contents with line numbers & Git gutters |
| `json-fmt` | Alias | Pretty-print JSON stream |
| `ll` | Alias | eza: Detailed list with Git status |
| `ls` | Alias | eza: List files with directories first |
| `rg` | Alias | rg: Search with smart case, include hidden, ignore .git |
| `tree` | Alias | eza: Display directory structure as a tree |
| `yaml-fmt` | Alias | Pretty-print YAML stream (requires yq) |

### [MyTools Documentation & Runner]

| Command | Type | Description |
| --- | --- | --- |
| `__bashd_latest_mod` | Function | Prints the most recent mtime across all .bash.d/*.sh files, used to |
| `mt-aliases` | Function | MyTools: List all documented shell aliases |
| `mt-cat` | Function | MyTools: List all tools within a specific category |
| `mt-cats` | Function | MyTools: List all available command categories |
| `mt-config` | Function | MyTools: Display active framework configuration variables |
| `mt-funcs` | Function | MyTools: List all documented shell functions |
| `mt-fzf` | Function | MyTools: Interactive fuzzy-finder to search for a command |
| `mt-get-version` | Function | System: Print the current local version of the terminal profile |
| `mt-help` | Function | MyTools: Display detailed help and source code for a command |
| `mt-refresh-caches` | Function | System: Forcefully clear and rebuild all background caches (.env, mytools, updates) |
| `mt-run` | Function | MyTools: Interactive fuzzy-finder to select and execute a command |
| `mt-search` | Function | MyTools: Search for a specific tool by keyword |
| `mytools` | Function | MyTools: Primary runner and documentation index |

### [Path & URL Launchers (Config-Driven)]

| Command | Type | Description |
| --- | --- | --- |
| `cd-ai` | Function | Config: Change directory to unified AI workspace |
| `cd-mt-git-local` | Function | Config: Change directory to sync repository root |
| `cd-win-docker` | Function | Docker: Change to Docker directory (from config.yaml) and open in Windows Explorer |
| `ide` | Function | Config: Open current directory in the default IDE (VSCode/IntelliJ) |
| `mt-open-homepage` | Function | Config: Open sync repository remote URL in default web browser |
| `win-ai` | Function | Config: Open unified AI workspace in the platform's native file manager |
| `win-docker` | Function | Config: Open Docker root directory in the platform's native file manager |
| `win-sync` | Function | Config: Open sync repository in the platform's native file manager |

### [System & Environment Bootstrap]

| Command | Type | Description |
| --- | --- | --- |
| `bootstrap` | Function | System: Bootstrap missing dependencies for bash aliases (Debian/WSL via APT, macOS via Homebrew) |
| `sys-install` | Function | System: Updates system packages and clears the pending-update marker |
| `sys-update` | Function | System: Updates system packages (APT on Debian/WSL, Homebrew on macOS) |

### [System & Navigation]

| Command | Type | Description |
| --- | --- | --- |
| `cdbashd` | Alias | Change directory to ~/.bash.d |
| `cdvcs` | Alias | Change directory to ~/vcs |
| `cdvcsp` | Alias | Change directory to ~/vcs/personal |
| `clip` | Function | Pipe output to the system clipboard (e.g. cat file \| clip) |
| `mt` | Alias | Print all aliases and functions |
| `reload` | Alias | Reload Bash profile |
| `sys-install-reload` | Alias | Update, Upgrade, Boostrap, Reload |
| `win` | Function | Open current directory in the platform's native file manager |
| `win-export` | Function | Open ~/vcs/personal/exports in the platform's native file manager |
| `win-vcs` | Function | Open ~/vcs in the platform's native file manager |

### [System Update Check]

| Command | Type | Description |
| --- | --- | --- |
| `__check_profile_updates` | Function | System: Asynchronously check for profile updates from the remote repository |

### [Terraform]

| Command | Type | Description |
| --- | --- | --- |
| `tf-clean` | Function | Terraform: Aggressively clean local caching (.terraform, locks, plans) |
| `tf-iam` | Function | Terraform: Ask AI to list required Service Accounts and least-privilege roles |
| `tf-replace` | Function | Terraform: Replace a specific resource (Modern alternative to taint) |
| `tf-yaml` | Function | Terraform: Wrapper to execute Terraform using a YAML config file for variables |

### [Terraform & Kubernetes Wrappers]

| Command | Type | Description |
| --- | --- | --- |
| `terraform` | Function | Terraform wrapper (preserves args) |
| `tf-scan` | Alias | Checkov: Scan local terraform directory (./terraform) |

### [Version Control (Git)]

| Command | Type | Description |
| --- | --- | --- |
| `git` | Function | Git: Wrapper to force 'clone' into ~/vcs/ from anywhere |
| `git-clean-merged` | Function | Git: Delete dead or stale branches that have been merged into the default branch |
| `git-clone-ide` | Function | Git: Clone a repository into ~/vcs/, cd into it, and open in IDE |
| `git-default-rebase` | Function | Git: Fetch upstream and rebase the current branch onto the default branch |
| `git-new-feature` | Function | Git: Create and checkout a new feature branch |
| `git-nuke` | Function | Git: Hard reset and wipe all untracked files on the current branch |
| `git-pretty-log` | Function | Git: Print a beautiful, color-coded, single-line graph log |
| `git-raise-pr` | Function | Git: Push branch and create a Pull Request (GitHub/Bitbucket/GitLab) |
| `git-view-remote` | Function | Git: Open the current repository in the default web browser |

### [Version Control (Git) - AI Workflows]

| Command | Type | Description |
| --- | --- | --- |
| `__git_ai_preflight_check` | Function | Git: Preflight safety checks for AI file generation |
| `__git_sync_ai_commit` | Function | Analyzes git diffs and calls the Gemini API to systematically generate |
| `git-ai-push-all` | Function | Git: Add all files, intelligently group via AI, and push [Usage: git-ai-push-all [optional message]] |
| `mt-ai-gitignore` | Function | Git: Ask AI to generate a comprehensive .gitignore for the current project |
| `mt-ai-readme` | Function | Git: Ask AI to generate a comprehensive README.md for the current project |

### [Version Control (Git) - Profile Synchronization]

| Command | Type | Description |
| --- | --- | --- |
| `__git_sync_copy_files` | Function | Synchronizes the active bash config files over to the tracked git directory. |
| `__git_sync_init_repo` | Function | Clones and initializes a repository into the sync directory. |
| `mt-download-release` | Function | System: Download a release zip from the remote repository [Usage: mt-download-release [-v version] [-d directory]] |
| `mt-get-update` | Function | System: Download and install profile updates from GitHub releases [Usage: mt-get-update [-v version]] |
| `mt-push-update` | Function | Git: Sync local bash configs to terminal repo and create a Pull Request |

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
