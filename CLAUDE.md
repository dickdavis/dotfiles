# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview
This is a personal dotfiles repository containing configuration files for various development tools organized primarily following XDG Base Directory Specification.

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

## Best Practices
- When modifying configurations, test changes before committing
- Document new tools in README.md following the existing format with horizontal rules
- Prefer Homebrew for installations on macOS when available