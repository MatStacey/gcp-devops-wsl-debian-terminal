# MT DevOps Framework - Command Reference

This document is automatically generated on every sync and lists all available framework functions and aliases.

---

## 🔗 Aliases
Shortcuts for common commands and CLI replacements.
### Configuration Management
| Command | Description |
|---|---|
| `mt-reload-config` | Config: Forcefully re-parse config.yaml and reload environment variables |

### Container Orchestration (Kubernetes) Aliases
| Command | Description |
|---|---|
| `k` | Kubernetes: Core Kubectl Wrapper |
| `ka` | Kubernetes: Apply configuration from file |
| `kak` | Kubernetes: Apply configuration using Kustomize |
| `kd` | Kubernetes: Describe resources |
| `kdcm` | Kubernetes: Describe configmaps |
| `kddep` | Kubernetes: Describe deployments |
| `kding` | Kubernetes: Describe ingresses |
| `kdno` | Kubernetes: Describe nodes |
| `kdpo` | Kubernetes: Describe pods |
| `kdsec` | Kubernetes: Describe secrets |
| `kdsts` | Kubernetes: Describe statefulsets |
| `kdsvc` | Kubernetes: Describe services |
| `kex` | Kubernetes: Exec into a pod interactively |
| `kg` | Kubernetes: Get resources |
| `kgall` | Kubernetes: Get resources across all namespaces |
| `kgcm` | Kubernetes: Get configmaps |
| `kgdep` | Kubernetes: Get deployments |
| `kging` | Kubernetes: Get ingresses |
| `kgno` | Kubernetes: Get nodes |
| `kgns` | Kubernetes: Get namespaces |
| `kgpo` | Kubernetes: Get pods |
| `kgsec` | Kubernetes: Get secrets |
| `kgsts` | Kubernetes: Get statefulsets |
| `kgsvc` | Kubernetes: Get services |
| `klo` | Kubernetes: Tail logs for a pod |
| `klop` | Kubernetes: Tail logs for a previous instance of a pod |
| `kpf` | Kubernetes: Port forward to a pod or service |
| `krm` | Kubernetes: Delete resources by name |
| `krmdep` | Kubernetes: Delete deployments |
| `krmf` | Kubernetes: Delete resources from file |
| `krmpo` | Kubernetes: Delete pods |
| `ksys` | Kubernetes: Shortcut for the kube-system namespace |

### Development & Build Tools
| Command | Description |
|---|---|
| `boot-run` | Dev: Spring Boot - Run application |
| `mci` | Dev: Maven - Clean and Install |
| `pip-load` | Dev: Python - Install pip requirements |
| `pip-save` | Dev: Python - Save pip requirements |
| `ruff-fmt` | Dev: Python - Format Python files and imports using Ruff (recursive) |
| `shfmtlw` | Dev: Shell - Format all shell scripts in current directory (recursive) |
| `venv-make` | Dev: Python - Create & active Python venv |
| `venv-up` | Dev: Python - Activate existing Python venv |

### GCP: Configuration & Authentication
| Command | Description |
|---|---|
| `gcpp` | GCP: Legacy shortcut to set project |

### GCP: Resources & Services
| Command | Description |
|---|---|
| `bq-ls` | GCP: BigQuery - List datasets in project |
| `gce-ls` | GCP: Compute - List all VM instances |
| `gce-ssh` | GCP: Compute - SSH into an instance |
| `gcl-gar-ls` | GCP: Artifact Registry - List repositories |
| `gcl-iam-ls` | GCP: IAM - List service accounts in active project |
| `gcl-ps-subs` | GCP: PubSub - List subscriptions |
| `gcl-ps-topics` | GCP: PubSub - List topics |
| `gcp-crf-ls` | GCP: Cloud Run Functions - List functions |
| `gcs-ls` | GCP: Cloud Storage - List buckets or contents |

