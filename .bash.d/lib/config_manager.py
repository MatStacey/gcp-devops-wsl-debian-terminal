#!/usr/bin/env python3
import os
import shlex
import sys


def get_config_path():
    return os.path.expanduser(
        os.environ.get("CONFIG_FILE", "~/.bash.d/config/config.yaml"))


def load_env():
    path = get_config_path()
    home = os.environ.get("HOME", "")
    d = {}

    try:
        import yaml
    except ImportError:
        print(
            "echo -e '\\033[01;31m🚨 Error: PyYAML is missing. Please run \"bootstrap\" to install it.\\033[0m' >&2"
        )
        return

    if os.path.exists(path):
        try:
            with open(path, "r") as f:
                d = yaml.safe_load(f) or {}
        except (yaml.YAMLError, OSError) as e:
            print(f"echo -e '\\033[01;31m🚨 Error parsing config.yaml: {e}\\033[0m' >&2")
            return

    # Extract Blocks
    sys_cfg = d.get("system") or {}
    ai_cfg = d.get("ai") or {}
    gem_cfg = ai_cfg.get("gemini") or d.get("gemini") or {}  # Fallbacks for migration
    cla_cfg = ai_cfg.get("claude") or d.get("claude") or {}
    exp_cfg = d.get("exports") or {}
    git_cfg = d.get("git") or {}
    paths_cfg = d.get("paths") or {}
    docker_cfg = d.get("docker") or {}

    # System
    print(
        f"export DEFAULT_IDE={shlex.quote(sys_cfg.get('default_ide', 'vscode').lower())}"
    )
    print(f"export BASH_THEME={shlex.quote(sys_cfg.get('theme', 'default').lower())}")
    print(
        f"export UPDATE_CHECK_TTL_SEC={shlex.quote(str(sys_cfg.get('update_check_ttl_sec', 43200)))}"
    )
    print(
        f"export MAX_PARALLEL_THREADS={shlex.quote(str(sys_cfg.get('max_parallel_threads', 8)))}"
    )

    # AI
    print(
        f"export AI_ENABLED={shlex.quote(str(ai_cfg.get('enabled', sys_cfg.get('ai_enabled', True))).lower())}"
    )
    print(
        f"export DEFAULT_AI={shlex.quote(ai_cfg.get('default_provider', sys_cfg.get('default_ai', 'gemini')).lower())}"
    )
    print(
        f"export AI_SYSTEM_PROMPT={shlex.quote(ai_cfg.get('system_prompt', gem_cfg.get('system_prompt', '')))}"
    )

    print(f"export GEMINI_API_KEY={shlex.quote(gem_cfg.get('api_key', ''))}")
    print(
        f"export GEMINI_VERSION={shlex.quote(gem_cfg.get('version', 'gemini-3.6-flash'))}"
    )
    print(
        f"export GEMINI_EXTENDED={shlex.quote(str(gem_cfg.get('extended', False)).lower())}"
    )

    print(f"export CLAUDE_API_KEY={shlex.quote(cla_cfg.get('api_key', ''))}")
    print(
        f"export CLAUDE_VERSION={shlex.quote(cla_cfg.get('version', 'claude-3-7-sonnet-latest'))}"
    )

    # Exports
    print(
        f"export AUTO_CLEANUP_EXPORTS={shlex.quote(str(exp_cfg.get('auto_cleanup', sys_cfg.get('auto_cleanup_exports', True))).lower())}"
    )
    print(
        f"export AUTO_CLEANUP_DAYS={shlex.quote(str(exp_cfg.get('auto_cleanup_days', sys_cfg.get('auto_cleanup_days', 7))))}"
    )
    default_blocklist = (
        r"(secret|token|credential|password|passwd|id_rsa|id_ed25519|"
        r"\.pem$|\.p12$|\.pfx$|\.npmrc$|\.netrc$|kubeconfig|"
        r"service.?account.*\.json$|.*-key.*\.json$|\.tfvars(\.json)?$|"
        r"(^|/)\.env(\..+)?$|lock\.hcl|__pycache__)")
    print(
        f"export EXPORT_BLOCKLIST={shlex.quote(exp_cfg.get('blocklist', paths_cfg.get('export_blocklist', default_blocklist)))}"
    )

    # Git
    print(f"export SYNC_REPO_URL={shlex.quote(git_cfg.get('sync_repo_url', ''))}")
    print(
        f"export GIT_FEATURE_PREFIX={shlex.quote(git_cfg.get('feature_prefix', 'feature/'))}"
    )
    print(
        f"export AI_MAX_DIFF_BYTES={shlex.quote(str(git_cfg.get('ai_max_diff_bytes', 4000)))}"
    )

    # Paths
    print(
        f"export VCS_ROOT={shlex.quote(paths_cfg.get('vcs_root', '~/vcs').replace('~', home))}"
    )
    print(
        f"export VCS_PERSONAL={shlex.quote(paths_cfg.get('vcs_personal', '~/vcs/personal').replace('~', home))}"
    )
    print(
        f"export VCS_EXPORTS={shlex.quote(paths_cfg.get('vcs_exports', '~/vcs/personal/exports').replace('~', home))}"
    )
    print(
        f"export SYNC_REPO_DIR={shlex.quote(paths_cfg.get('sync_repo', '~/vcs/personal/gcp-devops-wsl-debian-terminal').replace('~', home))}"
    )
    print(
        f"export AI_WORKSPACE_DIR={shlex.quote(paths_cfg.get('ai_workspace', '~/vcs/ai-workspace').replace('~', home))}"
    )
    print(
        f"export SCRIPTS_IAM_DIR={shlex.quote(paths_cfg.get('scripts_iam', '~/vcs/scripts/iam').replace('~', home))}"
    )
    print(f"export THEMES_DIR={shlex.quote(f'{home}/.bash.d/config/themes')}")

    # Docker
    print(
        f"export DOCKER_BLOCKLIST={shlex.quote(docker_cfg.get('restart_blocklist', ''))}"
    )


def update_yaml(cat_path, key, val):
    import yaml

    path = get_config_path()
    d = {}
    if os.path.exists(path):
        with open(path, "r") as f:
            d = yaml.safe_load(f) or {}

    # Allow dot notation for nested categories (e.g. ai.gemini)
    keys = cat_path.split(".")
    current = d
    for k in keys:
        if k not in current or not isinstance(current[k], dict):
            current[k] = {}
        current = current[k]

    current[key] = val

    with open(path, "w") as f:
        yaml.safe_dump(d, f, sort_keys=False)

    # config.yaml holds API keys in plaintext — lock it down.
    os.chmod(path, 0o600)

    # Force cache invalidation to prevent WSL mtime race conditions
    cache_file = os.path.join(os.path.dirname(path), ".env.cache")
    if os.path.exists(cache_file):
        os.remove(cache_file)


if __name__ == "__main__" and len(sys.argv) > 1:
    cmd = sys.argv[1]
    if cmd == "load-env":
        load_env()
    elif cmd == "update" and len(sys.argv) == 5:
        update_yaml(sys.argv[2], sys.argv[3], sys.argv[4])
