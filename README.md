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

- [Alacritty](#alacritty)
- [Zsh](#zsh)
- [asdf](#asdf)
- [Tmux](#tmux)
- [Neovim](#neovim)
- [Github CLI](#github-cli)
- [Git](#git)
- [Dash](#dash)
- [Docker](#docker)

### Alacritty

Install alacritty.

```bash
brew install --cask alacritty --no-quarantine
```

Make a config directory for `alacritty`.

```bash
mkdir ~/.config/alacritty
```

Copy the config file to the `~/.config/alacritty` directory.

```bash
cp .config/alacritty/alacritty.toml ~/.config/alacritty/
```

### Zsh

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
cp -r .config/zsh/ ~/.config/zsh/
```

Copy the `.zshenv` file to your home directory.

```bash
cp .zshenv ~/.zshenv
```

Follow the instructions [here](https://draculatheme.com/zsh) to install the dracula theme manually.

### asdf

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
cp .config/asdf/.asdfrc ~/.config/asdf/

# Copy the tool versions file
cp .tool_versions ~/.tool_versions
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


### Tmux

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
cp .config/tmux/tmux.conf ~/.config/tmux/
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

### Neovim

Install `neovim`.

```bash
brew install neovim
```

Make a config directory for neovim.

```bash
mkdir ~/.config/nvim
```

Copy `.config/nvim` to the `~/.config/nvim` directory.

```bash
cp -r .config/nvim/ ~/.config/nvim
```

Run `:Lazy install` to install the plugins.

You will need to authenticate with `:Codeium Auth` to use the `codeium.vim` plugin.

Also, you should ensure that `ruby-lsp` and `standardrb` gems are installed.

### Github CLI

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

Configure the SSH agent to load keys and store passphrases in the keychain.

```bash
# ~/.ssh/config
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
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
cp .config/gh/config.yml ~/.config/gh/
```

### Git

Copy the git configuration file to your home directory.

```bash
cp .gitconfig ~/.gitconfig
```

Modify the `~/.gitconfig` to contain the email you wish to globally configure.

Copy the git template directory to your home directory.

```bash
cp -r .git_template ~/.git_template
```

The `.git_template` directory contains git hooks that automatically generate ctags when you perform git actions like commit, checkout, merge, and rebase. This helps with code navigation in editors that support ctags.

Install `ctags` so the included hooks can generate ctags automatically on different git actions.

```bash
brew install ctags
```

### Dash

Install Dash by downloading it from the [official website](https://kapeli.com/dash) and then applying the license file.

Download the following docsets by usings the Dash > Settings > Downloads interface:

* Ruby 3
* Ruby on Rails 7
* Sass
* Vim
* Redis
* React
* PostgreSQL
* JavaScript
* Apple API Reference
* C
* Common Lisp
* Font Awesome
* Git
* Ruby strftime
* Rspec Expectations
* Rails Migrations CLI

### Docker

Install Docker by downloading it from the [official website](https://docs.docker.com/get-started/get-docker/)
