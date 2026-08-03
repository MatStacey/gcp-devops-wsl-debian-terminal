# GCP DevOps WSL2 Debian Terminal

A high-performance, fully modular Bash environment engineered specifically for Senior Cloud, Platform, and DevOps Engineers working within Windows Subsystem for Linux (WSL2) Debian. 

This configuration adheres to DRY principles, relies on native Bash parsing for zero-latency prompt rendering, and aggregates modern CLI tools for Google Cloud Platform, Kubernetes, Terraform, and Python development.

## 🚀 Key Features

*   **Zero-Lag Dynamic Prompt:** Real-time, color-coded Git status, Kubernetes context, and GCP project/account tracking utilizing zero-subshell file reads for maximum performance. Includes OSC 8 clickable hyperlinking for Git branches and GCP consoles.
*   **Automated Bootstrapping:** Built-in `bootstrap-deps` function automatically resolves and installs required APT packages, Python linters (`ruff`, `checkov`), formatters (`shfmt`), and binaries (`yq`).
*   **Git Workflow Enforcement:** Wraps the native `git clone` command to enforce cloning all repositories directly into `~/vcs/`.
*   **Multi-Threaded Validation:** The `tf-val-all` command leverages `xargs -P` to concurrently validate and run Checkov security scans across all Terraform modules.
*   **LLM Export Utilities:** Integrated, regex-filtered export commands (`tf-export`, `gcf-export`) designed to safely compile text representations of local codebases for AI prompting without leaking secrets.
*   **Dynamic Documentation:** The `mt` (mytools) command utilizes a dedicated AWK parser to read inline script headers and automatically generate a beautifully formatted, categorized help manual.

---

## 📂 Directory Structure

The configuration abandons a monolithic `~/.bashrc` in favor of a logical `.bash.d/` directory structure. 

| Module | Description |
| :--- | :--- |
| `10-prompt.sh` | Custom PS1 generation with Git, GCP, and K8s integrations. |
| `20-aliases.sh` | Navigation, WSL interop, formatting tools, and modern CLI overrides (`eza`, `batcat`, `rg`). |
| `30-gcp.sh` | Extends `gcloud` with fuzzy project switching (`gc-switch`), native config parsing, and unified `gc-` shortcuts. |
| `40-terraform-k8s.sh` | Core Terraform/Kubernetes overrides, concurrent validation utilities, and shell completion injections. |
| `41-terraform-aliases.sh` | Exhaustive shorthand shortcuts for Terraform operations. |
| `42-kubectl-aliases.sh` | Exhaustive shorthand shortcuts for Kubectl operations across all resource types. |
| `50-git.sh` | Git wrappers, commit automation (`git-acp`), feature branching (`git-feat`), and repo cloning rules. |
| `99-utils.sh` | System bootstrappers, codebase exporters, self-syncing commands, and help function wrappers. |
| `mytools.awk` | Standalone parsing engine that dynamically builds the terminal help menu. |

---

## 🛠️ Setup & Bootstrapping

1.  **Clone the repository** to your local WSL2 machine.
2.  **Sync the configuration** to your home directory:
    ```bash
    rsync -a .bashrc ~/
    rsync -a --delete .bash.d/ ~/.bash.d/
    source ~/.bashrc
    ```
3.  **Bootstrap system dependencies:**
    Run the included utility to automatically install required packages (`jq`, `fzf`, `ripgrep`, `bat`, `rsync`, `ruff`, `checkov`, `shfmt`, `yq`) and detect missing infrastructure binaries:
    ```bash
    bootstrap-deps
    ```

---

## 💡 Highlighted Commands

### System & Help
*   `mt` / `mytools`: Dynamically parses all loaded `.sh` modules and prints a formatted, color-coded manual of all available custom functions and aliases.
*   `bash-sync "<msg>"`: Syncs `~/.bashrc` and `~/.bash.d/` back to this git repository, commits the changes, and pushes to remote in one command.
*   `sys-install-reload`: Updates apt packages, bootstraps missing dependencies, and reloads the bash profile in one go.

### Formatting (`-fmt`)
*   `sh-fmt`: Recursively formats all shell scripts in the current directory using `shfmt`.
*   `ruff-fmt`: Recursively fixes and formats Python files using `ruff`.
*   `json-fmt` / `yaml-fmt`: Pretty-prints JSON and YAML data streams.

### Version Control (Git)
*   `git clone <url>`: Intercepted by a wrapper function. Automatically creates the `~/vcs` directory, clones the target into it, and provides a quick-access `cd` hint.
*   `git-acp "<message>"`: Adds all files, commits, and pushes to remote.
*   `git-feat <JIRA-ID>`: Automates the creation and checkout of `feature/<JIRA-ID>` branches.

### Google Cloud Platform
*   `gc-switch`: Interactive, fuzzy-finder (fzf) project switcher.
*   `gc-export-vars`: Resolves and exports both `PROJECT_ID` and `PROJECT_NUMBER` as system environment variables.
*   `gce-ls` / `gce-ssh`: List Compute Engine instances and SSH directly into them.
*   `gc-sec-read <secret>`: Instantly prints the latest payload of a Secret Manager secret.

### Infrastructure as Code
*   `tf-val-all`: Recursively initializes and validates all Terraform modules in the repository.
*   `tf-scan`: Executes a Checkov security scan against the local Terraform directory.

### LLM Export Utilities
Safely compile codebases into a single `txt` file for LLM context, utilizing regex allow-lists for extensions and block-lists for sensitive data (secrets, tokens, keys).
*   `tf-export`: Compiles `.tf`, `.sh`, `.yaml`, `.json`, and `.md` files.
*   `gcf-export`: Compiles Python Cloud Run Function repos (strips `__pycache__`, `.egg-info`, `.pyc`).
*   `bash-export`: Compiles local shell script repositories.
