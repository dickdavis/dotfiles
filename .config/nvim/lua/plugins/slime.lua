return {
  "jpalardy/vim-slime",
  lazy = false,
  config = function()
    vim.g.slime_target = "tmux"
    vim.g.slime_paste_file = vim.fn.expand("$HOME/.slime_paste")
    vim.g.slime_default_config = {
      socket_name = "default", 
      target_pane = "{last}"
    }
  end,
}
