# dotfiles

This repository contains configuration files for vim, tmux, git, and spacemacs. Copy each of the files to the home directory to get started.

## Additional Setup

Some additional setup and configuration is required.

### Git

Install ctags so the included hooks can generate ctags automatically on different git actions.

```bash
brew install ctags
```

### Tmux

Install the tmux package manager.

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Reload the tmux environment to source TPM.

```bash
tmux source ~/.tmux.conf
```

Install the plugins by pressing `prefix` + `I`.

### Vim

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
* [copilot.vim](https://github.com/github/copilot.vim): Copilot integration.
* [dash.vim](https://github.com/rizzatti/dash.vim): Dash integration.
* [dispatch](https://github.com/tpope/vim-dispatch): Asynchronous build and test dispatcher.
* [fugitive](https://github.com/tpope/vim-fugitive): Git integration.
* [tender.vim](https://github.com/jacoborus/tender.vim): Color scheme.
* [vim-ags](https://github.com/gabesoft/vim-ags): Silver searcher plugin.
* [vim-airline](https://github.com/vim-airline/vim-airline): Status/tabline.
* [vim-gitgutter](https://github.com/airblade/vim-gitgutter): Show git diff in the sign column.
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

Setup copilot by entering the following command from within vim and following the instructions.

```
:Copilot setup
```

Copilot is disabled by default (modify `.vimrc` if this is not desired). To enable it for a session, execute the following from within vim.

```
:Copilot enable
```

To configure coc.nvim, create `coc-settings.json` in the `~/.vim` directory and add the following configuration:

```javascript
{
  "solargraph.autoformat": false,
  "solargraph.diagnostics": true,
  "solargraph.formatting": true,
  "solargraph.hover": true,
  "solargraph.logLevel": "debug",
  "[javascript][ruby]": {
    "coc.preferences.formatOnSave": true
  }
}
```

Then, open vim and install the coc.nvim extensions:

```
:CocInstall coc-json coc-html coc-eslint coc-tsserver coc-solargraph coc-css
```

Lastly, install the `solargraph` and `solargraph-rails` gems globally. The configuration file for `solargraph` can be generated in a project with command:

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

### Working with Docker

Some modifications will be necessary for this set-up to work with dockerized applications.

Modify `.vimrc` to configure `vim-test` to use the correct command for executing the specs.

```vimscript
if filereadable("docker-compose.yml")
  let test#ruby#rspec#executable = 'docker-compose exec web bundle exec rspec'
else
  let test#ruby#rspec#executable = 'bundle exec rspec'
endif
```

Create a `solargraph` service within the `docker-compose.yml` file to run the server. Here is an example configuration. In particular, note the command used and the ports exposed for the `solargraph` service).

```yaml
version: '3'

services:
  app: &app
    tty: true
    stdin_open: true
    build:
      context: .
      dockerfile: Dockerfile
    volumes:
      - .:/app
      - bundle_cache:/bundle
    env_file: .env

  web:
    <<: *app
    # Comment out the following line to allow for manual control of web server init
    command: ./bin/dev
    ports:
      - '3000:3000'
    tmpfs:
      - /app/tmp/pids/
    depends_on:
      - app
      - db
      - redis

  solargraph:
    <<: *app
    command: 'bundle exec solargraph socket --host=0.0.0.0 --port=7658'
    ports:
      - target: 7658
        published: 8091

  db:
    image: postgres
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
    ports:
      - '5432:5432'
    volumes:
      - postgres:/var/lib/postgresql/data

  redis:
    image: redis:alpine
    ports:
      - '6379:6379'

  mailcatcher:
    image: dockage/mailcatcher
    ports:
      - '1025:1025'
      - '1080:1080'

volumes:
  bundle_cache:
  postgres:
```

Add a step toward the bottom of the `Dockerfile` to create a symlink to the `.rubocop.yml` file so that `rubocop` is able to read its configuration properly.

```
RUN ln -s /app/.rubocop.yml ~/.rubocop.yml
```

Modify the `coc-settings.json` file to communicate with the `solargraph` server running within the docker container.

```javascript
{
  "solargraph.autoformat": true,
  "solargraph.diagnostics": true,
  "solargraph.formatting": true,
  "solargraph.hover": true,
  "solargraph.logLevel": "debug",
  "[javascript][ruby]": {
    "coc.preferences.formatOnSave": true
  },
  "[ruby]": {
    "solargraph.logLevel": "debug",
    "solargraph.transport": "external",
    "solargraph.externalServer": {
      "host": "localhost",
      "port": 8091
    }
  }
}
```
