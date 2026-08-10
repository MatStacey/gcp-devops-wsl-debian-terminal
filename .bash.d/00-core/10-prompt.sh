# ~/.bash.d/10-prompt.sh
# Generate dynamic zero-lag prompt with clickable links and color-coded Git status

__prompt_gcp_info() {
	local gcp_active="default"
	[ -f "$HOME/.config/gcloud/active_config" ] && read -r gcp_active <"$HOME/.config/gcloud/active_config"

	local gcp_config_file="$HOME/.config/gcloud/configurations/config_${gcp_active}"
	if [ -f "$gcp_config_file" ]; then
		while read -r key equal val; do
			[ "$key" = "project" ] && __prompt_gcp_proj="$val"
			[ "$key" = "account" ] && __prompt_gcp_acct="$val"
		done <"$gcp_config_file"
	fi

	if [ -n "$__prompt_gcp_acct" ]; then
		[ -f "$HOME/.config/gcloud/application_default_credentials.json" ] &&
			__prompt_gcp_color="${CB_GREEN}" ||
			__prompt_gcp_color="${CB_YELLOW}"
	else
		__prompt_gcp_color="${CB_RED}"
	fi
}

__prompt_k8s_info() {
	local kube_cfg="${KUBECONFIG:-$HOME/.kube/config}"
	if [ -f "$kube_cfg" ]; then
		while read -r key val; do
			if [ "$key" = "current-context:" ]; then
				__prompt_k8s_ctx="$val"
				break
			fi
		done <"$kube_cfg"
	fi
}

__prompt_git_info() {
	local git_stat
	# Early exit if not a git repository
	git_stat=$(git status --porcelain -b --untracked-files=no 2>/dev/null) || return 0

	local first_line
	read -r first_line <<<"$git_stat"

	__prompt_git_branch="${first_line#\#\# }"
	__prompt_git_branch="${__prompt_git_branch%%...*}"
	__prompt_git_branch="${__prompt_git_branch%% *}"

	if [[ "$first_line" == *"behind"* ]]; then
		__prompt_git_color="${CB_RED}"
	elif [[ "$first_line" == *"ahead"* ]]; then
		__prompt_git_color="${CB_YELLOW}"
	elif [[ "$first_line" == *"..."* ]]; then
		__prompt_git_color="${CB_GREEN}"
	else __prompt_git_color="${CB_BLUE}"; fi

	[[ "$git_stat" == *$'\n'* ]] && __prompt_git_color="${CB_YELLOW}"

	if [ "$PWD" != "$__prompt_git_last_pwd" ]; then
		__prompt_git_last_pwd="$PWD"
		__prompt_git_url_cache=$(git config --get remote.origin.url 2>/dev/null)
	fi

	# Early exit if no upstream origin
	[ -z "$__prompt_git_url_cache" ] && return 0

	local clean_url="${__prompt_git_url_cache#*@}"
	clean_url="${clean_url#*//}"
	clean_url="${clean_url//://}"
	clean_url="${clean_url%.git}"
	__prompt_git_url="https://${clean_url}/src/${__prompt_git_branch}/"
}

__cloud_ps1() {
	local e=$'\e' np_start=$'\001' np_end=$'\002'
	local color_reset="${np_start}${C_RESET}${np_end}"

	local __prompt_gcp_proj="" __prompt_gcp_acct="" __prompt_gcp_color=""
	local __prompt_k8s_ctx="" __prompt_git_branch="" __prompt_git_color="" __prompt_git_url=""

	__prompt_gcp_info
	__prompt_k8s_info
	__prompt_git_info

	local out=""

	if [ -n "$__prompt_gcp_proj" ]; then
		local gcp_text="GCP: ${__prompt_gcp_proj}"
		[ -n "$__prompt_gcp_acct" ] && gcp_text="${gcp_text} (${__prompt_gcp_acct})"
		local gcp_url="https://console.cloud.google.com/home/dashboard?project=${__prompt_gcp_proj}"
		local color_code="${np_start}${__prompt_gcp_color}${np_end}"
		local link_start="${np_start}${e}]8;;${gcp_url}${e}\\${np_end}"
		local link_end="${np_start}${e}]8;;${e}\\${np_end}"
		out="${link_start}${color_code}${gcp_text}${color_reset}${link_end}"
	elif [ -n "$__prompt_gcp_acct" ]; then
		out="${np_start}${__prompt_gcp_color}${np_end}GCP: (${__prompt_gcp_acct})${color_reset}"
	fi

	if [ -n "$__prompt_k8s_ctx" ]; then
		[ -n "$out" ] && out="${out} | "
		out="${out}K8s: ${__prompt_k8s_ctx}"
	fi

	if [ -n "$__prompt_git_branch" ]; then
		[ -n "$out" ] && out="${out} | "
		local git_text="Git: ${__prompt_git_branch}"
		if [ -n "$__prompt_git_url" ]; then
			git_text="${np_start}${e}]8;;${__prompt_git_url}${e}\\${np_end}${git_text}${np_start}${e}]8;;${e}\\${np_end}"
		fi
		out="${out}${np_start}${__prompt_git_color}${np_end}${git_text}${color_reset}"
	fi

	[ -n "$out" ] && echo -n "[${out}] "
}
