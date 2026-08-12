# GCP DevOps WSL2 Debian Terminal

A high-performance, fully modular Bash environment engineered specifically for Senior Cloud, Platform, and DevOps Engineers. Runs natively on Windows Subsystem for Linux (WSL2) Debian and on macOS, with the platform auto-detected at shell startup — the same profile and command set works unmodified on both.

This configuration adheres to DRY principles, relies on native Bash and standalone Python script execution for zero-latency loading, and aggregates modern CLI tools for Google Cloud Platform, Kubernetes, Terraform, and Python development.

## 📋 Prerequisites

Before installing this terminal environment, ensure your local workstation meets the following baseline requirements:

*   **WSL2 (Debian):** This environment is explicitly built and tested for Windows Subsystem for Linux 2 running the **Debian** distribution.
*   **Visual Studio Code:** Required for seamless IDE integration. Ensure the **WSL Extension** is installed so the `code .` CLI triggers route correctly from the WSL file system to your Windows host.
*   **VSCode Extension Pack:** It is highly recommended to install the standardized extension pack to ensure all linting, formatting, and infrastructure integrations (like Terraform and Checkov) function perfectly alongside this terminal environment. You can install it from the dedicated repository here: [MatStacey/vscode-ext-pack](https://github.com/MatStacey/vscode-ext-pack).
*   **Git:** Required to clone the initial repository and handle ongoing AI-assisted profile synchronization.

---

## 🚀 Key Features

* **Cross-Platform (WSL2 Debian & macOS):** A single `OS_FAMILY` auto-detection layer (`00-os.sh`) transparently swaps out platform-specific behavior — `explorer.exe` ↔ `open`, `clip.exe` ↔ `pbcopy`, APT ↔ Homebrew, `batcat` ↔ `bat` — so every command works unmodified on either OS. WSL remains the primary target; macOS support is additive and degrades gracefully on plain Linux too.
* **Zero-Lag Dynamic Prompt:** Real-time, color-coded Git status, Kubernetes context, and GCP project/account tracking utilizing zero-subshell file reads for maximum performance. Includes OSC 8 clickable hyperlinking for Git branches and GCP consoles.
* **Asynchronous Update Checks:** Silently checks for package updates (APT on WSL/Debian, Homebrew on macOS) in the background on a configurable TTL timer without blocking terminal initialization, prompting only when updates are ready.
* **Decoupled Python Configuration:** A dedicated standalone Python manager (`lib/config_manager.py`) reads `~/.bash.d/config/config.yaml` to dynamically inject customizable directory paths, API keys, and remote repository URLs directly into the shell environment.
* **Modular Theme Engine:** Color themes are fully externalized into standalone files under `~/.bash.d/config/themes/`, allowing custom aesthetic definitions and instant switching via an interactive `fzf` menu (`mt-theme`).
* **Automated Bootstrapping:** Built-in `bootstrap` function automatically resolves and installs required packages — APT on WSL/Debian, Homebrew (installed automatically if missing) on macOS — including Python linters (`ruff`, `checkov`), formatters (`yapf`, `shfmt`), and modern CLI binaries (`yq`, `eza`, `bat`/`batcat`).
* **Native AI Integration:** Consult universal AI via the `ai` command with model selection (`flash`, `flash-lite`, `pro`), extended reasoning flags (`-x`), targeted file context parsing (`-f`), and automated version-controlled payload exports into a unified workspace (`AI_WORKSPACE_DIR`).
* **Multi-Threaded Validation:** The `tf-val-all` command leverages `xargs -P` with configurable thread limits to concurrently validate and run Checkov security scans across all Terraform modules.
* **Advanced LLM Export Utilities:** Integrated, regex-filtered export commands (`export-all`, `export-tf`, `export-bash`, `export-crf`) designed to safely compile text representations of local codebases for AI prompting, managed via a unified pruning utility (`cleanup-exports`).
* **Dynamic Documentation & Search:** The `mt` (mytools) command utilizes an advanced AWK parser to dynamically index and display a formatted help manual, supported by interactive fuzzy-finding (`mt-run`, `mt-fzf`), keyword searching (`mt-search`), and syntax-highlighted command inspection (`mt-help`).

---

## 🛠️ Setup & Bootstrapping

1. **Clone the repository** to your local WSL2 or macOS machine.
2. **Run the installation script** to automatically back up existing profiles, scaffold configurations, and sync files:
```bash
./install.sh

```

3. **Bootstrap system dependencies:** Run the included utility to automatically install required packages and detect missing infrastructure binaries:

```bash
bootstrap

```

**macOS-specific note:** You do not need to pre-install Homebrew — `bootstrap` detects macOS via `OS_FAMILY` and installs Homebrew automatically (via the official install script) if `brew` isn't already on your `PATH`, then uses it to install the same tool set APT provides on WSL/Debian (`jq`, `fzf`, `ripgrep`, `bat`, `rsync`, `shfmt`, `yq`, `eza`, `zoxide`, etc.). If you'd rather install Homebrew yourself first, `bootstrap` will simply detect and use the existing installation.

---

## 📂 Directory Structure

The configuration abandons a monolithic `~/.bashrc` in favor of a logical `.bash.d/` directory structure.

| Module | Description |
| --- | --- |
| `00-core/` | Core configuration, centralized dynamic color themes, prompts, update checking, mytools engine, and bootstrapping utilities. |
| `10-infra/` | GCP authentication/project switchers, concurrent Terraform validation, and comprehensive Kubectl aliases. |
| `20-vcs/` | Git wrappers, AI-assisted feature-grouped commit automation (`git-ai-pc`), profile syncing, and web launching. |
| `30-ai/` | API integrations for interacting with Google Gemini and Anthropic Claude via the universal `ai` command. |
| `config/` | JSON/YAML files, `.env` caching, and modular theme definitions (`config/themes/`). |
| `lib/` | AWK parsers (`mytools.awk`), configuration templates, and standalone Python utility scripts (`config_manager.py`). |

---

## 🧰 Command Reference (MyTools)

The following commands are automatically parsed and indexed from codebase documentation blocks.

### ⚙️ Core System & Environment

#### System & Environment Bootstrap

| Command | Type | Description |
| --- | --- | --- |
| `bootstrap` | Function | System: Bootstrap missing dependencies for bash aliases (Debian/WSL). |

#### Configuration Management

| Command | Type | Description |
| --- | --- | --- |
| `add-claude-key` | Function | Adds a Claude API key to the local YAML configuration. |
| `add-gemini-key` | Function | Adds a Gemini API key to the local YAML configuration. |
| `add-sync-url` | Function | Configures the remote git URL for the bash profile synchronization tool. |
| `open-bashd-config` | Function | Opens the bash.d configuration directory directly in the configured IDE. |
| `set-auto-cleanup-days` | Function | Modifies the threshold in days before exports are automatically deleted. |
| `set-claude-version` | Function | Sets the default Claude model version in configuration. |
| `set-default-ai` | Function | Sets the default LLM provider for the 'ai' command suite. |
| `set-default-ide` | Function | Sets the default local IDE for launch commands. |
| `set-gemini-version` | Function | Sets the default Gemini model version in configuration. |
| `toggle-auto-cleanup` | Function | Toggles the background execution of the export cleanup script. |
| `toggle-gemini-extended` | Function | Toggles the Gemini extended reasoning mode flag. |

#### Centralized Theme & Colors

| Command | Type | Description |
| --- | --- | --- |
| `mt-theme` | Function | Opens an interactive fuzzy-finder menu to select and apply a theme. |
| `set-theme` | Function | Sets the active terminal color theme and reloads the color profile. |

#### System & Navigation

| Command | Type | Description |
| --- | --- | --- |
| `cdbashd` | Alias | Change directory to ~/.bash.d. |
| `cdvcs` | Alias | Change directory to ~/vcs. |
| `cdvcsp` | Alias | Change directory to ~/vcs/personal. |
| `clip` | Alias | Pipe output to Windows clipboard (e.g. cat file | clip). |
| `mt` | Alias | Print all aliases and functions. |
| `reload` | Alias | Reload Bash profile. |
| `rld` | Alias | Reload Bash profile. |
| `sys-install-reload` | Alias | Update, Upgrade, Boostrap, Reload. |
| `sys-update` | Alias | Updates Debian/Ubuntu packages. |

#### Path & URL Launchers (Config-Driven)

| Command | Type | Description |
| --- | --- | --- |
| `cd-ai` | Function | Config: Change directory to unified AI workspace. |
| `cd-sync` | Function | Config: Change directory to sync repository root. |
| `sync-web` | Function | Config: Open sync repository remote URL in default web browser. |
| `win` | Alias | Open current WSL dir in Windows Explorer. |
| `win-ai` | Function | Config: Open unified AI workspace in Windows File Explorer. |
| `win-export` | Alias | Open ~/vcs/personal/exports Windows Explorer. |
| `win-sync` | Function | Config: Open sync repository in Windows File Explorer. |
| `win-vcs` | Alias | Open ~/vcs Windows Explorer. |

---

### ☁️ Cloud & Infrastructure

#### GCP: Configuration & Authentication

| Command | Type | Description |
| --- | --- | --- |
| `gcl-config` | Function | GCP: List active configuration properties. |
| `gcl-export-vars` | Function | GCP: Export PROJECT_ID and PROJECT_NUMBER env vars to shell. |
| `gcl-get-project` | Function | GCP: Print active project ID. |
| `gcl-get-project-number` | Function | GCP: Print active project Number (API call required). |
| `gcl-get-region` | Function | GCP: Print active compute region. |
| `gcl-get-user` | Function | GCP: Print active user account. |
| `gcl-get-zone` | Function | GCP: Print active compute zone. |
| `gcl-org-policies` | Function | GCP: List org policies for active project. |
| `gcl-update` | Function | GCP: Update Google Cloud CLI tools. |
| `gcp-login` | Function | GCP: Login to user & application default. |
| `gcp-login-adc` | Function | GCP: Login to application default only. |
| `gcpp` | Alias | GCP: Legacy shortcut to set project. |
| `gcp-set-project` | Function | GCP: Switch active project. |

#### GCP: Resources & Services

| Command | Type | Description |
| --- | --- | --- |
| `bq-ls` | Alias | BigQuery: List datasets in project. |
| `bq-query` | Function | BigQuery: Run standard SQL query. |
| `gce-ls` | Alias | Compute: List all VM instances. |
| `gce-ssh` | Alias | Compute: SSH into an instance. |
| `gcl-as-json` | Function | Run gcloud command and output as formatted JSON. |
| `gcl-gar-ls` | Alias | Artifacts: List Artifact Registry repos. |
| `gcl-iam-ls` | Alias | IAM: List service accounts in active project. |
| `gcl-ps-subs` | Alias | PubSub: List subscriptions. |
| `gcl-ps-topics` | Alias | PubSub: List topics. |
| `gcp-crf-logs` | Function | Functions: Tail logs of a function. |
| `gcp-crf-ls` | Alias | Functions: List Cloud Run Functions. |
| `gcp-gar-docker` | Function | Artifacts: Configure Docker auth. |
| `gcp-get-secret` | Function | Secrets: Read latest payload of a secret. |
| `gcp-iam-show` | Function | IAM: View IAM policy for active project. |
| `gcp-ps-pull` | Function | PubSub: Pull and auto-ack one message. |
| `gcs-ls` | Alias | GCS: List buckets or contents. |

#### Infrastructure as Code (Terraform)

| Command | Type | Description |
| --- | --- | --- |
| `terraform` | Function | Terraform wrapper (preserves args). |
| `tf` | Alias | Terraform: Base command. |
| `tfa` | Alias | Terraform: Apply deployment. |
| `tfd` | Alias | Terraform: Destroy resources. |
| `tff` | Alias | Terraform: Format all TF files recursively. |
| `tfp` | Alias | Terraform: Plan deployment. |
| `tf-scan` | Alias | Checkov: Scan local terraform directory (./terraform). |
| `tf-val-all` | Function | Terraform: Recursively validate and scan all Terraform directories. |

#### Container Management (Docker)

| Command | Type | Description |
| --- | --- | --- |
| `docker-ls` | Function | Lists all running Docker containers in a clean, readable table format. |
| `docker-nuke` | Function | Aggressively cleans up your local Docker environment by pruning all stopped containers, dangling images, unused networks, and orphaned volumes to reclaim WSL2 disk space. |
| `docker-reboot-all` | Function | Gracefully restarts running Docker containers, respecting the persistent `docker.restart_blocklist` defined in `config.yaml`. |
| `docker-sandbox` | Function | Instantly spins up a temporary, throwaway container that automatically deletes itself (`--rm`) the moment you exit the shell. |
| `docker-shell` | Function | Launches an interactive fuzzy-finder (`fzf`) menu to instantly drop you into a bash/sh terminal inside the selected container. |
| `docker-tail` | Function | Multi-select (`TAB`) several containers via `fzf` to concurrently tail their logs. Streams are prefixed with color-coded container names for easy real-time reading. |

#### Container Orchestration (Kubernetes)

| Command | Type | Description |
| --- | --- | --- |
| `k` | Alias | `kubectl` |
| `ka` / `kak` | Aliases | `kubectl apply -f` and `kubectl apply -k` |
| `krm` / `krmf` | Aliases | `kubectl delete` and `kubectl delete -f` |
| `kg*` | Aliases | Get resources (`kgpo`, `kgdep`, `kgsvc`, `kging`, `kgcm`, `kgsec`, `kgno`, `kgns`, `kgall`) |
| `kd*` | Aliases | Describe resources (`kdpo`, `kddep`, `kdsvc`, `kding`, `kdcm`, `kdsec`, `kdno`) |
| `klo` / `klop` | Aliases | Tail logs (`kubectl logs -f`) / tail previous container (`-p`) |
| `kex` | Alias | Exec interactively (`kubectl exec -i -t`) |
| `kpf` | Alias | Port forward (`kubectl port-forward`) |
| `ksys` | Alias | Execute command explicitly in `kube-system` namespace |
| `kns` | Function | View or interactively set (`TAB` completion) the default namespace context |

---

### 💻 Development & Workflows

#### Version Control (Git)

| Command | Type | Description |
| --- | --- | --- |
| `git` | Function | Wrapper to force 'clone' into `~/vcs/` from anywhere. |
| `git-ai-pc` | Function | Add all files, intelligently group via AI, and push. |
| `git-cleanup` | Function | Safely delete all local branches that have been merged into the default branch. |
| `git-feature` | Function | Create and checkout a new feature branch using the configured prefix. |
| `git-ide` | Function | Clone a repository into `~/vcs/`, `cd` into it, and open in IDE. |
| `git-lg` | Function | Print a beautiful, color-coded, single-line graph log. |
| `git-nuke` | Function | Hard reset and wipe all untracked files on the current branch (includes safety prompt). |
| `git-update` | Function | Fetch upstream and rebase the current branch onto the default branch. |
| `git-web` | Function | Open the current repository in the default Windows web browser. |
| `vcs-sync-profile` | Function | Sync local bash configs to terminal repo and push (AI-powered systematic commits). |

#### Development & Build Tools

| Command | Type | Description |
| --- | --- | --- |
| `boot-run` | Alias | Spring Boot: Run application. |
| `mci` | Alias | Maven: Clean and Install. |
| `pip-load` | Alias | Install pip requirements. |
| `pip-save` | Alias | Save pip requirements. |
| `venv-make` | Alias | Create & active Python venv. |
| `venv-up` | Alias | Activate existing Python venv. |

#### Code Formatting

| Command | Type | Description |
| --- | --- | --- |
| `google-fmt` | Function | Formats Python and Shell scripts according to Google Style Guides. |
| `ruff-fmt` | Alias | Ruff: Format Python files and imports in current directory (recursive). |
| `shfmtlw` | Alias | shfmt: Format all shell scripts in current directory (recursive). |

#### Modern CLI Replacements

| Command | Type | Description |
| --- | --- | --- |
| `cat` | Alias | bat: Print file contents with syntax highlighting. |
| `ccat` | Alias | bat: Print file contents with line numbers & Git gutters. |
| `json-fmt` | Alias | Pretty-print JSON stream. |
| `ll` | Alias | eza: Detailed list with Git status. |
| `ls` | Alias | eza: List files with directories first. |
| `rg` | Alias | rg: Search with smart case, include hidden, ignore .git. |
| `tree` | Alias | eza: Display directory structure as a tree. |
| `yaml-fmt` | Alias | Pretty-print YAML stream (requires yq). |

#### Universal AI & LLM Utilities

| Command | Type | Description |
| --- | --- | --- |
| `ai` | Function | Consult universal AI. |
| `__ai_build_context` | Function | Compiles local codebase files into a single context document for LLMs. |
| `_ai_get_next_version` | Function | Calculates the next available minor patch version for a generated file. |
| `__ai_query_claude` | Function | Formats payload and queries the Anthropic Claude API. |
| `__ai_query_gemini` | Function | Formats payload and queries the Google Gemini API. |
| `__ai_save_output` | Function | Formats and saves the generated code from LLMs into standard directories. |
| `cleanup-exports` | Function | LLM: Clean up export files. |
| `export-all` | Function | LLM: Exports all text/code files. |
| `export-bash` | Function | LLM: Exports local .sh files. |
| `export-crf` | Function | LLM: Exports Python GCF codebase. |
| `export-tf` | Function | LLM: Exports local TF codebase. |