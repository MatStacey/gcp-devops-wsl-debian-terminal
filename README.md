# ⚡ Custom Developer Terminal Setup (Bash / WSL2)

A highly optimized, modular, and context-aware Bash environment designed for Cloud & DevOps engineers. 

Built specifically for WSL2 and Debian/Ubuntu systems, this setup provides a zero-lag dynamic prompt with clickable hyperlinks, instant state visualization for Git and Google Cloud (GCP), and a rich suite of automation aliases.

## ✨ Key Features

* **Modular Architecture:** No more monolithic `.bashrc`. Configurations are logically split into `~/.bash.d/` files (Environment, Aliases, GCP, DevOps, Git) and loaded automatically.
* **Zero-Lag Dynamic Prompt:** Reads local configuration files instead of running blocking CLI commands, ensuring your prompt renders instantly even in massive repositories or complex cloud setups.
* **Modern CLI Replacements:** Integrates Rust-based alternatives for speed and usability, including `eza` (replaces `ls`), `batcat` (replaces `cat`), and `ripgrep` / `rg` (replaces `grep`).
* **Supercharged History:** Retains up to 100,000 history entries (`HISTSIZE=100000`), ignores duplicates, and logs command execution times using `HISTTIMEFORMAT="%F %T "`.
* **Fuzzy Finding & Smart Navigation:** Features built-in `zoxide` support for instantaneous directory jumping, and interactive `fzf` prompt switching for GCP projects (`gc-switch`).
* **Built-in Self-Discovery:** Forget memorizing aliases. Type `mt` (mytools) in the terminal to instantly print a categorized list of all available custom functions and aliases.

---

## 🚀 Installation

### 1. Install Dependencies
To get the most out of this terminal, ensure you have the required modern CLI tools installed on your Debian/Ubuntu system:
```bash
sudo apt update
sudo apt install -y bat ripgrep fzf jq yq

```

*Note: You will also need to install [eza](https://github.com/eza-community/eza), [zoxide](https://github.com/ajeetdsouza/zoxide), and [kubectx/kubens](https://github.com/ahmetb/kubectx) to fully utilize the included aliases.*

### 2. Clone the repository

Clone this repository to a local directory (e.g., `~/dotfiles`):

```bash
git clone <your-repo-url> ~/dotfiles

```

### 3. Backup your existing configuration

Before importing, back up your current `.bashrc`:

```bash
cp ~/.bashrc ~/.bashrc.backup

```

### 4. Link or Copy the files

We recommend symlinking the files so you can easily pull future updates from this repo.

```bash
# Symlink the main .bashrc
ln -sf ~/dotfiles/.bashrc ~/.bashrc

# Symlink the modular directory
ln -sfn ~/dotfiles/.bash.d ~/.bash.d

```

### 5. Reload your shell

```bash
source ~/.bashrc

```

---

## 🎨 Prompt Color Guide

The prompt uses a lightning-fast local check to color-code your current environment state without lagging your terminal.

### ☁️ Google Cloud (GCP) Status

* 🟢 **Green:** Fully authenticated (User logged in AND Application Default Credentials exist).


* 🟡 **Amber:** Partially authenticated (User logged in, but Application Default Credentials file is missing).


* 🔴 **Red:** Not authenticated (No active account found).



### 🌿 Git Branch Status

* 🟢 **Green:** Local branch is clean and fully synchronized with the remote.


* 🟡 **Amber:** You have uncommitted changes, OR unpushed commits (ahead of remote).


* 🔴 **Red:** You are behind the remote (need to pull).


* 🔵 **Blue:** Local branch exists, but there is no upstream tracking/remote branch.



---

## 🧰 Discovering Tools & Commands

This setup includes dozens of wrappers and aliases for Terraform (`tf`), `gcloud`, `kubectl` (`k`), and Git (e.g., `git-acp`, `gc-ssh`, `tf-validate-all`). It also includes hundreds of shorthand commands for Kubernetes (e.g., `kgpo` for `kubectl get pods`) and Terraform.

Instead of reading the source code, you can view them instantly in your terminal. Just type:

```bash
mt

```

(Alias for `mytools`). This parses the `~/.bash.d/` directory and outputs a cleanly formatted, colorized list of every custom alias and function along with its description.

### Featured Commands

* `kx` / `kn`: Interactively switch Kubernetes contexts and namespaces (requires `kubectx`/`kubens`).


* `gc-switch`: Interactively search and switch your active GCP project (requires `fzf`).


* `gitc <url>`: Safely clone a git repository directly into your `~/vcs/` directory.


* `ll`: Detailed directory listing utilizing `eza` with Git status indicators.



---

## 🛠️ Adding Your Own Custom Configs

Because this setup is modular, you don't need to edit the main `.bashrc` to add your personal tools.

Simply create a new `.sh` file inside `~/.bash.d/`. The main `.bashrc` automatically sources any file in that directory ending in `.sh`.

**Example:**

```bash
touch ~/.bash.d/90-personal-aliases.sh

```

**Pro Tip:** If you write a custom function or alias and want it to show up in the `mt` command output, add a comment starting with `# =>` on the same line:

```bash
alias update-sys='sudo apt update && sudo apt upgrade' # => Updates Debian/Ubuntu packages

```
