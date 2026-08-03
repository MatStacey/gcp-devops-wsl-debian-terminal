# ~/.bash.d/10-prompt.sh
# Generate dynamic zero-lag prompt with clickable links and color-coded Git status

# -----------------------------------------------------------------------------
# Helper: Extract GCP Project & Account info natively (0 subshells)
# -----------------------------------------------------------------------------
__prompt_gcp_info() {
    local gcp_active="default"
    if [ -f "$HOME/.config/gcloud/active_config" ]; then
        read -r gcp_active < "$HOME/.config/gcloud/active_config"
    fi
    
    local gcp_config_file="$HOME/.config/gcloud/configurations/config_${gcp_active}"
    if [ -f "$gcp_config_file" ]; then
        while read -r key equal val; do
            if [ "$key" = "project" ]; then __prompt_gcp_proj="$val"; fi
            if [ "$key" = "account" ]; then __prompt_gcp_acct="$val"; fi
        done < "$gcp_config_file"
    fi

    # Determine auth color status (Red / Amber / Green)
    if [ -n "$__prompt_gcp_acct" ]; then
        if [ -f "$HOME/.config/gcloud/application_default_credentials.json" ]; then
            __prompt_gcp_color=$'\e[01;32m' # Green: ADC exists
        else
            __prompt_gcp_color=$'\e[01;33m' # Amber: Account set, no ADC
        fi
    else
        __prompt_gcp_color=$'\e[01;31m' # Red: Not auth'd
    fi
}

# -----------------------------------------------------------------------------
# Helper: Extract Kubernetes active context natively
# -----------------------------------------------------------------------------
__prompt_k8s_info() {
    local kube_cfg="${KUBECONFIG:-$HOME/.kube/config}"
    if [ -f "$kube_cfg" ]; then
        while read -r key val; do
            if [ "$key" = "current-context:" ]; then 
                __prompt_k8s_ctx="$val"
                break
            fi
        done < "$kube_cfg"
    fi
}

# -----------------------------------------------------------------------------
# Helper: Extract Git branch, sync state, and source code web URL
# -----------------------------------------------------------------------------
__prompt_git_info() {
    local git_stat
    if git_stat=$(git status --porcelain -b 2>/dev/null); then
        local first_line
        read -r first_line <<< "$git_stat"
        
        # Parse branch name
        __prompt_git_branch="${first_line#\#\# }"
        __prompt_git_branch="${__prompt_git_branch%%...*}"
        __prompt_git_branch="${__prompt_git_branch%% *}"
        
        # Determine sync state color from branch tracking status
        if [[ "$first_line" == *"behind"* ]]; then
            __prompt_git_color=$'\e[01;31m' # Red
        elif [[ "$first_line" == *"ahead"* ]]; then
            __prompt_git_color=$'\e[01;33m' # Amber
        elif [[ "$first_line" == *"..."* ]]; then
            __prompt_git_color=$'\e[01;32m' # Green
        else
            __prompt_git_color=$'\e[01;34m' # Blue (No upstream)
        fi
        
        # Override with Amber if there are uncommitted changes
        if [[ "$git_stat" == *$'\n'* ]]; then
            __prompt_git_color=$'\e[01;33m' 
        fi
        
        # Build source code web URL (Supports Bitbucket / GitHub / GitLab trees)
        local origin_url
        origin_url=$(git remote get-url origin 2>/dev/null)
        if [ -n "$origin_url" ]; then
            local clean_url="${origin_url#*@}"
            clean_url="${clean_url#*//}"
            clean_url="${clean_url//://}"
            clean_url="${clean_url%.git}"
            
            # Formats to /src/<branch>/ for Bitbucket and standard source views
            __prompt_git_url="https://${clean_url}/src/${__prompt_git_branch}/"
        fi
    fi
}

# -----------------------------------------------------------------------------
# Main PS1 Builder Function
# -----------------------------------------------------------------------------
__cloud_ps1() {
    local e=$'\e'
    local np_start=$'\001'
    local np_end=$'\002'
    local color_reset="${np_start}${e}[00m${np_end}"

    # Clear previous frame states
    local __prompt_gcp_proj="" __prompt_gcp_acct="" __prompt_gcp_color=""
    local __prompt_k8s_ctx=""
    local __prompt_git_branch="" __prompt_git_color="" __prompt_git_url=""

    # Populate states via modular helpers
    __prompt_gcp_info
    __prompt_k8s_info
    __prompt_git_info

    local out=""

    # 1. Format GCP Segment
    if [ -n "$__prompt_gcp_proj" ]; then
        local gcp_text="GCP: ${__prompt_gcp_proj}"
        [ -n "$__prompt_gcp_acct" ] && gcp_text="${gcp_text} (${__prompt_gcp_acct})"
        local gcp_url="https://console.cloud.google.com/home/dashboard?project=${__prompt_gcp_proj}"
        
        local color_code="${np_start}${__prompt_gcp_color}${np_end}"
        local link_start="${np_start}${e}]8;;${gcp_url}${e}\\${np_end}"
        local link_end="${np_start}${e}]8;;${e}\\${np_end}"
        out="${link_start}${color_code}${gcp_text}${color_reset}${link_end}"
    elif [ -n "$__prompt_gcp_acct" ]; then
        local color_code="${np_start}${__prompt_gcp_color}${np_end}"
        out="${color_code}GCP: (${__prompt_gcp_acct})${color_reset}"
    fi
    
    # 2. Format Kubernetes Segment
    if [ -n "$__prompt_k8s_ctx" ]; then
        [ -n "$out" ] && out="${out} | "
        out="${out}K8s: ${__prompt_k8s_ctx}"
    fi

    # 3. Format Git Segment (with source-tree hyperlink routing)
    if [ -n "$__prompt_git_branch" ]; then
        [ -n "$out" ] && out="${out} | "
        local git_text="Git: ${__prompt_git_branch}"
        if [ -n "$__prompt_git_url" ]; then
            local git_link_start="${np_start}${e}]8;;${__prompt_git_url}${e}\\${np_end}"
            local git_link_end="${np_start}${e}]8;;${e}\\${np_end}"
            git_text="${git_link_start}${git_text}${git_link_end}"
        fi
        local color_code="${np_start}${__prompt_git_color}${np_end}"
        out="${out}${color_code}${git_text}${color_reset}"
    fi
    
    # Render final wrapped block
    [ -n "$out" ] && echo -n "[${out}] "
}
