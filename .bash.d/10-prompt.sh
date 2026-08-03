# ~/.bash.d/10-prompt.sh
# Generate dynamic zero-lag prompt with clickable links and color-coded Git status
__cloud_ps1() {
    local e=$'\e'
    local np_start=$'\001'
    local np_end=$'\002'
    local color_reset="${np_start}${e}[00m${np_end}"

    # 1. Pure Bash read of GCP Project & Account (0 subshells)
    local gcp="" account="" gcp_active="default"
    if [ -f "$HOME/.config/gcloud/active_config" ]; then
        read -r gcp_active < "$HOME/.config/gcloud/active_config"
    fi
    
    local gcp_config_file="$HOME/.config/gcloud/configurations/config_${gcp_active}"
    if [ -f "$gcp_config_file" ]; then
        # Use Bash 'read' to parse the file natively without spawning awk
        while read -r key equal val; do
            if [ "$key" = "project" ]; then gcp="$val"; fi
            if [ "$key" = "account" ]; then account="$val"; fi
        done < "$gcp_config_file"
    fi

    # 2. Pure Bash check of GCP Auth Status (Red/Amber/Green)
    local gcp_color="${e}[01;31m" # Default to Red (Not auth'd)
    if [ -n "$account" ]; then
        if [ -f "$HOME/.config/gcloud/application_default_credentials.json" ]; then
            gcp_color="${e}[01;32m" # Green: ADC exists
        else
            gcp_color="${e}[01;33m" # Amber: Account set, no ADC
        fi
    fi

    # 3. Pure Bash read of K8s Context (Bypasses the slow kubectl binary)
    local k8s=""
    local kube_cfg="${KUBECONFIG:-$HOME/.kube/config}"
    if [ -f "$kube_cfg" ]; then
        while read -r key val; do
            if [ "$key" = "current-context:" ]; then 
                k8s="$val"
                break
            fi
        done < "$kube_cfg"
    fi
    
    # 4. Combined Git Status (Reduces 5 git commands down to 1)
    local git_branch="" git_web_url="" git_color="${e}[01;32m"
    local git_stat
    
    # `git status -b` outputs branch, sync status, and modified files in one go
    if git_stat=$(git status --porcelain -b 2>/dev/null); then
        local first_line
        read -r first_line <<< "$git_stat"
        
        # Parse branch name (strips formatting characters)
        git_branch="${first_line#\#\# }"
        git_branch="${git_branch%%...*}"
        git_branch="${git_branch%% *}"
        
        # Determine sync state from the first line
        if [[ "$first_line" == *"behind"* ]]; then
            git_color="${e}[01;31m" # Red
        elif [[ "$first_line" == *"ahead"* ]]; then
            git_color="${e}[01;33m" # Amber
        elif [[ "$first_line" == *"..."* ]]; then
            git_color="${e}[01;32m" # Green
        else
            git_color="${e}[01;34m" # Blue (No upstream)
        fi
        
        # Check for uncommitted changes (if git_stat string contains a newline character)
        if [[ "$git_stat" == *$'\n'* ]]; then
            git_color="${e}[01;33m" # Amber override
        fi
        
        # Get remote URL for the hyperlink
        local origin_url
        origin_url=$(git remote get-url origin 2>/dev/null)
        if [ -n "$origin_url" ]; then
            local clean_url="${origin_url#*@}"
            clean_url="${clean_url#*//}"
            clean_url="${clean_url//://}"
            clean_url="${clean_url%.git}"
            git_web_url="https://${clean_url}/branch/${git_branch}"
        fi
    fi
    
    # 5. Format Output with OSC 8 Hyperlinks & Dynamic Colors
    local out=""
    
    if [ -n "$gcp" ]; then
        local gcp_text="GCP: ${gcp}"
        [ -n "$account" ] && gcp_text="${gcp_text} (${account})"
        local gcp_url="https://console.cloud.google.com/home/dashboard?project=${gcp}"
        
        local gcp_color_start="${np_start}${gcp_color}${np_end}"
        local link_start="${np_start}${e}]8;;${gcp_url}${e}\\${np_end}"
        local link_end="${np_start}${e}]8;;${e}\\${np_end}"
        out="${link_start}${gcp_color_start}${gcp_text}${color_reset}${link_end}"
    elif [ -n "$account" ]; then
        local gcp_color_start="${np_start}${gcp_color}${np_end}"
        out="${gcp_color_start}GCP: (${account})${color_reset}"
    fi
    
    if [ -n "$k8s" ]; then
        [ -n "$out" ] && out="${out} | "
        out="${out}K8s: ${k8s}"
    fi

    if [ -n "$git_branch" ]; then
        [ -n "$out" ] && out="${out} | "
        local git_text="Git: ${git_branch}"
        if [ -n "$git_web_url" ]; then
            local git_link_start="${np_start}${e}]8;;${git_web_url}${e}\\${np_end}"
            local git_link_end="${np_start}${e}]8;;${e}\\${np_end}"
            git_text="${git_link_start}${git_text}${git_link_end}"
        fi
        local git_color_start="${np_start}${git_color}${np_end}"
        out="${out}${git_color_start}${git_text}${color_reset}"
    fi
    
    [ -n "$out" ] && echo -n "[${out}] "
}