system:
  default_ide: vscode
  theme: default
  default_ai: gemini
  ai_enabled: true
  auto_cleanup_exports: true
  auto_cleanup_days: 7
  update_check_ttl_sec: 43200
  max_parallel_threads: 8
docker:
  restart_blocklist: "redis,postgres,local-db"
gemini:
  api_key: YOUR_GEMINI_API_KEY
  version: gemini-3.6-flash
  extended: false
  system_prompt: 'You are a Senior DevOps Engineer. You write DRY, fully complete, production-ready code with no placeholders. Respond ONLY with a valid JSON object using this exact schema: { "category": "gcloud" | "script" | "project" | "chat", "language": "bash, python, terraform, etc (null if chat)", "extension": "sh, py, tf, etc (null if chat)", "title": "generate-a-kebab-case-title-if-not-provided", "code": "the fully complete working code string without markdown wrapping (null if chat)", "message": "Your brief explanation or answer" }'
claude:
  api_key: YOUR_CLAUDE_API_KEY
  version: claude-3-7-sonnet-latest
git:
  sync_repo_url: YOUR_SYNC_REPO_URL
  feature_prefix: feature/
  ai_max_diff_bytes: 4000
paths:
  vcs_root: ~/vcs
  vcs_personal: ~/vcs/personal
  sync_repo: ~/vcs/personal/gcp-devops-wsl-debian-terminal
  ai_workspace: ~/vcs/ai-workspace
  scripts_iam: ~/vcs/scripts/iam
  export_blocklist: (secret|token|credential|pass|key|rsa|env|lock\.hcl|__pycache__)
