# MT DevOps Framework - Command Reference

This document is automatically generated on every sync and lists all available framework functions and aliases.

| Type | Category | Command | Description |
|---|---|---|---|
| alias | Development & Build Tools | `boot-run` | Spring Boot: Run application |
| alias | Development & Build Tools | `mci` | Maven: Clean and Install |
| alias | Development & Build Tools | `pip-load` | Install pip requirements |
| alias | Development & Build Tools | `pip-save` | Save pip requirements |
| alias | Development & Build Tools | `ruff-fmt` | Ruff: Format Python files and imports in current directory (recursive) |
| alias | Development & Build Tools | `shfmtlw` | shfmt: Format all shell scripts in current directory (recursive) |
| alias | Development & Build Tools | `venv-make` | Create & active Python venv |
| alias | Development & Build Tools | `venv-up` | Activate existing Python venv |
| alias | GCP: Configuration & Authentication | `gcpp` | GCP: Legacy shortcut to set project |
| alias | GCP: Resources & Services | `bq-ls` | BigQuery: List datasets in project |
| alias | GCP: Resources & Services | `gce-ls` | Compute: List all VM instances |
| alias | GCP: Resources & Services | `gce-ssh` | Compute: SSH into an instance |
| alias | GCP: Resources & Services | `gcl-gar-ls` | Artifacts: List Artifact Registry repos |
| alias | GCP: Resources & Services | `gcl-iam-ls` | IAM: List service accounts in active project |
| alias | GCP: Resources & Services | `gcl-ps-subs` | PubSub: List subscriptions |
| alias | GCP: Resources & Services | `gcl-ps-topics` | PubSub: List topics |
| alias | GCP: Resources & Services | `gcp-crf-ls` | Functions: List Cloud Run Functions |
| alias | GCP: Resources & Services | `gcs-ls` | GCS: List buckets or contents |
| alias | Modern CLI Replacements | `cat` | bat: Print file contents with syntax highlighting |
| alias | Modern CLI Replacements | `ccat` | bat: Print file contents with line numbers & Git gutters |
| alias | Modern CLI Replacements | `json-fmt` | Pretty-print JSON stream |
| alias | Modern CLI Replacements | `ll` | eza: Detailed list with Git status |
| alias | Modern CLI Replacements | `ls` | eza: List files with directories first |
| alias | Modern CLI Replacements | `rg` | rg: Search with smart case, include hidden, ignore .git |
| alias | Modern CLI Replacements | `tree` | eza: Display directory structure as a tree |
| alias | Modern CLI Replacements | `yaml-fmt` | Pretty-print YAML stream (requires yq) |
| alias | System & Navigation | `cd-bashd` | Change directory to ~/.bash.d |
| alias | System & Navigation | `cd-git-home` | Change directory to ~/vcs |
| alias | System & Navigation | `cd-git-personal` | Change directory to ~/vcs/personal |
| alias | System & Navigation | `mt` | Print all aliases and functions |
| alias | System & Navigation | `refresh` | Reload Bash profile |
| alias | System & Navigation | `reload` | Reload Bash profile |
| alias | System & Navigation | `sys-update-install` | Update, Upgrade, Boostrap, Reload |
| alias | Terraform & Kubernetes Wrappers | `tf-scan` | Checkov: Scan local terraform directory (./terraform) |
| func | Base64 Encoding & Decoding Utilities | `base64-dec` | Base64: Decode a Base64 string, file, or stream |
| func | Base64 Encoding & Decoding Utilities | `base64-enc` | Base64: Encode a string, file, or stream to Base64 |
| func | Base64 Encoding & Decoding Utilities | `docker-ls` | Docker: List all running containers in a clean table format |
| func | Base64 Encoding & Decoding Utilities | `docker-nuke` | Docker: Aggressive cleanup of all unused containers, images, and volumes |
| func | Base64 Encoding & Decoding Utilities | `docker-reboot-all` | Docker: Restart all currently running Docker containers |
| func | Base64 Encoding & Decoding Utilities | `docker-sandbox` | Docker: Spin up a temporary, throwaway container sandbox |
| func | Base64 Encoding & Decoding Utilities | `docker-shell` | Docker: Interactive fuzzy-finder to exec into a running container |
| func | Base64 Encoding & Decoding Utilities | `docker-tail` | Docker: Concurrently tail logs from multiple selected containers |
| func | Base64 Encoding & Decoding Utilities | `mt-log` | System: Centralized logging with colored output |
| func | Configuration Management | `mt-add-claude-key` | Config: Add Claude API key to config.yaml [Usage: mt-add-claude-key ["key"]] |
| func | Configuration Management | `mt-add-gemini-key` | Config: Add Gemini API key to config.yaml [Usage: mt-add-gemini-key ["key"]] |
| func | Configuration Management | `mt-add-sync-url` | Config: Add remote repository URL for bash sync [Usage: mt-add-sync-url "url"] |
| func | Configuration Management | `mt-get-gemini-status` | Prints the current Gemini API model version and extended reasoning mode toggle. |
| func | Configuration Management | `mt-open-config` | Config: Open bash.d directory and config.yaml in IDE [Usage: mt-open-config [-ide vscode|intellij]] |
| func | Configuration Management | `mt-select-theme` | Config: Interactive menu to select and apply a theme [Usage: mt-select-theme] |
| func | Configuration Management | `mt-set-auto-cleanup-days` | Config: Modifies the threshold in days before exports are automatically deleted [Usage: mt-set-auto-cleanup-days 7] |
| func | Configuration Management | `mt-set-claude-version` | Config: Set Claude model version [Usage: smt-set-claude-version "claude-3-7-sonnet-latest"] |
| func | Configuration Management | `mt-set-default-ai` | Config: Set default AI model [Usage: mt-set-default-ai "gemini|claude"] |
| func | Configuration Management | `mt-set-default-ide` | Config: Set default IDE [Usage: mt-set-default-ide "vscode|intellij"] |
| func | Configuration Management | `mt-set-gemini-version` | Config: Set Gemini model version [Usage: mt-set-gemini-version "gemini-1.5-pro"] |
| func | Configuration Management | `mt-set-local-ai-api-key` | Config: Set Local AI API key [Usage: mt-set-local-ai-api-key ["key"]] |
| func | Configuration Management | `mt-set-local-ai-model` | Config: Set Local AI model [Usage: mt-set-local-ai-model "llama3.2"] |
| func | Configuration Management | `mt-set-local-ai-url` | Config: Set Local AI base URL [Usage: mt-set-local-ai-url "http://localhost:11434/v1"] |
| func | Configuration Management | `mt-set-theme` | Config: Set terminal color theme [Usage: mt-set-theme "theme_name"] |
| func | Configuration Management | `mt-setup` | Config: Interactive First-Time Setup Wizard |
| func | Configuration Management | `mt-toggle-ai` | Config: Toggle global AI prompt and integration true/false |
| func | Configuration Management | `mt-toggle-auto-cleanup` | Config: Toggle export file background cleanup script [Usage: mt-toggle-auto-cleanup] |
| func | Configuration Management | `mt-toggle-gemini-extended` | Config: Toggle Gemini extended mode true/false |
| func | Container Orchestration | `kubectl` | Kubectl wrapper (preserves args) |
| func | Container Orchestration (Kubernetes) | `kns` | Kubernetes: Get or explicitly set the active namespace in the current context |
| func | GCP: Configuration & Authentication | `gcl-config` | GCP: List active configuration properties |
| func | GCP: Configuration & Authentication | `gcl-export-vars` | GCP: Export PROJECT_ID and PROJECT_NUMBER env vars to shell |
| func | GCP: Configuration & Authentication | `gcl-get-project` | GCP: Print active project ID |
| func | GCP: Configuration & Authentication | `gcl-get-project-number` | GCP: Print active project Number (API call required) |
| func | GCP: Configuration & Authentication | `gcl-get-region` | GCP: Print active compute region |
| func | GCP: Configuration & Authentication | `gcl-get-user` | GCP: Print active user account |
| func | GCP: Configuration & Authentication | `gcl-get-zone` | GCP: Print active compute zone |
| func | GCP: Configuration & Authentication | `gcl-org-policies` | GCP: List org policies for active project |
| func | GCP: Configuration & Authentication | `gcl-update` | GCP: Update Google Cloud CLI tools |
| func | GCP: Configuration & Authentication | `gcp-login-adc` | GCP: Login to application default only |
| func | GCP: Configuration & Authentication | `gcp-login` | GCP: Login to user & application default |
| func | GCP: Configuration & Authentication | `gcp-set-project` | GCP: Switch active project |
| func | GCP: Resources & Services | `bq-query` | BigQuery: Run standard SQL query |
| func | GCP: Resources & Services | `gcl-as-json` | Run gcloud command and output as formatted JSON |
| func | GCP: Resources & Services | `gcp-crf-logs` | Functions: Tail logs of a function |
| func | GCP: Resources & Services | `gcp-gar-docker` | Artifacts: Configure Docker auth |
| func | GCP: Resources & Services | `gcp-get-secret` | Secrets: Read latest payload of a secret |
| func | GCP: Resources & Services | `gcp-iam-show` | IAM: View IAM policy for active project |
| func | GCP: Resources & Services | `gcp-ps-pull` | PubSub: Pull and auto-ack one message |
| func | Google Style Code Formatting | `google-fmt` | Formats Python and Shell scripts according to Google Style Guides. |
| func | Infrastructure as Code | `ai` | AI: Send a prompt to the currently configured LLM |
| func | Infrastructure as Code | `ai-explain` | AI: Explain a shell command |
| func | Infrastructure as Code | `mt-ai-debug` | AI: Debug the last failed command |
| func | Infrastructure as Code | `tf-val-all` | Terraform: Recursively validate and scan all Terraform directories |
| func | LLM Code Export Utilities | `mt-copy` | LLM: Copy a file or directory tree to clipboard with headers and extension filters |
| func | LLM Code Export Utilities | `mt-export-cleanup` | LLM: Clean up export files |
| func | LLM Code Export Utilities | `mt-export-cloudrun` | LLM: Exports Python GCF codebase [Usage: mt-export-cloudrun [-d subdir] [-z]] |
| func | LLM Code Export Utilities | `mt-export` | LLM: Exports all text/code files [Usage: mt-export [-d subdir] [-z]] |
| func | LLM Code Export Utilities | `mt-export-shell` | LLM: Exports local .sh files [Usage: mt-export-shell [-d subdir] [-z]] |
| func | LLM Code Export Utilities | `mt-export-terraform` | LLM: Exports local TF codebase [Usage: mt-export-terraform [-d subdir] [-z]] |
| func | MyTools Documentation & Runner | `mt-aliases` | MyTools: List all documented shell aliases |
| func | MyTools Documentation & Runner | `mt-cat` | MyTools: List all tools within a specific category |
| func | MyTools Documentation & Runner | `mt-cats` | MyTools: List all available command categories |
| func | MyTools Documentation & Runner | `mt-config` | MyTools: Display active framework configuration variables |
| func | MyTools Documentation & Runner | `mt-funcs` | MyTools: List all documented shell functions |
| func | MyTools Documentation & Runner | `mt-fzf` | MyTools: Interactive fuzzy-finder to search for a command |
| func | MyTools Documentation & Runner | `mt-get-version` | System: Print the current local version of the terminal profile |
| func | MyTools Documentation & Runner | `mt-help` | MyTools: Display detailed help and source code for a command |
| func | MyTools Documentation & Runner | `mt-refresh-caches` | System: Forcefully clear and rebuild all background caches (.env, mytools, updates) |
| func | MyTools Documentation & Runner | `mt-run` | MyTools: Interactive fuzzy-finder to select and execute a command |
| func | MyTools Documentation & Runner | `mt-search` | Framework: Search through available mytools commands |
| func | MyTools Documentation & Runner | `mytools` | MyTools: Primary runner and documentation index |
| func | Path & URL Launchers (Config-Driven) | `cd-ai-workspace` | Config: Change directory to unified AI workspace |
| func | Path & URL Launchers (Config-Driven) | `cd-mt-git-local` | Config: Change directory to sync repository root |
| func | Path & URL Launchers (Config-Driven) | `cd-win-docker` | Docker: Change to Docker directory (from config.yaml) and open in Windows Explorer |
| func | Path & URL Launchers (Config-Driven) | `ide` | Config: Open current directory in the default IDE (VSCode/IntelliJ) |
| func | Path & URL Launchers (Config-Driven) | `mt-open-homepage` | Config: Open sync repository remote URL in default web browser |
| func | Path & URL Launchers (Config-Driven) | `win-ai-workspace` | Config: Open unified AI workspace in the platform's native file manager |
| func | Path & URL Launchers (Config-Driven) | `win-docker` | Config: Open Docker root directory in the platform's native file manager |
| func | Path & URL Launchers (Config-Driven) | `win-sync` | Config: Open sync repository in the platform's native file manager |
| func | System & Environment Bootstrap | `bootstrap` | System: Bootstrap missing dependencies for bash aliases (Debian/WSL via APT, macOS via Homebrew) |
| func | System & Environment Bootstrap | `sys-install` | System: Updates system packages and clears the pending-update marker |
| func | System & Environment Bootstrap | `sys-update` | System: Updates system packages (APT on Debian/WSL, Homebrew on macOS) |
| func | System & Navigation | `clip` | Pipe output to the system clipboard (e.g. cat file | clip) |
| func | System & Navigation | `win-export` | Open ~/vcs/personal/exports in the platform's native file manager |
| func | System & Navigation | `win` | Open current directory in the platform's native file manager |
| func | System & Navigation | `win-vcs` | Open ~/vcs in the platform's native file manager |
| func | Terraform & Kubernetes Wrappers | `terraform` | Terraform wrapper (preserves args) |
| func | Terraform | `tf-clean` | Terraform: Aggressively clean local caching (.terraform, locks, plans) |
| func | Terraform | `tf-iam` | Terraform: Ask AI to list required Service Accounts and least-privilege roles |
| func | Terraform | `tf-replace` | Terraform: Replace a specific resource (Modern alternative to taint) |
| func | Terraform | `tf-yaml` | Terraform: Wrapper to execute Terraform using a YAML config file for variables |
| func | Version Control (Git) - AI Workflows | `git-ai-push-all` | Git: Add all files, intelligently group via AI, and push [Usage: git-ai-push-all [optional message]] |
| func | Version Control (Git) - AI Workflows | `mt-ai-gitignore` | Git: Ask AI to generate a comprehensive .gitignore for the current project |
| func | Version Control (Git) - AI Workflows | `mt-ai-readme` | Git: Ask AI to generate a comprehensive README.md for the current project |
| func | Version Control (Git) | `git-clean-merged` | Git: Delete dead or stale branches that have been merged into the default branch |
| func | Version Control (Git) | `git-clone-ide` | Git: Clone a repository into ~/vcs/, cd into it, and open in IDE |
| func | Version Control (Git) | `git-default-rebase` | Git: Fetch upstream and rebase the current branch onto the default branch |
| func | Version Control (Git) | `git` | Git: Wrapper to force 'clone' into ~/vcs/ from anywhere |
| func | Version Control (Git) | `git-new-feature` | Git: Create and checkout a new feature branch |
| func | Version Control (Git) | `git-nuke` | Git: Hard reset and wipe all untracked files on the current branch |
| func | Version Control (Git) | `git-pretty-log` | Git: Print a beautiful, color-coded, single-line graph log |
| func | Version Control (Git) | `git-push-all` | Git: Add all files, commit with provided message, and push |
| func | Version Control (Git) | `git-raise-pr` | Git: Push branch and create a Pull Request (GitHub/Bitbucket/GitLab) |
| func | Version Control (Git) | `git-view-remote` | Git: Open the current repository in the default web browser |
| func | Version Control (Git) - Profile Synchronization | `mt-download-release` | System: Download a release zip from the remote repository [Usage: mt-download-release [-v version] [-d directory]] |
| func | Version Control (Git) - Profile Synchronization | `mt-get-update` | System: Download and install profile updates from GitHub releases [Usage: mt-get-update [-v version]] |
| func | Version Control (Git) - Profile Synchronization | `mt-push-update` | Git: Sync local bash configs to terminal repo and create a Pull Request |