### Modern CLI Replacements
| Command | Description |
|---|---|
| `cat` | CLI: bat - Print file contents with syntax highlighting |
| `ccat` | CLI: bat - Print file contents with line numbers & Git gutters |
| `json-fmt` | CLI: jq - Pretty-print JSON stream |
| `ll` | CLI: eza - Detailed list with Git status |
| `ls` | CLI: eza - List files with directories first |
| `rg` | CLI: rg - Search with smart case, include hidden, ignore .git |
| `tree` | CLI: eza - Display directory structure as a tree |
| `tree-clean` | CLI: eza - Display directory structure ignoring bloat (.git, node_modules, etc) |
| `yaml-fmt` | CLI: yq - Pretty-print YAML stream |

### MyTools Documentation & Runner
| Command | Description |
|---|---|
| `mt-search` | MyTools: Search through available mytools commands (Alias) |

### Path & URL Launchers (Config-Driven)
| Command | Description |
|---|---|
| `cd-mt-git-local` | System: Change directory to dotfiles repository root (Alias) |

### System & Navigation Aliases
| Command | Description |
|---|---|
| `cd-bashd` | System: Change directory to ~/.bash.d |
| `cd-git-home` | System: Change directory to ~/vcs |
| `cd-git-personal` | System: Change directory to ~/vcs/personal |
| `mt` | System: Print all aliases and functions (MyTools Engine) |
| `mt-home` | System: Change directory to ~/.bash.d |
| `refresh` | System: Reload Bash profile and caches |
| `reload` | System: Reload Bash profile and caches |
| `sys-update-install` | System: Update, Upgrade, Boostrap, and Reload |

### Terraform Aliases
| Command | Description |
|---|---|
| `tf` | Terraform: Core Execution |
| `tfa` | Terraform: Apply changes |
| `tfap` | Terraform: Apply the saved plan file |
| `tfay` | Terraform: Apply changes (Auto-Approve) |
| `tfc` | Terraform: Open interactive console |
| `tfd` | Terraform: Destroy infrastructure |
| `tfdy` | Terraform: Destroy infrastructure (Auto-Approve) |
| `tff` | Terraform: Format all files recursively |
| `tfin` | Terraform: Initialize working directory |
| `tfinu` | Terraform: Initialize and upgrade modules/providers |
| `tfo` | Terraform: Read outputs from state |
| `tfp` | Terraform: Generate execution plan |
| `tfpd` | Terraform: Generate destruction plan |
| `tfpo` | Terraform: Generate a saved plan file (tfplan) |
| `tf-refresh` | Terraform: Refresh state without applying changes (Modern) |
| `tfs` | Terraform: State management commands |
| `tfsh` | Terraform: Show current state or plan |
| `tfsls` | Terraform: List resources in state |
| `tfsmv` | Terraform: Move an item in state |
| `tfsrm` | Terraform: Remove an item from state |
| `tfssw` | Terraform: Show a single resource in state |
| `tfv` | Terraform: Validate configuration files |
| `tfw` | Terraform: Workspace management commands |
| `tfwde` | Terraform: Delete a workspace |
| `tfwls` | Terraform: List workspaces |
| `tfwnw` | Terraform: Create a new workspace |
| `tfwst` | Terraform: Select an existing workspace |
| `tfwsw` | Terraform: Show the current workspace name |
| `tfy` | Terraform: Shortcut alias for tf-yaml |

### Terraform & Kubernetes Wrappers
| Command | Description |
|---|---|
| `tf-scan` | Terraform: Scan local terraform directory (./terraform) with Checkov |

### Version Control (Git) - Core Helpers
| Command | Description |
|---|---|
| `git-clean-local` | Git: Delete local and remote branches merged into default branch |

### Zoxide (Smart cd replacement)
| Command | Description |
|---|---|
| `mt-hard-reload` | System: Forcefully clear and rebuild all background caches and reload profile |
| `mtupd` | MT-Framework: Update the DevOps-MT-Framework with Shellcheck and Backup Creation |

---

## 🛠️ Functions
Complex bash functions, framework utilities, and automated workflows.
### AI Workflows & LLM API Integration
| Command | Description |
|---|---|
| `ai` | AI: Query configured LLM with prompt and optional context |
| `ai-explain` | AI: Explain a terminal command in detail |
| `mt-ai-debug` | AI: Debug and explain the last failed terminal command |
| `mt-ai-quota` | AI: Check API quota and rate limits for the active AI provider |

