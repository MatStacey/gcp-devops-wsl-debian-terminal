# ~/.bash.d/99-utils.sh

bootstrap-deps() { # => System: Bootstrap missing dependencies for bash aliases (Debian/WSL)
    echo "🔍 Scanning system for missing dependencies..."

    local apt_deps=()
    local pip_deps=()
    local missing_complex_deps=()

# 1. Standard APT Packages
    command -v jq >/dev/null 2>&1 || apt_deps+=("jq")
    command -v fzf >/dev/null 2>&1 || apt_deps+=("fzf")
    command -v rg >/dev/null 2>&1 || apt_deps+=("ripgrep")
    command -v batcat >/dev/null 2>&1 || apt_deps+=("bat")
    command -v rsync >/dev/null 2>&1 || apt_deps+=("rsync")
    command -v shfmt >/dev/null 2>&1 || apt_deps+=("shfmt")
    
    # 2. Python Packages (Linters & Security)
    command -v ruff >/dev/null 2>&1 || pip_deps+=("ruff")
    command -v checkov >/dev/null 2>&1 || pip_deps+=("checkov")

    # 3. Complex/External Repository Packages
    command -v terraform >/dev/null 2>&1 || missing_complex_deps+=("terraform (Requires HashiCorp apt repo)")
    command -v gcloud >/dev/null 2>&1 || missing_complex_deps+=("google-cloud-cli (Requires Google Cloud apt repo)")
    command -v kubectl >/dev/null 2>&1 || missing_complex_deps+=("kubectl (Requires Kubernetes apt repo)")
    command -v eza >/dev/null 2>&1 || missing_complex_deps+=("eza (Requires gierens.de apt repo)")

    # Execute APT Installations
    if [ ${#apt_deps[@]} -gt 0 ]; then
        echo -e "\n📦 Installing standard APT dependencies: ${apt_deps[*]}..."
        sudo apt-get update
        sudo apt-get install -y "${apt_deps[@]}"
    else
        echo "✅ All standard APT dependencies are satisfied."
    fi

    # Execute Python Package Installations
    if [ ${#pip_deps[@]} -gt 0 ]; then
        echo -e "\n🐍 Installing Python CLI tools: ${pip_deps[*]}..."
        if command -v pipx >/dev/null 2>&1; then
            for pkg in "${pip_deps[@]}"; do pipx install "$pkg"; done
        else
            echo "   (Falling back to standard pip --user)"
            pip3 install --user "${pip_deps[@]}"
        fi
    else
        echo "✅ All Python CLI dependencies are satisfied."
    fi

    # Execute Binary Downloads
    if ! command -v yq >/dev/null 2>&1; then
        echo -e "\n⚙️ Installing 'yq' via official binary..."
        sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
        sudo chmod a+x /usr/local/bin/yq
        echo "✅ yq installed."
    fi

    # Report Missing Complex Infrastructure Tools
    if [ ${#missing_complex_deps[@]} -gt 0 ]; then
        echo -e "\n⚠️  The following infrastructure tools are missing and require manual repository configuration:"
        for dep in "${missing_complex_deps[@]}"; do
            echo "  - $dep"
        done
    fi

    echo -e "\n🎉 Environment bootstrap complete!"
}

mytools() { # => List all custom shell aliases and functions
    echo "=========================================================="
    echo "   My Custom Bash Tools      "
    echo "=========================================================="
    echo -e "\033[1;34mFunctions:\033[0m"
    awk -F'[(]' '/^[a-zA-Z0-9_-]+\(\).*# => / {
        name = $1;
        desc = substr($0, index($0, "# => ") + 5);
        printf "  - \033[1;36m%-25s\033[0m %s\n", name, desc;
    }' ~/.bash.d/*.sh | sort
    echo ""
    echo -e "\033[1;32mAliases:\033[0m"
    awk -F'[= ]' '/^alias [a-zA-Z0-9_-]+=.*# => / {
        name = $2;
        desc = substr($0, index($0, "# => ") + 5);
        printf "  - \033[1;36m%-25s\033[0m %s\n", name, desc;
    }' ~/.bash.d/*.sh | sort
    echo "=========================================================="
}

# ================================================================================#
#                                EXPORT UTILITIES                                 #
# ================================================================================#

__vcs_core_export() { # Internal DRY helper for repository exports
    local export_file="$1"
    local allow_regex="$2"
    local block_regex="$3"

    echo "Compiling codebase..."
    mkdir -p "$(dirname "$export_file")"
    > "$export_file"

    git ls-files -z --cached --others --exclude-standard | while IFS= read -r -d '' file; do
        local lower_file="${file,,}"
        
        # 1. Must be a standard file
        if [ ! -f "$file" ]; then continue; fi
        
        # 2. Must match allowed extensions (if an allow-list is provided)
        if [ -n "$allow_regex" ] && ! [[ "$lower_file" =~ $allow_regex ]]; then continue; fi
        
        # 3. Must NOT match blocked keywords/directories (if a block-list is provided)
        if [ -n "$block_regex" ] && [[ "$lower_file" =~ $block_regex ]]; then continue; fi

        # Write to file
        echo "==> ./$file <==" >> "$export_file"
        cat "$file" >> "$export_file"
        echo -e "\n" >> "$export_file"
    done

    echo "✅ Export saved to $export_file"
    explorer.exe "$(wslpath -w "$(dirname "$export_file")")"
}

vcs-tf-export() { # => Exports local TF codebase into ~/vcs/personal/exports/tf-repo-export.txt
    __vcs_core_export \
        "$HOME/vcs/personal/exports/tf-repo-export.txt" \
        "\.(tf|sh|ya?ml|json|md)$" \
        "(secret|token|credential|pass|key|rsa|env|\.terraform|lock\.hcl)"
}

vcs-bash-export() { # => Exports local .sh files into ~/vcs/personal/exports/bash-export.txt
    __vcs_core_export \
        "$HOME/vcs/personal/exports/bash-export.txt" \
        "\.sh$" \
        "(secret|token|credential|pass|key|rsa|env)"
}

vcs-gcf-export() { # => Exports Python GCF codebase into ~/vcs/personal/exports/gcf-repo-export.txt
    __vcs_core_export \
        "$HOME/vcs/personal/exports/gcf-repo-export.txt" \
        "\.(py|tf|sh|ya?ml|json|toml|md|properties|txt)$" \
        "(secret|token|credential|pass|key|rsa|env|__pycache__|\.egg-info|test-reports|\.pyc$)"
}