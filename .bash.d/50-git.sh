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