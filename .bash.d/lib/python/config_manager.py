#!/usr/bin/env python3
import contextlib
import os
import shlex
import sys


def get_config_path():
    return os.path.expanduser(
        os.environ.get("CONFIG_FILE", "~/.bash.d/config/config.yaml")
    )


def _export(var_name, value, home_dir, to_lower=False, resolve_home=False):
    val_str = str(value) if value is not None else ""
    if to_lower:
        val_str = val_str.lower()
    if resolve_home and val_str.startswith("~/"):
        val_str = val_str.replace("~", home_dir, 1)
    print(f"export {var_name}={shlex.quote(val_str)}")


def _read_yaml_config(path):
    try:
        import yaml
    except ImportError:
        print("echo -e '\033[01;31m🚨 Error: PyYAML is missing. Run bootstrap to install it.\033[0m' >&2")
        return None

    if not os.path.exists(path):
        return {}

    try:
        with open(path, "r", encoding="utf-8") as f:
            return yaml.safe_load(f) or {}
    except (yaml.YAMLError, OSError) as e:
        print(f"echo -e '\033[01;31m🚨 Error parsing config.yaml: {e}\033[0m' >&2")
        return None


def load_env():
    path = get_config_path()
    home = os.environ.get("HOME", "")

    d = _read_yaml_config(path)
    if d is None:
        return

    def export(var_name, value, to_lower=False, resolve_home=False):
        _export(var_name, value, home, to_lower, resolve_home)

    core_cfg = d.get("core") or d.get("system") or {}
    paths_cfg = d.get("paths") or {}
    ai_cfg = d.get("ai") or {}
    prov_cfg = ai_cfg.get("providers") or {}
    git_cfg = d.get("git") or {}
    exp_cfg = d.get("llm_exports") or d.get("exports") or {}
    dock_cfg = d.get("docker") or {}
    cicd_cfg = d.get("cicd") or {}

    # CI/CD
    export("CICD_PROVIDER", cicd_cfg.get("default_provider", cicd_cfg.get("provider", "github")), to_lower=True)

    # Core
    export("DEFAULT_IDE", core_cfg.get("default_ide", "vscode"), to_lower=True)
    export("BASH_THEME", core_cfg.get("theme", "default"), to_lower=True)
    export("UPDATE_CHECK_TTL_SEC", core_cfg.get("update_check_ttl_sec", 43200))
    export("MAX_PARALLEL_THREADS", core_cfg.get("max_parallel_threads", 8))

    # AI
    export("AI_ENABLED", core_cfg.get("enable_ai", ai_cfg.get("enabled", True)), to_lower=True)
    export("DEFAULT_AI", ai_cfg.get("default_provider", "gemini"), to_lower=True)
    export("AI_MAX_DIFF_BYTES", ai_cfg.get("max_context_bytes", git_cfg.get("ai_max_diff_bytes", 150000)))

    sys_prompt_file = ai_cfg.get("system_prompt_file", "")
    sys_prompt = ""
    if sys_prompt_file:
        with (
            contextlib.suppress(OSError, TypeError),
            open(os.path.expanduser(sys_prompt_file), "r", encoding="utf-8") as f,
        ):
            sys_prompt = f.read().strip()
    export("AI_SYSTEM_PROMPT", sys_prompt)

    # Providers
    gem_cfg = prov_cfg.get("gemini") or ai_cfg.get("gemini") or {}
    export("GEMINI_API_KEY", gem_cfg.get("api_key", ""))
    export("GEMINI_VERSION", gem_cfg.get("model", gem_cfg.get("version", "gemini-3.6-flash")))
    export("GEMINI_EXTENDED", gem_cfg.get("enable_extended_reasoning", gem_cfg.get("extended", False)), to_lower=True)

    cla_cfg = prov_cfg.get("claude") or ai_cfg.get("claude") or {}
    export("CLAUDE_API_KEY", cla_cfg.get("api_key", ""))
    export("CLAUDE_VERSION", cla_cfg.get("model", cla_cfg.get("version", "claude-3-7-sonnet-latest")))

    loc_cfg = prov_cfg.get("local") or ai_cfg.get("local") or {}
    export("LOCAL_AI_API_KEY", loc_cfg.get("api_key", "ollama"))
    export("LOCAL_AI_BASE_URL", loc_cfg.get("base_url", "http://localhost:11434/v1"))
    export("LOCAL_AI_MODEL", loc_cfg.get("model", "llama3.2"))

    # Exports
    export("AUTO_CLEANUP_EXPORTS", exp_cfg.get("enable_auto_cleanup", exp_cfg.get("auto_cleanup", True)), to_lower=True)
    export("AUTO_CLEANUP_DAYS", exp_cfg.get("auto_cleanup_days", 7))
    export("EXPORT_BLOCKLIST", exp_cfg.get("file_blocklist_regex", exp_cfg.get("blocklist", "")))
    export("EXPORT_IGNORE_DIRS", exp_cfg.get("dir_ignore_glob", exp_cfg.get("ignore_dirs", "")))

    # Git
    export("SYNC_REPO_URL", git_cfg.get("sync_repo_url", ""))
    export("UPSTREAM_REPO_PATH", git_cfg.get("upstream_repo_slug", git_cfg.get("upstream_repo_path", "MatStacey/mt-devops-framework")))
    export("GIT_FEATURE_PREFIX", git_cfg.get("feature_branch_prefix", git_cfg.get("feature_prefix", "feature/")))
    export("GIT_FORMAT_ON_PUSH", str(git_cfg.get("enable_format_on_push", git_cfg.get("format_on_push", True))).lower())

    # Paths
    export("VCS_ROOT", paths_cfg.get("vcs_root_dir", paths_cfg.get("vcs_root", "~/vcs")), resolve_home=True)
    export("VCS_PERSONAL", paths_cfg.get("vcs_personal_dir", paths_cfg.get("vcs_personal", "~/vcs/personal")), resolve_home=True)
    export("VCS_EXPORTS", paths_cfg.get("vcs_exports_dir", paths_cfg.get("vcs_exports", "~/vcs/personal/exports")), resolve_home=True)
    export("SYNC_REPO_DIR", paths_cfg.get("sync_repo_dir", paths_cfg.get("sync_repo", "~/vcs/personal/mt-devops-framework")), resolve_home=True)
    export("AI_WORKSPACE_DIR", paths_cfg.get("ai_workspace_dir", paths_cfg.get("ai_workspace", "~/vcs/ai-workspace")), resolve_home=True)
    export("SCRIPTS_IAM_DIR", paths_cfg.get("iam_scripts_dir", paths_cfg.get("scripts_iam", "~/vcs/scripts/iam")), resolve_home=True)
    export("DOCKER_ROOT_DIR", paths_cfg.get("docker_root_dir", paths_cfg.get("docker_root", "~/.docker")), resolve_home=True)
    export("THEMES_DIR", f"{home}/.bash.d/config/themes")

    # Docker
    export("DOCKER_BLOCKLIST", dock_cfg.get("restart_blocklist_csv", dock_cfg.get("restart_blocklist", "")))


def update_yaml(cat_path, key, val):
    import yaml

    path = get_config_path()
    d = {}
    if os.path.exists(path):
        with open(path, "r", encoding="utf-8") as f:
            d = yaml.safe_load(f) or {}

    keys = cat_path.split(".")
    current = d
    for k in keys:
        if k not in current or not isinstance(current[k], dict):
            current[k] = {}
        current = current[k]

    current[key] = val

    with open(path, "w", encoding="utf-8") as f:
        yaml.safe_dump(d, f, sort_keys=False, default_flow_style=False)

    os.chmod(path, 0o600)

    cache_file = os.path.expanduser("~/.bash.d/data/cache/.env.cache")
    if os.path.exists(cache_file):
        os.remove(cache_file)


if __name__ == "__main__" and len(sys.argv) > 1:
    cmd = sys.argv[1]
    if cmd == "load-env":
        load_env()
    elif cmd == "update" and len(sys.argv) == 5:
        update_yaml(sys.argv[2], sys.argv[3], sys.argv[4])
