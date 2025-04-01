# Archive

This directory contains configuration files and instructions for tools I no longer use.

## Set-up

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
