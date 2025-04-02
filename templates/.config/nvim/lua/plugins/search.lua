return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'folke/trouble.nvim',
  },
  config = function()
    local actions = require("telescope.actions")
    local open_with_trouble = require("trouble.sources.telescope").open
    local add_to_trouble = require("trouble.sources.telescope").add

    require('telescope').setup({
      defaults = {
        mappings = {
          i = { ["<c-t>"] = open_with_trouble },
          n = { ["<c-t>"] = open_with_trouble },
        },
      },
    })

    -- Key bindings for Telescope
    vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = "Find Files" })
    vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = "Live Grep" })
    vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = "Buffers" })
    vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', { desc = "Help Tags" })
  end,
}
