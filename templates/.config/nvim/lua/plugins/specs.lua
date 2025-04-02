return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "olimorris/neotest-rspec",
  },
  config = function()
    local ts_install = require("nvim-treesitter.install")
    local parser_installed = ts_install.ensure_installed("ruby")
    local neotest = require("neotest")

    neotest.setup({
      discovery = {
        enabled = true,
      },
      output = {
        enabled = true,
        open_on_run = true,
      },
      adapters = {
        require("neotest-rspec")({
          rspec_cmd = function()
            return vim.tbl_flatten({
              "bundle",
              "exec",
              "rspec",
            })
          end,

          -- Optional: Additional RSpec args (like formatting)
          -- Example for using RSpec documentation format:
          -- rspec_args = { "--format", "documentation" },
        }),
      },
    })

    -- Set up keymappings for neotest
    vim.keymap.set("n", "<leader>tn", function() neotest.run.run() end, { desc = "Run nearest test" })
    vim.keymap.set("n", "<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end, { desc = "Run current file" })
    vim.keymap.set("n", "<leader>ts", function() neotest.run.run({ suite = true }) end, { desc = "Run entire test suite" })
    vim.keymap.set("n", "<leader>to", function() neotest.output.open({ enter = true, auto_close = true }) end, { desc = "Open test output" })
    vim.keymap.set("n", "<leader>tO", function() neotest.output_panel.toggle() end, { desc = "Toggle output panel" })
    vim.keymap.set("n", "<leader>tS", function() neotest.summary.toggle() end, { desc = "Toggle summary panel" })
    vim.keymap.set("n", "<leader>tw", function() neotest.watch.toggle() end, { desc = "Toggle test watching" })
    vim.keymap.set("n", "<leader>tr", function() neotest.run.run_last() end, { desc = "Run last test" })
    vim.keymap.set("n", "[t", function() neotest.jump.prev({ status = "failed" }) end, { desc = "Jump to previous failed test" })
    vim.keymap.set("n", "]t", function() neotest.jump.next({ status = "failed" }) end, { desc = "Jump to next failed test" })
  end,
  after = { "nvim-treesitter" }
}
