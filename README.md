# dotfiles

This repository contains configuration files for alacritty, neovim, vim, tmux, git, and zsh.

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

### Alacritty

Install alacritty.

```bash
brew install --cask alacritty --no-quarantine
```

Make a config directory for alacritty.

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

### Tmux

Install tmux.

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

Install neovim.

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

### Git

Install ctags so the included hooks can generate ctags automatically on different git actions.

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

## Optional

### Vim

Skip this section if opting for Neovim.

Create a directory for the temporary and backup files.

```bash
mkdir -p ~/.vim/backups
mkdir -p ~/.vim/tmp
```

Create a directory for the plugins.

```bash
mkdir -p ~/.vim/pack/vendor/start
```

Navigate to the newly created directory and clone the following repositories there. Follow the installation instructions for each plugin:

* [auto-pairs](https://github.com/jiangmiao/auto-pairs): Insert or delete brackets, parens, quotes in pair.
* [coc.nvim](https://github.com/neoclide/coc.nvim): LSP, syntax highlighting, linting, etc..
* [codeium.vim](https://github.com/Exafunction/codeium.vim): Codeium integration.
* [dash.vim](https://github.com/rizzatti/dash.vim): Dash integration.
* [dispatch](https://github.com/tpope/vim-dispatch): Asynchronous build and test dispatcher.
* [fugitive](https://github.com/tpope/vim-fugitive): Git integration.
* [tender.vim](https://github.com/jacoborus/tender.vim): Color scheme.
* [vim-ags](https://github.com/gabesoft/vim-ags): Silver searcher plugin.
* [vim-airline](https://github.com/vim-airline/vim-airline): Status/tabline.
* [vim-gitgutter](https://github.com/airblade/vim-gitgutter): Show git diff in the sign column.
* [vim-eunuch](https://github.com/tpope/vim-eunuch): Wrapper for shell commands.
* [vim-javascript](https://github.com/pangloss/vim-javascript): Improved JS syntax highlighting and indentation.
* [vim-jsx-pretty](https://github.com/MaxMEllon/vim-jsx-pretty): JSX syntax highlighting.
* [vim-prettier](https://github.com/prettier/vim-prettier): Wrapper for prettier.
* [vim-rails](https://github.com/tpope/vim-rails): Rails integration.
* [vim-slime](https://github.com/jpalardy/vim-slime): Send text from the editor to a live REPL.
* [vim-test](https://github.com/vim-test/vim-test): Run specs/tests from within the editor.

Create the paste file used by `vim-slime`.

```bash
touch ~/.slime_paste
```

Ensure `the_silver_searcher` is installed so that `vim-ags` can utilize it for search.

```bash
brew install the_silver_searcher
```

Setup codeium by entering the following command from within vim and following the instructions.

```
:Codeium Auth
```

To configure coc.nvim, create `coc-settings.json` in the `~/.vim` directory and add the following configuration:

```javascript
{
  "solargraph.autoformat": false,
  "solargraph.diagnostics": true,
  "solargraph.formatting": true,
  "solargraph.hover": true,
  "solargraph.logLevel": "debug"
}
```

Then, open vim and install the coc.nvim extensions:

```
:CocInstall coc-json coc-html coc-eslint coc-tsserver coc-solargraph coc-css
```

Install the `solargraph` and `solargraph-rails` gems globally. The configuration file for `solargraph` can be generated in a project with command:

```bash
solargraph config
```

Here's an example config that works nicely:

```yaml
include:
  - "**/*.rb"
exclude:
  - spec/**/*
  - test/**/*
  - vendor/**/*
  - ".bundle/**/*"
require: []
domains: []
reporters:
  - rubocop
require_paths: []
plugins:
  - solargraph-rails
max_files: 5000
```

### Note on Docker

It may be necessary to execute certain commands from within a docker context. One example of this is dispatching tests with vim-test.

```vimscript
if filereadable("docker-compose.yml")
  let test#ruby#rspec#executable = 'docker-compose exec app bundle exec rspec'
else
  let test#ruby#rspec#executable = 'bundle exec rspec'
endif
```
