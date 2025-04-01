return {
  "rizzatti/dash.vim",
  lazy = false,  -- Load the plugin immediately
  config = function()
    vim.keymap.set("n", "<leader>d", ":Dash<CR>", { silent = true, desc = "Open Dash documentation" })
    vim.g.dash_map = {
      ruby = 'ruby,rails',
      javascript = 'javascript,nodejs',
    }
  end,

  -- Only load on macOS where Dash is available
  cond = function()
    return vim.fn.has('mac') == 1
  end,
}
