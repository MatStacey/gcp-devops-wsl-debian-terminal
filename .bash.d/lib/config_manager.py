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

    # Helper to dry up all the print/shlex/str boilerplate
    def export(var_name, value, to_lower=False, resolve_home=False):
        val_str = str(value)
        if to_lower:
            val_str = val_str.lower()
        if resolve_home and val_str.startswith("~/"):
            val_str = val_str.replace("~", home, 1)
        print(f"export {var_name}={shlex.quote(val_str)}")

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
    export("DEFAULT_IDE", sys_cfg.get('default_ide', 'vscode'), to_lower=True)
    export("BASH_THEME", sys_cfg.get('theme', 'default'), to_lower=True)
    export("UPDATE_CHECK_TTL_SEC", sys_cfg.get('update_check_ttl_sec', 43200))
    export("MAX_PARALLEL_THREADS", sys_cfg.get('max_parallel_threads', 8))

    # AI
    export("AI_ENABLED",
           ai_cfg.get('enabled', sys_cfg.get('ai_enabled', True)),
           to_lower=True)
    export("DEFAULT_AI",
           ai_cfg.get('default_provider', sys_cfg.get('default_ai', 'gemini')),
           to_lower=True)
    export("AI_SYSTEM_PROMPT",
           ai_cfg.get('system_prompt', gem_cfg.get('system_prompt', '')))

    export("GEMINI_API_KEY", gem_cfg.get('api_key', ''))
    export("GEMINI_VERSION", gem_cfg.get('version', 'gemini-3.6-flash'))
    export("GEMINI_EXTENDED", gem_cfg.get('extended', False), to_lower=True)

    export("CLAUDE_API_KEY", cla_cfg.get('api_key', ''))
    export("CLAUDE_VERSION", cla_cfg.get('version', 'claude-3-7-sonnet-latest'))

    # Exports
    export("AUTO_CLEANUP_EXPORTS",
           exp_cfg.get('auto_cleanup', sys_cfg.get('auto_cleanup_exports', True)),
           to_lower=True)
    export("AUTO_CLEANUP_DAYS",
           exp_cfg.get('auto_cleanup_days', sys_cfg.get('auto_cleanup_days', 7)))

    default_blocklist = (
        r"(secret|token|credential|password|passwd|id_rsa|id_ed25519|"
        r"\.pem$|\.p12$|\.pfx$|\.npmrc$|\.netrc$|kubeconfig|"
        r"service.?account.*\.json$|.*-key.*\.json$|\.tfvars(\.json)?$|"
        r"(^|/)\.env(\..+)?$|lock\.hcl|__pycache__)")
    export(
        "EXPORT_BLOCKLIST",
        exp_cfg.get('blocklist', paths_cfg.get('export_blocklist', default_blocklist)))

    # Git
    export("SYNC_REPO_URL", git_cfg.get('sync_repo_url', ''))
    export("GIT_FEATURE_PREFIX", git_cfg.get('feature_prefix', 'feature/'))
    export("AI_MAX_DIFF_BYTES", git_cfg.get('ai_max_diff_bytes', 4000))

    # Paths
    export("VCS_ROOT", paths_cfg.get('vcs_root', '~/vcs'), resolve_home=True)
    export("VCS_PERSONAL",
           paths_cfg.get('vcs_personal', '~/vcs/personal'),
           resolve_home=True)
    export("VCS_EXPORTS",
           paths_cfg.get('vcs_exports', '~/vcs/personal/exports'),
           resolve_home=True)
    export("SYNC_REPO_DIR",
           paths_cfg.get('sync_repo', '~/vcs/personal/gcp-devops-wsl-debian-terminal'),
           resolve_home=True)
    export("AI_WORKSPACE_DIR",
           paths_cfg.get('ai_workspace', '~/vcs/ai-workspace'),
           resolve_home=True)
    export("SCRIPTS_IAM_DIR",
    export("DOCKER_ROOT_DIR", paths_cfg.get('docker_root', '~/.docker'), resolve_home=True)
           paths_cfg.get('scripts_iam', '~/vcs/scripts/iam'),
           resolve_home=True)
    export("THEMES_DIR", f"{home}/.bash.d/config/themes")

    # Docker
    export("DOCKER_BLOCKLIST", docker_cfg.get('restart_blocklist', ''))


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
