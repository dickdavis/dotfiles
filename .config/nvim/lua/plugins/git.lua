return {
  {
    'tpope/vim-fugitive',
    cmd = { 'Git', 'G' }
  },
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require('gitsigns').setup({
        signs = {
          add          = { text = '│' },
          change       = { text = '│' },
          delete       = { text = '_' },
          topdelete    = { text = '‾' },
          changedelete = { text = '~' },
          untracked    = { text = '┆' },
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          -- Navigation between hunks
          vim.keymap.set('n', ']c', function()
            if vim.wo.diff then return ']c' end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
          end, {expr=true, buffer=bufnr, desc="Next git hunk"})

          vim.keymap.set('n', '[c', function()
            if vim.wo.diff then return '[c' end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
          end, {expr=true, buffer=bufnr, desc="Previous git hunk"})

          -- Actions for hunks
          vim.keymap.set('n', '<leader>hs', gs.stage_hunk, {buffer=bufnr, desc="Stage git hunk"})
          vim.keymap.set('n', '<leader>hr', gs.reset_hunk, {buffer=bufnr, desc="Reset git hunk"})
          vim.keymap.set('n', '<leader>hS', gs.stage_buffer, {buffer=bufnr, desc="Stage git buffer"})
          vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, {buffer=bufnr, desc="Undo stage git hunk"})
          vim.keymap.set('n', '<leader>hR', gs.reset_buffer, {buffer=bufnr, desc="Reset git buffer"})
          vim.keymap.set('n', '<leader>hp', gs.preview_hunk, {buffer=bufnr, desc="Preview git hunk"})
          vim.keymap.set('n', '<leader>hb', function() gs.blame_line{full=true} end, {buffer=bufnr, desc="Git blame line"})
        end
      })
    end,
  }
}