### Base64 Encoding & Decoding Utilities
| Command | Description |
|---|---|
| `base64-dec` | System: Decode a Base64 string, file, or stream |
| `base64-enc` | System: Encode a string, file, or stream to Base64 |

### Configuration Management
| Command | Description |
|---|---|
| `mt-get-gemini-status` | AI: Print current Gemini API model version and extended reasoning mode toggle |
| `mt-load-config` | Config: Forcefully re-parse config.yaml and reload environment variables |
| `mt-open-config` | Config: Open bash.d directory and config.yaml in IDE |
| `mt-set-default-ai` | Config: Set default AI model provider |
| `mt-set-default-ide` | Config: Set default terminal IDE launcher |
| `mt-set-theme` | Config: Set terminal color theme |
| `mt-setup` | Config: Launch the interactive Master Setup Wizard Menu |
| `mt-setup-ai` | Config: Interactive AI Setup Menu |
| `mt-setup-cicd` | Config: Interactive CI/CD Setup Menu |
| `mt-setup-docker` | Config: Interactive Docker Setup Menu |
| `mt-setup-exports` | Config: Interactive Exports Setup Menu |
| `mt-setup-git` | Config: Interactive Git Setup Menu |
| `mt-setup-paths` | Config: Interactive Paths Setup Menu |
| `mt-set-upstream-path` | Config: Set the upstream repository path for framework updates |
| `mt-setup-system` | Config: Interactive System Setup Menu |
| `mt-toggle-ai` | Config: Toggle global AI prompt and workflow integration (true/false) |
| `mt-toggle-format-on-push` | Config: Toggle global format-on-push behavior (true/false) |

### Container Orchestration
| Command | Description |
|---|---|
| `kubectl` | Kubernetes: Core kubectl wrapper (preserves args) |

### Container Orchestration (Kubernetes) Aliases
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
| `bq-query` | GCP: Run standard SQL query in BigQuery |
| `gcl-as-json` | GCP: Run any gcloud command and output as formatted JSON |
| `gcp-crf-logs` | GCP: Tail logs of a Cloud Run Function |
| `gcp-gar-docker` | GCP: Configure Docker auth for Artifact Registry |
| `gcp-get-secret` | GCP: Read the latest payload of a secret |
| `gcp-iam-show` | GCP: View IAM policy for the active project |
| `gcp-ps-pull` | GCP: Pull and auto-ack one message from a Pub/Sub subscription |

### General System Utilities
| Command | Description |
|---|---|
| `mt-alias` | System: Interactively create and document a new alias |
| `mt-backup` | System: Create an archive backup of the current directory |
| `mt-log` | System: Centralized logging for MyTools |
| `mt-logs` | System: View, filter, and manage framework logs |
| `mt-top-files` | System: Display the top largest files in a directory |
| `mt-vcs-audit` | System: Audit VCS root for unorganized files and directories |

### Google Style Code Formatting
| Command | Description |
|---|---|
| `google-fmt` | Formats Python and Shell scripts according to Google Style Guides. |

### Infrastructure as Code
| Command | Description |
|---|---|
| `tf-val-all` | Terraform: Recursively validate and scan all Terraform directories |

### LLM Context & Export Utilities
| Command | Description |
|---|---|
| `mt-export` | LLM: Export codebase to text/zip for LLM context window using dynamic schemas |

### MT Repo Hub - AI & Heuristic Metadata Dashboard
| Command | Description |
|---|---|
| `mt-hub` | System: Interactive AI-powered Repository Dashboard |

### MyTools Documentation & Runner
| Command | Description |
|---|---|
| `mt-aliases` | MyTools: List all documented shell aliases |
| `mt-cat` | MyTools: List all tools within a specific category |
| `mt-cats` | MyTools: List all available command categories |
| `mt-config` | MyTools: Display active framework configuration variables |
| `mt-dump` | MyTools: Generate a detailed technical Markdown dump of all functions and aliases |
| `mt-funcs` | MyTools: List all documented shell functions |
| `mt-fzf` | MyTools: Interactive fuzzy-finder to search for a command |
| `mt-get-version` | System: Print the current local version of the terminal profile |
| `mt-help` | MyTools: Display detailed help and source code for a command |
| `mt-lookup` | MyTools: Search through available mytools commands with tab-completion |
| `mt-refresh-caches` | System: Forcefully clear and rebuild all background caches (.env, mytools, updates) |
| `mt-run` | MyTools: Interactive fuzzy-finder to select and execute a command |
| `mt-status` | System: Display a unified health check and status dashboard |
| `mytools` | MyTools: Primary runner and documentation index |

