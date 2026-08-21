system:
  theme: default
  default_ide: vscode
  update_check_ttl_sec: 43200
  max_parallel_threads: 8
  backup_warning_mb: 500

ai:
  enabled: true
  default_provider: gemini
  system_prompt_file: ~/.bash.d/config/ai/system_prompt.md
  gemini:
    api_key: YOUR_GEMINI_API_KEY
    version: gemini-3.6-flash
    extended: false
  claude:
    api_key: YOUR_CLAUDE_API_KEY
    version: claude-3-7-sonnet-latest
  local:
    base_url: "http://localhost:11434/v1"
    model: "llama3.2"
    api_key: "ollama"

exports:
  auto_cleanup: true
  auto_cleanup_days: 7
  # Precise patterns, not bare substrings: the old (pass|key|env|rsa) blocked
  # legit files like environment.tf while missing GCP service-account JSON
  # keys, .tfvars, and .pem/.p12 certs entirely.
  blocklist: (secret|token|credential|password|passwd|id_rsa|id_ed25519|\.pem$|\.p12$|\.pfx$|\.npmrc$|\.netrc$|kubeconfig|service.?account.*\.json$|.*-key.*\.json$|\.tfvars(\.json)
  ignore_dirs: ".git|.dev|.vscode|.idea|node_modules|__pycache__|.terraform|venv|.venv|.mt_cache*"?$|(^|/)\.env(\..+)?$|lock\.hcl|__pycache__|\.mt_cache|\.mt_cache\.time|\.mt_data\.tsv|\.profile_update_cache|\.style\.yapf|\.update_check_cache|\.zoxide_cache\.sh|\.env\.cache)

git:
  format_on_push: true
  sync_repo_url: MatStacey/mt-devops-framework
  upstream_repo_path: MatStacey/mt-devops-framework
  feature_prefix: feature/
  ai_max_diff_bytes: 4000

paths:
  vcs_root: ~/vcs
  vcs_personal: ~/vcs/personal
  vcs_exports: ~/vcs/personal/exports
  sync_repo: ~/vcs/personal/gcp-devops-wsl-debian-terminal
  ai_workspace: ~/vcs/ai-workspace
  scripts_iam: ~/vcs/scripts/iam
  docker_root: ~/.docker
  backup_dir: ~/backups

cicd:
  provider: github # github, bitbucket, gitlab, azure, jenkins

docker:
  restart_blocklist: redis,postgres,local-db