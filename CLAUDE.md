# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview
This is a personal dotfiles repository containing configuration files for various development tools organized primarily following XDG Base Directory Specification.

## Tools Included
The repository contains configurations for:
- homebrew: package management
- alacritty: terminal emulator
- zsh: shell
- direnv: load environment variables from config files
- asdf: version management for programming languages
- tmux: terminal multiplexing
- tmuxinator: managing tmux layouts
- tmate: pair-programming over ssh
- neovim: text editor
- git: version control
- Github CLI: interacting with Github via CLI
- Claude Code: using Claude within a terminal
- Claude Desktop: using Claude via app
- Dash: documentation tool
- Podman Desktop: building and running containers
- AutoRaise: focus follows mouse for Mac

## Commands
- No specific build/test commands as this is a configuration repository
- For linting shell scripts: `shellcheck <script-path>`
- For validating config files: Use tool-specific validators (e.g. `tmux -f ~/.config/tmux/tmux.conf`)

## Style Guidelines
- Follow existing formatting in each config file
- Maintain XDG Base Directory structure (`~/.config/` for configurations)
- Use descriptive comments for non-obvious configurations
- Keep files organized by tool purpose
- Follow tool-specific syntax and conventions
- For shell scripts: Use POSIX-compatible syntax when possible

## Naming Conventions
- Configuration files: Use standard names expected by tools (e.g., `alacritty.toml`, `tmux.conf`)
- Directories: Match tool names (e.g., `~/.config/nvim/`)
- Cheatsheets: Follow the pattern `my_<tool>_cheatsheet.rb`
- Installation scripts: Follow the pattern `scripts/configure_<tool>`

## Best Practices
- When modifying configurations, test changes before committing
- Document new tools in README.md following the existing format with horizontal rules
- Prefer Homebrew for installations on macOS when available
- Create installation scripts in the `scripts/` directory for each tool
- Include both automated script instructions and manual installation steps in README