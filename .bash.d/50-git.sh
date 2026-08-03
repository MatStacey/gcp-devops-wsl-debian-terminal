git-acp() { # => Git: Add all files, commit with message, and push [Usage: git-acp "commit message"]
    if [ -z "$1" ]; then
        echo "🚨 Error: Commit message cannot be empty."
        echo "Usage: git-acp \"Your commit message\""
        return 1
    fi
    git add .
    git commit -m "$1"
    git push
}

git-chk-feat() { # => Git: Create and checkout a new feature branch [Usage: git-chk-feat CCON-123]
    if [ -z "$1" ]; then
        echo "🚨 Error: Jira ID / branch suffix cannot be empty."
        echo "Usage: git-chk-feat CCON-123"
        return 1
    fi
    git checkout -b "feature/$1"
}

gitc() { # => Git: Clone a repository into ~/vcs/ and cd into it [Usage: gitc <url>]
    if [ -z "$1" ]; then
        echo "🚨 Error: Repository URL cannot be empty."
        echo "Usage: gitc <repo-url>"
        return 1
    fi
    
    mkdir -p "$HOME/vcs"
    
    # Extract the repository name from the URL (e.g. "ri-ccon-lreach-rproxy")
    local repo_name
    repo_name=$(basename "$1" .git)
    
    echo "📥 Cloning $repo_name to $HOME/vcs/..."
    
    if git clone "$1" "$HOME/vcs/$repo_name"; then
        cd "$HOME/vcs/$repo_name" || return
        echo "✅ Moved to $(pwd)"
    else
        echo "🚨 Error: Clone failed."
    fi
}

vcs-sync-bash() { # => Git: Sync local bash configs to terminal repo and push [Usage: vcs-sync-bash "optional msg"]
    local repo_dir="$HOME/vcs/personal/gcp-devops-wsl-debian-terminal"
    
    # Use the first argument as the commit message, default to "script updates" if empty
    local commit_msg="${1:-script updates}"

    echo "🔄 Syncing bash configuration to $repo_dir..."
    
    # Ensure the target directory structure exists
    mkdir -p "$repo_dir/.bash.d"

    # Mirror the configurations
    rsync -a "$HOME/.bashrc" "$repo_dir/"
    rsync -a --delete "$HOME/.bash.d/" "$repo_dir/.bash.d/"

    # Use a subshell to execute git commands without changing the user's current working directory
    (
        cd "$repo_dir" || { echo "🚨 Error: Could not navigate to $repo_dir"; exit 1; }
        
        # Stage the specific synced files
        git add .bashrc .bash.d/
        
        # Check if there are actual changes staged to avoid empty commit errors
        if git diff --staged --quiet; then
            echo "✅ Configurations are already up to date. No changes to commit."
        else
            echo "📦 Committing and pushing..."
            git commit -m "$commit_msg"
            git push
            echo "🚀 Successfully pushed updates to remote."
        fi
    )
}

git() { # => Git: Wrapper to force 'clone' into ~/vcs/ from anywhere
    # Check if the first argument is 'clone'
    if [ "$1" = "clone" ]; then
        shift # Remove 'clone' from the argument list
        
        # Ensure the target directory exists
        mkdir -p "$HOME/vcs"
        
        echo "📥 Intercepting 'git clone': Redirecting to $HOME/vcs/..."
        
        # Execute the native git clone command from within ~/vcs using a subshell
        # This preserves all other flags you might pass (e.g., -b main)
        if (cd "$HOME/vcs" && command git clone "$@"); then
            # Attempt to extract the repo name to provide a helpful cd hint
            local last_arg="${@: -1}"
            local repo_name
            repo_name=$(basename "$last_arg" .git)
            
            echo -e "\n✅ Repository cloned successfully."
            echo "💡 To navigate to it, run: cd ~/vcs/$repo_name"
        fi
    else
        # For all other git commands (status, push, commit, etc.), pass them through natively
        command git "$@"
    fi
}