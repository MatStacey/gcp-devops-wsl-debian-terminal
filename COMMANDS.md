# MT DevOps Framework - Command Reference

This document is automatically generated on every sync and lists all available framework functions and aliases.

---

## 🔗 Aliases
Shortcuts for common commands and CLI replacements.
### Development & Build Tools
| Command | Description |
|---|---|
| `boot-run` | Spring Boot: Run application |
| `mci` | Maven: Clean and Install |
| `pip-load` | Install pip requirements |
| `pip-save` | Save pip requirements |
| `ruff-fmt` | Ruff: Format Python files and imports in current directory (recursive) |
| `shfmtlw` | shfmt: Format all shell scripts in current directory (recursive) |
| `venv-make` | Create & active Python venv |
| `venv-up` | Activate existing Python venv |

### GCP: Configuration & Authentication
| Command | Description |
|---|---|
| `gcpp` | GCP: Legacy shortcut to set project |

### GCP: Resources & Services
| Command | Description |
|---|---|
| `bq-ls` | BigQuery: List datasets in project |
| `gce-ls` | Compute: List all VM instances |
| `gce-ssh` | Compute: SSH into an instance |
| `gcl-gar-ls` | Artifacts: List Artifact Registry repos |
| `gcl-iam-ls` | IAM: List service accounts in active project |
| `gcl-ps-subs` | PubSub: List subscriptions |
| `gcl-ps-topics` | PubSub: List topics |
| `gcp-crf-ls` | Functions: List Cloud Run Functions |
| `gcs-ls` | GCS: List buckets or contents |

### Modern CLI Replacements
| Command | Description |
|---|---|
| `cat` | bat: Print file contents with syntax highlighting |
| `ccat` | bat: Print file contents with line numbers & Git gutters |
| `json-fmt` | Pretty-print JSON stream |
| `ll` | eza: Detailed list with Git status |
| `ls` | eza: List files with directories first |
| `rg` | rg: Search with smart case, include hidden, ignore .git |
| `tree` | eza: Display directory structure as a tree |
| `yaml-fmt` | Pretty-print YAML stream (requires yq) |

### System & Navigation
| Command | Description |
|---|---|
| `cd-bashd` | Change directory to ~/.bash.d |
| `cd-git-home` | Change directory to ~/vcs |
| `cd-git-personal` | Change directory to ~/vcs/personal |
| `mt` | Print all aliases and functions |
| `refresh` | Reload Bash profile |
| `reload` | Reload Bash profile |
| `sys-update-install` | Update, Upgrade, Boostrap, Reload |

### Terraform & Kubernetes Wrappers
| Command | Description |
|---|---|
| `tf-scan` | Checkov: Scan local terraform directory (./terraform) |

---

## 🛠️ Functions
Complex bash functions, framework utilities, and automated workflows.
### Base64 Encoding & Decoding Utilities
| Command | Description |
|---|---|
| `base64-dec` | Base64: Decode a Base64 string, file, or stream |
| `base64-enc` | Base64: Encode a string, file, or stream to Base64 |
| `docker-ls` | Docker: List all running containers in a clean table format |
| `docker-nuke` | Docker: Aggressive cleanup of all unused containers, images, and volumes |
| `docker-reboot-all` | Docker: Restart all currently running Docker containers |
| `docker-sandbox` | Docker: Spin up a temporary, throwaway container sandbox |
| `docker-shell` | Docker: Interactive fuzzy-finder to exec into a running container |
| `docker-tail` | Docker: Concurrently tail logs from multiple selected containers |
| `mt-blueprint` | Framework: Scaffold a new repository using standardized DevOps blueprints |
| `mt-log` | System: Centralized logging with colored output |

