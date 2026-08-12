system:
  theme: default
  default_ide: vscode
  update_check_ttl_sec: 43200
  max_parallel_threads: 8

ai:
  enabled: true
  default_provider: gemini
  system_prompt: 'You are a Senior Cloud Software and Devops Engineer. You write DRY, fully complete, production-ready code with no placeholders. Respond ONLY with a valid JSON object using this exact schema: { "category": "gcloud" | "script" | "project" | "chat", "language": "bash, python, terraform, etc (null if chat)", "extension": "sh, py, tf, etc (null if chat)", "title": "generate-a-kebab-case-title-if-not-provided", "code": "the fully complete working code string without markdown wrapping (null if chat)", "message": "Your brief explanation or answer" }'
  gemini:
    api_key: YOUR_GEMINI_API_KEY
    version: gemini-3.6-flash
    extended: false
  claude:
    api_key: YOUR_CLAUDE_API_KEY
    version: claude-3-7-sonnet-latest

exports:
  auto_cleanup: true
  auto_cleanup_days: 7
  # Precise patterns, not bare substrings: the old (pass|key|env|rsa) blocked
  # legit files like environment.tf while missing GCP service-account JSON
  # keys, .tfvars, and .pem/.p12 certs entirely.
  blocklist: (secret|token|credential|password|passwd|id_rsa|id_ed25519|\.pem$|\.p12$|\.pfx$|\.npmrc$|\.netrc$|kubeconfig|service.?account.*\.json$|.*-key.*\.json$|\.tfvars(\.json)?$|(^|/)\.env(\..+)?$|lock\.hcl|__pycache__)

git:
  sync_repo_url: YOUR_SYNC_REPO_URL
  feature_prefix: feature/
  ai_max_diff_bytes: 4000

paths:
  vcs_root: ~/vcs
  vcs_personal: ~/vcs/personal
  vcs_exports: ~/vcs/personal/exports
  sync_repo: ~/vcs/personal/gcp-devops-wsl-debian-terminal
  ai_workspace: ~/vcs/ai-workspace
  scripts_iam: ~/vcs/scripts/iam

docker:
  restart_blocklist: "redis,postgres,local-db"
