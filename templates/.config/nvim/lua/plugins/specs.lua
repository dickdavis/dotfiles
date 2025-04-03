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
          rspec_cmd = function(position_type)
            -- Check if docker-compose.yml exists and project relies on it for the app
            local docker_compose_path = vim.fn.getcwd() .. "/docker-compose.yml"
            local uses_docker = false

            -- Check if the project directory has a docker-compose.yml file
            if vim.fn.filereadable(docker_compose_path) == 1 then
              -- Try to determine if the app service is defined in docker-compose
              local docker_check = vim.fn.system("grep -q '\\sapp:' " .. docker_compose_path)
              if vim.v.shell_error == 0 then
                uses_docker = true
              end
            end

            if uses_docker then
              return vim.tbl_flatten({
                "docker", "compose", "exec", "app", "bundle", "exec", "rspec"
              })
            else
              return vim.tbl_flatten({
                "bundle", "exec", "rspec"
              })
            end
          end,

          -- Use the JSON formatter instead of the custom formatter
          formatter = "j",

          -- Transform the file path for Docker containers
          transform_spec_path = function(path)
            -- Check if docker-compose.yml exists and project relies on it for the app
            local docker_compose_path = vim.fn.getcwd() .. "/docker-compose.yml"
            local uses_docker = false

            -- Check if the project directory has a docker-compose.yml file
            if vim.fn.filereadable(docker_compose_path) == 1 then
              -- Try to determine if the app service is defined in docker-compose
              local docker_check = vim.fn.system("grep -q '\\sapp:' " .. docker_compose_path)
              if vim.v.shell_error == 0 then
                uses_docker = true
              end
            end

            if uses_docker then
              -- Convert the local path to a path relative to the project root
              local project_root = vim.fn.getcwd()
              local relative_path = path:sub(#project_root + 2) -- +2 to account for the trailing slash
              return relative_path
            else
              -- For local execution, use the full path
              return path
            end
          end,
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