### Configuration Management
| Command | Description |
|---|---|
| `mt-get-gemini-status` | Prints the current Gemini API model version and extended reasoning mode toggle. |
| `mt-open-config` | Config: Open bash.d directory and config.yaml in IDE [Usage: mt-open-config [-ide vscode|intellij]] |
| `mt-set-default-ai` | Config: Set default AI model [Usage: mt-set-default-ai "gemini|claude|local"] |
| `mt-set-default-ide` | Config: Set default IDE [Usage: mt-set-default-ide "vscode|intellij"] |
| `mt-set-theme` | Config: Set terminal color theme [Usage: mt-set-theme "theme_name"] |
| `mt-setup` | Config: Interactive Master Setup Wizard Menu |
| `mt-setup-ai` | Config: Interactive AI Setup |
| `mt-setup-cicd` | Config: Interactive CI/CD Setup |
| `mt-setup-docker` | Config: Interactive Docker Setup |
| `mt-setup-exports` | Config: Interactive Exports Setup |
| `mt-setup-git` | Config: Interactive Git Setup |
| `mt-setup-paths` | Config: Interactive Paths Setup |
| `mt-set-upstream-path` | Config: Set the upstream repository path for framework updates |
| `mt-setup-system` | Config: Interactive System Setup |
| `mt-toggle-ai` | Config: Toggle global AI prompt and integration true/false |
| `mt-toggle-format-on-push` | Config: Toggle format-on-push true/false |

### Container Orchestration
| Command | Description |
|---|---|
| `kubectl` | Kubectl wrapper (preserves args) |

### Container Orchestration (Kubernetes)
| Command | Description |
|---|---|
| `kns` | Kubernetes: Get or explicitly set the active namespace in the current context |

### GCP: Configuration & Authentication
| Command | Description |
|---|---|
| `gcl-config` | GCP: List active configuration properties |
| `gcl-export-vars` | GCP: Export PROJECT_ID and PROJECT_NUMBER env vars to shell |
| `gcl-get-project` | GCP: Print active project ID |
| `gcl-get-project-number` | GCP: Print active project Number (API call required) |
| `gcl-get-region` | GCP: Print active compute region |
| `gcl-get-user` | GCP: Print active user account |
| `gcl-get-zone` | GCP: Print active compute zone |
| `gcl-org-policies` | GCP: List org policies for active project |
| `gcl-update` | GCP: Update Google Cloud CLI tools |
| `gcp-login` | GCP: Login to user & application default |
| `gcp-login-adc` | GCP: Login to application default only |
| `gcp-set-project` | GCP: Switch active project |

### GCP: Resources & Services
| Command | Description |
|---|---|
| `bq-query` | BigQuery: Run standard SQL query |
| `gcl-as-json` | Run gcloud command and output as formatted JSON |
| `gcp-crf-logs` | Functions: Tail logs of a function |
| `gcp-gar-docker` | Artifacts: Configure Docker auth |
| `gcp-get-secret` | Secrets: Read latest payload of a secret |
| `gcp-iam-show` | IAM: View IAM policy for active project |
| `gcp-ps-pull` | PubSub: Pull and auto-ack one message |

### Google Style Code Formatting
| Command | Description |
|---|---|
| `google-fmt` | Formats Python and Shell scripts according to Google Style Guides. |

### Infrastructure as Code
| Command | Description |
|---|---|
| `ai` | AI: Send a prompt to the currently configured LLM |
| `ai-explain` | AI: Explain a shell command |
| `mt-ai-debug` | AI: Debug the last failed command |
| `tf-val-all` | Terraform: Recursively validate and scan all Terraform directories |

### MyTools Documentation & Runner
| Command | Description |
|---|---|
| `mt-aliases` | MyTools: List all documented shell aliases |
| `mt-cat` | MyTools: List all tools within a specific category |
| `mt-cats` | MyTools: List all available command categories |
| `mt-config` | MyTools: Display active framework configuration variables |
| `mt-funcs` | MyTools: List all documented shell functions |
| `mt-fzf` | MyTools: Interactive fuzzy-finder to search for a command |
| `mt-get-version` | System: Print the current local version of the terminal profile |
| `mt-help` | MyTools: Display detailed help and source code for a command |
| `mt-refresh-caches` | System: Forcefully clear and rebuild all background caches (.env, mytools, updates) |
| `mt-run` | MyTools: Interactive fuzzy-finder to select and execute a command |
| `mt-search` | Framework: Search through available mytools commands |
| `mt-status` | System: Display a unified health check and status dashboard |
| `mytools` | MyTools: Primary runner and documentation index |

