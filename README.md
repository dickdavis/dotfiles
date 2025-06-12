# dotfiles

This repository contains configuration files for the tools that are part of my development workflow.

Check [here](cheatsheets/README.md) to view cheatsheets that document usage of the customizations.

## Set-up

Clone the repo.

```bash
git clone git@github.com:dickdavis/dotfiles.git
```

Create a `~/.config` directory to store all of the configuration files.

```bash
mkdir ~/.config
```

Follow instructions for each tool to get started.

- [homebrew](#homebrew): package management
- [alacritty](#alacritty): terminal emulator
- [zsh](#zsh): shell
- [asdf](#asdf): version management for programming languages
- [tmux](#tmux): terminal multiplexing
- [tmuxinator](#tmuxinator): managing tmux layouts
- [tmate](#tmate): pair-programming over ssh
- [neovim](#neovim): text editor
- [git](#git): version control
- [Github CLI](#github-cli): interacting with Github via CLI
- [Claude Code](#claude-code): using Claude within a terminal
- [Claude Desktop](#claude-desktop): using Claude via app
- [Dash](#dash): documentation tool
- [Podman Desktop](#podman-desktop): building and running containers
- [AutoRaise](#autoraise): focus follows mouse for Mac

---

### homebrew

Install `homebrew`.

```bash
/bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

---

### alacritty

Run the `scripts/configure_alacritty` script to install and configure `alacritty`. Ensure you install the font manually after the script completes.

#### Manual instructions

Install `alacritty`.

```bash
brew install --cask alacritty --no-quarantine
```

Make a config directory for `alacritty`.

```bash
mkdir ~/.config/alacritty
```

Copy the config file to the `~/.config/alacritty` directory.

```bash
cp templates/.config/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
```

Install the Fire Code Nerd font by [downloading](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/FiraCode.zip) the font and [installing](https://support.apple.com/guide/font-book/install-and-validate-fonts-fntbk1000/mac) it.

---

### zsh

Run the `scripts/configure_zsh` script to install and configure `zsh`. Ensure you install the dracula theme manually after the script completes.

#### Manual instructions

Download and run the `ohmyzsh` script.

```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Make a config directory for zsh.

```bash
mkdir ~/.config/zsh
```

Move the `oh-my-zsh` installation over to the `~/.config/zsh` directory.

```bash
mv ~/.oh-my-zsh ~/.config/zsh/.oh-my-zsh
```

Copy the config files over to the zsh config directory.

```bash
cp -r templates/.config/zsh/ ~/.config/zsh/
```

Copy the `.zshenv` file to your home directory.

```bash
cp templates/.zshenv ~/.zshenv
```

Follow the instructions [here](https://draculatheme.com/zsh) to install the dracula theme manually.

---

### asdf

Run the `scripts/configure_asdf` script to install and configure `asdf`.

#### Manual instructions

Install `asdf`.

```bash
brew install coreutils git
brew install asdf
```

Set up asdf to use XDG directories:

```bash
# Create directories according to XDG Base Directory spec
mkdir -p ~/.config/asdf
mkdir -p ~/.local/share/asdf

# Copy the configuration file
cp templates/.config/asdf/.asdfrc ~/.config/asdf/.asdfrc

# Copy the tool versions file
cp templates/.tool_versions ~/.tool-versions

# Copy the .default-gems file
cp templates/.default-gems ~/.default-gems
```

Install the asdf plugins for default languages, and install the default versions specified in `.tool_versions`:

```bash
# Install ruby plugin
asdf plugin add ruby

# Install nodejs plugin (includes keyring setup for Node.js)
asdf plugin add nodejs

# Install java plugin
asdf plugin add java

# Install lua plugin
asdf plugin add lua

# Install elixir plugin
asdf plugin add elixir

# Install golang plugin
asdf plugin add golang

# Install python plugin
asdf plugin add python

# Install the versions specified in .tool_versions
asdf install
```

---

### tmux

Run the `scripts/configure_tmux` script to install and configure `tmux`. Ensure you manually install the plugins after the script completes.

#### Manual instructions

Install `tmux`.

```bash
brew install tmux
```

Make a config directory for tmux.

```bash
mkdir ~/.config/tmux
```

Copy the config file to the `~/.config/tmux` directory.

```bash
cp templates/.config/tmux/tmux.conf ~/.config/tmux/tmux.conf
```

Install the tmux package manager.

```bash
git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
```

Reload the tmux environment to source TPM.

```bash
tmux source ~/.config/tmux/tmux.conf
```

Install the plugins by pressing `prefix` + `I`.

---

### tmuxinator

Run the `scripts/configure_tmuxinator` script to install and configure `tmuxinator`.

#### Manual instructions

Install `tmuxinator` if not already installed.

```bash
gem install tmuxinator
```

Copy the example layouts to `~/.config/tmuxinator/` directory.

```bash
cp -r templates/.config/tmuxinator/* ~/.config/tmuxinator
```

Copy the example layouts and modify as necessary per project.

---

### tmate

Run the `scripts/configure_tmate` script to install and configure `tmate`.

#### Manual instructions

Install `tmate`.

```bash
brew install tmate
```

Copy the config file to the home directory.

```bash
cp templates/.config/tmate/tmate.conf ~/.config/tmate/tmate.conf
```

---

### neovim

Run the `scripts/configure_neovim` script to install and configure `neovim`. Ensure you install the plugins after the script completes.

#### Manual instructions

Install `neovim`.

```bash
brew install neovim
```

Install `ripgrep`.

```bash
brew install ripgrep
```

Make a config directory for neovim.

```bash
mkdir ~/.config/nvim
```

Copy `.config/nvim` to the `~/.config/nvim` directory.

```bash
cp -r templates/.config/nvim/ ~/.config/nvim
```

Run `:Lazy install` to install the plugins.

Also, you should ensure that `ruby-lsp` and `standardrb` gems are installed.

Install the `elixir-ls` language server by downloading the zip file from [here](https://github.com/elixir-lsp/elixir-ls/releases/latest/), then moving the unzipped directory to `~/.config/elixir-ls-v0`. Make the `language_server.sh` script executable:

```bash
chmod +x ~/.config/elixir-ls-v0/language_server.sh
```

---

### git

Run the `scripts/configure_git` script to install and configure `git`. This will prompt for your name and email for Git configuration.

```bash
./scripts/configure_git
```

Or provide your name and email as command-line arguments:

```bash
./scripts/configure_git -n "Your Name" -e "your.email@example.com"
```

#### Manual instructions

Install `ctags` for the git hooks:

```bash
brew install ctags
```

Create a git template directory in your home directory:

```bash
mkdir -p ~/.git_template
cp -r templates/.git_template/ ~/.git_template/
chmod +x ~/.git_template/hooks/*
```

Configure git:

```bash
# Set your git user information
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Set the git template directory
git config --global init.templatedir ~/.git_template

# Set up tracking with remote
git config --global push.autoSetupRemote true
```

The `.git_template` directory contains git hooks that automatically generate ctags when you perform git actions like commit, checkout, merge, and rebase. This helps with code navigation in editors that support ctags.

---

### Github CLI

Run the `scripts/configure_gh` script to install and configure `gh` CLI. This will also setup an SSH key for the machine and add it to your Github account.

#### Manual instructions

Install the `gh` CLI.

```bash
brew install gh
```

Login.

```bash
gh auth login
```

Generate a new SSH key.

```bash
ssh-keygen -t ed25519 -C "[EMAIL]"
```

Start the SSH agent.

```bash
eval "$(ssh-agent -s)"
```

Copy the config file to the `~/.ssh` directory.

```bash
cp templates/.ssh/config ~/.ssh/config
```

Add the key to the SSH agent.

```bash
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
```

Add the key to the Github account.

```bash
gh ssh-key add ~/.ssh/id_ed25519.pub --title "$(hostname)" --type authentication
```

Copy the config file to the `~/.config/gh` directory.

```bash
cp templates/.config/gh/config.yml ~/.config/gh/config.yml
```

---

### Claude Code

Install the `claude-code` npm package.

```bash
npm install -g @anthropic-ai/claude-code
```

Enable vim keybindings with the `/vim` slash command.

Add a local MCP server (example):

```bash
claude mcp add my-server -- /path/to/server
```

---

### Claude Desktop

Install Claude Desktop by downloading it from the [official website](https://claude.ai/download).

Add a local MCP server by following the [official instructions](https://modelcontextprotocol.io/quickstart/user).

---

### Dash

Install Dash by downloading it from the [official website](https://kapeli.com/dash) and then applying the license file.

Download the following docsets by usings the Dash > Settings > Downloads interface:

* Ruby
* Ruby on Rails
* Redis
* PostgreSQL
* JavaScript
* C
* Python
* Elixir
* Golang
* Common Lisp
* Font Awesome
* Git
* Ruby strftime
* Rspec Expectations
* Rails Migrations CLI

Generate and install the cheatsheets located in the `cheatsheets/` directory. Run the `scripts/generate_cheatsheets` script to generate the cheatsheets.

---

### Podman Desktop

Install Podman. Refer to the [documentation](https://podman-desktop.io/docs/podman) for further installation and configuration instructions.

```bash
brew install podman-desktop
```

---

### AutoRaise

Install AutoRaise and enable it in system preferences.

```bash
brew install --cask dimentium/autoraise/autoraiseapp
```
