# ------------------------------------------
# System & Environment Bootstrap
# ------------------------------------------

__bootstrap_apt() {
	local apt_deps=()
	command -v jq >/dev/null 2>&1 || apt_deps+=("jq")
	command -v fzf >/dev/null 2>&1 || apt_deps+=("fzf")
	command -v rg >/dev/null 2>&1 || apt_deps+=("ripgrep")
	command -v batcat >/dev/null 2>&1 || apt_deps+=("bat")
	command -v rsync >/dev/null 2>&1 || apt_deps+=("rsync")
	command -v shfmt >/dev/null 2>&1 || apt_deps+=("shfmt")
	command -v file >/dev/null 2>&1 || apt_deps+=("file")
	python3 -c "import yaml" 2>/dev/null || apt_deps+=("python3-yaml")

	if [ ${#apt_deps[@]} -gt 0 ]; then
		echo -e "\n📦 Installing standard APT dependencies: ${apt_deps[*]}..."
		sudo apt-get update && sudo apt-get install -y "${apt_deps[@]}"
	else
		echo "✅ All standard APT dependencies are satisfied."
	fi
}

__bootstrap_python() {
	local pip_deps=()
	command -v ruff >/dev/null 2>&1 || pip_deps+=("ruff")
	command -v checkov >/dev/null 2>&1 || pip_deps+=("checkov")

	if [ ${#pip_deps[@]} -gt 0 ]; then
		echo -e "\n🐍 Installing Python CLI tools: ${pip_deps[*]}..."
		if command -v pipx >/dev/null 2>&1; then
			for pkg in "${pip_deps[@]}"; do pipx install "$pkg"; done
		else
			pip3 install --user "${pip_deps[@]}"
		fi
	else
		echo "✅ All Python CLI dependencies are satisfied."
	fi
}

__bootstrap_yq() {
	if ! command -v yq >/dev/null 2>&1; then
		echo -e "\n⚙️ Installing 'yq'..."
		sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
		sudo chmod a+x /usr/local/bin/yq
		echo "✅ yq installed."
	fi
}

__bootstrap_check_complex() {
	local missing_complex_deps=()
	command -v terraform >/dev/null 2>&1 || missing_complex_deps+=("terraform")
	command -v gcloud >/dev/null 2>&1 || missing_complex_deps+=("google-cloud-cli")
	command -v kubectl >/dev/null 2>&1 || missing_complex_deps+=("kubectl")
	command -v eza >/dev/null 2>&1 || missing_complex_deps+=("eza")

	if [ ${#missing_complex_deps[@]} -gt 0 ]; then
		echo -e "\n⚠️  The following tools are missing and require manual repo config:"
		for dep in "${missing_complex_deps[@]}"; do echo "  - $dep"; done
	fi
}

#######################################
# System: Bootstrap missing dependencies for bash aliases (Debian/WSL)
#######################################
bootstrap() {
	if [[ "$1" == "-h" || "$1" == "--help" ]]; then
		mt-help "${FUNCNAME[0]}"
		return 0
	fi
	echo "🔍 Scanning system for missing dependencies..."

	__bootstrap_apt
	__bootstrap_python
	__bootstrap_yq
	__bootstrap_check_complex

	echo -e "\n🎉 Environment bootstrap complete!"
}

__check_missing_deps() {
	if [[ $- != *i* ]]; then return; fi

	local missing=0
	local deps=(jq fzf rg batcat rsync shfmt file ruff checkov terraform gcloud kubectl eza yq)

	for dep in "${deps[@]}"; do
		if ! command -v "$dep" >/dev/null 2>&1; then
			missing=1
			break
		fi
	done

	if [ "$missing" -eq 0 ] && ! python3 -c "import yaml" >/dev/null 2>&1; then
		missing=1
	fi

	if [ "$missing" -eq 1 ]; then
		echo -e "\n\e[33m⚠️  Missing required dependencies detected in your environment.\e[0m"
		read -p "Would you like to run 'bootstrap' to install them now? [Y/n] " -n 1 -r choice
		echo

		if [[ $choice =~ ^[Yy]$ ]] || [[ -z $choice ]]; then
			bootstrap
		fi
	fi
}

__check_missing_deps