### Path & URL Launchers (Config-Driven)
| Command | Description |
|---|---|
| `cd-ai-workspace` | Config: Change directory to unified AI workspace |
| `cd-mt-git-local` | Config: Change directory to sync repository root |
| `cd-win-docker` | Docker: Change to Docker directory (from config.yaml) and open in Windows Explorer |
| `ide` | Config: Open current directory in the default IDE (VSCode/IntelliJ) |
| `mt-open-homepage` | Config: Open sync repository remote URL in default web browser |
| `win-ai-workspace` | Config: Open unified AI workspace in the platform's native file manager |
| `win-docker` | Config: Open Docker root directory in the platform's native file manager |
| `win-sync` | Config: Open sync repository in the platform's native file manager |

### System & Environment Bootstrap
| Command | Description |
|---|---|
| `bootstrap` | System: Bootstrap missing dependencies for bash aliases (Debian/WSL via APT, macOS via Homebrew) |
| `sys-install` | System: Updates system packages and clears the pending-update marker |
| `sys-update` | System: Updates system packages (APT on Debian/WSL, Homebrew on macOS) |

### System & Navigation
| Command | Description |
|---|---|
| `clip` | Pipe output to the system clipboard (e.g. cat file | clip) |
| `win` | Open current directory in the platform's native file manager |
| `win-export` | Open ~/vcs/personal/exports in the platform's native file manager |
| `win-vcs` | Open ~/vcs in the platform's native file manager |

### Terraform
| Command | Description |
|---|---|
| `tf-clean` | Terraform: Aggressively clean local caching (.terraform, locks, plans) |
| `tf-iam` | Terraform: Ask AI to list required Service Accounts and least-privilege roles |
| `tf-replace` | Terraform: Replace a specific resource (Modern alternative to taint) |
| `tf-yaml` | Terraform: Wrapper to execute Terraform using a YAML config file for variables |

### Terraform & Kubernetes Wrappers
| Command | Description |
|---|---|
| `terraform` | Terraform wrapper (preserves args) |

### Version Control (Git)
| Command | Description |
|---|---|
| `git` | Git: Wrapper to force 'clone' into ~/vcs/ from anywhere |
| `git-clean-merged` | Git: Delete dead or stale branches that have been merged into the default branch |
| `git-clone-ide` | Git: Clone a repository into ~/vcs/, cd into it, and open in IDE |
| `git-default-rebase` | Git: Fetch upstream and rebase the current branch onto the default branch |
| `git-new-feature` | Git: Create and checkout a new feature branch |
| `git-nuke` | Git: Hard reset and wipe all untracked files on the current branch |
| `git-pretty-log` | Git: Print a beautiful, color-coded, single-line graph log |
| `git-push-all` | Git: Add all files, commit with provided message, and push |
| `git-raise-pr` | Git: Push branch and create a Pull Request (GitHub/Bitbucket/GitLab) |
| `git-view-remote` | Git: Open the current repository in the default web browser |

### Version Control (Git) - AI Workflows
| Command | Description |
|---|---|
| `git-ai-push-all` | Git: Add all files, intelligently group via AI, and push [Usage: git-ai-push-all [optional message]] |
| `mt-ai-gitignore` | Git: Ask AI to generate a comprehensive .gitignore for the current project |
| `mt-ai-readme` | Git: Ask AI to generate a comprehensive README.md for the current project |

### Version Control (Git) - Profile Synchronization
| Command | Description |
|---|---|
| `mt-download-release` | System: Download a release zip from the remote repository [Usage: mt-download-release [-v version] [-d directory]] |
| `mt-get-update` | System: Download and install profile updates from GitHub releases [Usage: mt-get-update [-v version]] |
| `mt-push-update` | Git: Sync local bash configs to terminal repo and create a Pull Request |
