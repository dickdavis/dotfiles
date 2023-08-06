# dotfiles

## Cheatsheets

This directory contains a set of cheatsheets for use with [Dash](https://kapeli.com/dash). The cheatsheets document usage of the programs configured with the files in the parent directory.

To generate a docset for use with Dash, install the `cheatset` gem.

```bash
gem install cheatset
```

Then, generate the docset.

```bash
cheatset generate example_cheatsheet.rb
```

Load the docset into Dash by using the Settings > Docsets > Add local docset interface.