### Path & URL Launchers (Config-Driven)
| Command | Description |
|---|---|
| `cd-ai-workspace` | AI: Change directory to unified AI workspace |
| `cd-win-docker` | Docker: Change to Docker directory (from config.yaml) and open in Windows Explorer |
| `ide` | System: Open current directory in the default IDE (VSCode/IntelliJ) |
| `mt-dotfiles` | System: Change directory to dotfiles repository root |
| `mt-open-homepage` | System: Open dotfiles repository remote URL in default web browser |
| `win-ai-workspace` | AI: Open unified AI workspace in the platform's native file manager |
| `win-docker` | Docker: Open Docker root directory in the platform's native file manager |
| `win-sync` | System: Open sync repository in the platform's native file manager |

### System & Environment Bootstrap
| Command | Description |
|---|---|
| `bootstrap` | System: Bootstrap missing dependencies (Debian/WSL via APT, macOS via Homebrew) |
| `sys-install` | System: Updates system packages and clears pending-update marker |
| `sys-update` | System: Updates system packages (APT on Debian/WSL, Homebrew on macOS) |

### System & Navigation Aliases
| Command | Description |
|---|---|
| `clip` | System: Pipe output to the system clipboard (e.g. cat file | clip) |
| `win` | System: Open current directory in the platform's native file manager |
| `win-export` | System: Open ~/vcs/personal/exports in the platform's native file manager |
| `win-vcs` | System: Open ~/vcs in the platform's native file manager |

### Terraform & AI Integrations
| Command | Description |
|---|---|
| `tf-iam` | AI: Analyze Terraform codebase for IAM requirements and optionally generate script |

### Terraform Aliases
| Command | Description |
|---|---|
| `tf-clean` | Terraform: Aggressively clean local caching (.terraform, locks, plans) |
| `tf-replace` | Terraform: Replace a specific resource (Modern alternative to taint) |
| `tf-yaml` | Terraform: Execute Terraform using a YAML config file for variables |

### Terraform & Kubernetes Wrappers
| Command | Description |
|---|---|
| `terraform` | Terraform: Core wrapper (preserves args) |

### Version Control (Git) - AI Workflows
| Command | Description |
|---|---|
| `git-ai-push-all` | Git: Auto-format, stage, generate AI commits, and push all changes |
| `mt-ai-gitignore` | AI: Generate a comprehensive .gitignore for the active repository |
| `mt-ai-readme` | AI: Generate a comprehensive README.md for the active repository |

### Version Control (Git) - Core Helpers
| Command | Description |
|---|---|
| `git` | Git: Intercept 'clone' to automatically route repositories into ~/vcs/ |
| `git-clean-merged` | Git: Delete local and remote branches merged into the default branch |
| `git-clone-ide` | Git: Clone repository into ~/vcs/, navigate into it, and open in default IDE |
| `git-default-rebase` | Git: Fetch upstream origin and rebase current branch onto default branch |
| `git-new-feature` | Git: Create and checkout a new feature branch |
| `git-nuke` | Git: Hard reset local branch to upstream state and wipe untracked files |
| `git-pretty-log` | Git: Print a clean, color-coded, single-line log graph |
| `git-push-all` | Git: Stage all files, commit with provided message, and push |
| `git-raise-pr` | Git: Push current branch and raise a Pull Request (GitHub/GitLab/Bitbucket) |
| `git-view-remote` | Git: Open current repository remote URL in default web browser |
| `mt-repos` | Git: Scan VCS root and list all local repositories |

### Version Control (Git) - Profile Synchronization
| Command | Description |
|---|---|
| `mt-download-release` | System: Download a release zip from the remote repository |
| `mt-get-update` | System: Download and install profile updates from GitHub releases |
| `mt-push-update` | System: Sync local bash configs to terminal dotfiles repo and create a Pull Request |
