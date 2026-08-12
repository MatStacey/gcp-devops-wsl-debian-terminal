#!/usr/bin/env python3
import os
import shlex
import sys


def get_config_path():
    return os.path.expanduser(
        os.environ.get("CONFIG_FILE", "~/.bash.d/config/config.yaml")
    )


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
            print(
                f"echo -e '\\033[01;31m🚨 Error parsing config.yaml: {e}\\033[0m' >&2"
            )
            return

    sys_cfg = d.get("system") or {}
    print(
        f"export DEFAULT_IDE={shlex.quote(sys_cfg.get('default_ide', 'vscode').lower())}"
    )
    print(f"export BASH_THEME={shlex.quote(sys_cfg.get('theme', 'default').lower())}")
    print(
        f"export DEFAULT_AI={shlex.quote(sys_cfg.get('default_ai', 'gemini').lower())}"
    )
    print(
        f"export AUTO_CLEANUP_EXPORTS={shlex.quote(str(sys_cfg.get('auto_cleanup_exports', False)).lower())}"
    )
    print(
        f"export AUTO_CLEANUP_DAYS={shlex.quote(str(sys_cfg.get('auto_cleanup_days', 7)))}"
    )
    
    # NEW: Docker Blocklist (comma-separated string)
    docker_cfg = d.get("docker") or {}
    print(
        f"export DOCKER_BLOCKLIST={shlex.quote(docker_cfg.get('restart_blocklist', ''))}"
    )

    gem = d.get("gemini") or d.get("ai") or {}
    print(f"export GEMINI_API_KEY={shlex.quote(gem.get('api_key', ''))}")
    print(
        f"export GEMINI_VERSION={shlex.quote(gem.get('version', 'gemini-3.6-flash'))}"
    )
    print(
        f"export GEMINI_EXTENDED={shlex.quote(str(gem.get('extended', False)).lower())}"
    )
    print(f"export AI_SYSTEM_PROMPT={shlex.quote(gem.get('system_prompt', ''))}")

    cla = d.get("claude") or {}
    print(f"export CLAUDE_API_KEY={shlex.quote(cla.get('api_key', ''))}")
    print(
        f"export CLAUDE_VERSION={shlex.quote(cla.get('version', 'claude-3-7-sonnet-latest'))}"
    )

    git = d.get("git") or {}
    print(f"export SYNC_REPO_URL={shlex.quote(git.get('sync_repo_url', ''))}")

    paths = d.get("paths") or {}
    print(
        f"export VCS_ROOT={shlex.quote(paths.get('vcs_root', '~/vcs').replace('~', home))}"
    )
    print(
        f"export VCS_PERSONAL={shlex.quote(paths.get('vcs_personal', '~/vcs/personal').replace('~', home))}"
    )
    print(
        f"export SYNC_REPO_DIR={shlex.quote(paths.get('sync_repo', '~/vcs/personal/gcp-devops-wsl-debian-terminal').replace('~', home))}"
    )
    print(
        f"export SCRIPTS_IAM_DIR={shlex.quote(paths.get('scripts_iam', '~/vcs/scripts/iam').replace('~', home))}"
    )
    print(f"export THEMES_DIR={shlex.quote(f'{home}/.bash.d/config/themes')}")
    print(
        f"export AI_WORKSPACE_DIR={shlex.quote(paths.get('ai_workspace', '~/vcs/ai-workspace').replace('~', home))}"
    )

    blocklist = paths.get(
        "export_blocklist",
        "(secret|token|credential|pass|key|rsa|env|lock\\\\.hcl|__pycache__)",
    )
    print(f"export EXPORT_BLOCKLIST={shlex.quote(blocklist)}")

    print(
        f"export UPDATE_CHECK_TTL_SEC={shlex.quote(str(sys_cfg.get('update_check_ttl_sec', 43200)))}"
    )
    print(
        f"export MAX_PARALLEL_THREADS={shlex.quote(str(sys_cfg.get('max_parallel_threads', 8)))}"
    )

    git = d.get("git") or {}
    print(f"export SYNC_REPO_URL={shlex.quote(git.get('sync_repo_url', ''))}")
    print(
        f"export AI_MAX_DIFF_BYTES={shlex.quote(str(git.get('ai_max_diff_bytes', 4000)))}"
    )


def update_yaml(cat, key, val):
    import yaml

    path = get_config_path()
    d = {}
    if os.path.exists(path):
        with open(path, "r") as f:
            d = yaml.safe_load(f) or {}

    if cat not in d or d[cat] is None:
        d[cat] = {}

    if val.lower() == "true":
        val = True
    elif val.lower() == "false":
        val = False
    elif val.isdigit():
        val = int(val)

    d[cat][key] = val
    with open(path, "w") as f:
        yaml.safe_dump(d, f, sort_keys=False)


if __name__ == "__main__" and len(sys.argv) > 1:
    cmd = sys.argv[1]
    if cmd == "load-env":
        load_env()
    elif cmd == "update" and len(sys.argv) == 4:
        update_yaml(sys.argv[2], sys.argv[3], sys.argv[4])
