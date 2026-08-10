# ------------------------------------------
# System Update Check
# ------------------------------------------
# ~/.bash.d/02-update-check.sh

__check_updates() {
	# 1. Exit immediately if not in an interactive shell
	if [[ $- != *i* ]]; then return; fi

	local pending_file="$HOME/.bash.d/.update_pending"
	local cache_file="$HOME/.bash.d/.update_check_cache"
	local current_time=$(date +%s)

	# 2. If a background check finished previously and left a pending file, prompt immediately
	if [ -f "$pending_file" ]; then
		local updates_count
		updates_count=$(cat "$pending_file")
		echo -e "\n\e[33m📦 $updates_count system package(s) can be upgraded.\e[0m"
		read -p "Run sys-update now? [Y/n] " -n 1 -r choice
		echo

		if [[ $choice =~ ^[Yy]$ ]] || [[ -z $choice ]]; then
			sudo apt update && sudo apt upgrade
			rm -f "$pending_file"
			echo "$current_time" >"$cache_file"
		else
			rm -f "$pending_file"
			echo "$current_time" >"$cache_file"
		fi
		return
	fi

	# 3. Time calculation
	local last_check=0
	if [ -f "$cache_file" ]; then
		last_check=$(cat "$cache_file")
	fi

	local ttl="${UPDATE_CHECK_TTL_SEC:-43200}"

	if ((current_time - last_check >= ttl)); then
		# 4. Fire the expensive apt check in an asynchronous background subshell
		(
			local count
			count=$(apt list --upgradable 2>/dev/null | grep -c -v 'Listing...')
			if [ "$count" -gt 0 ]; then
				echo "$count" >"$pending_file"
			else
				# If 0 updates, update cache so we don't check again for 12 hours
				echo "$(date +%s)" >"$cache_file"
			fi
		) &
		disown
	fi
}

__check_updates
