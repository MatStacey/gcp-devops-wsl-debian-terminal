# ==========================================
# Mandatory Profile Ignores
# ==========================================

# Secrets & Configuration
.bash.d/config/config.yaml
.bash.d/data/cache/.env.cache

# Framework Caches & State Variables
.bash.d/.mt_cache*
.bash.d/.mt_data.tsv
.bash.d/.update_check_cache
.bash.d/.profile_update_cache
.bash.d/.*_pending
.bash.d/data/.current_version

# Dynamic Caches (Includes .vcs_hub.json)
.bash.d/data/cache/
data/cache/

# Python & Linters
__pycache__/
.ruff_cache/

# IDE & Editor
.vscode/
.vsclog

# Build Artifacts & Miscellaneous
*.zip
.dev
