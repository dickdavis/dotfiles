return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter.configs").setup({
      -- A list of parser names, or "all" (the listed parsers should always be installed)
      ensure_installed = {
        "ruby",
        "lua",
        "vim",
        "vimdoc",
        "javascript",
        "typescript",
        "markdown",
        "markdown_inline",
        "html",
        "css",
        "yaml",
        "json",
        "terraform",
      },
      ignore_install = {},
      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,
      -- Automatically install missing parsers when entering buffer
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
        disable = { "ruby" }
      },
      modules = {}
    })
  end,
}
