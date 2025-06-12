return {
  "neovim/nvim-lspconfig",
  config = function()
    -- Default LSP configurations
    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Ruby (Shopify's Ruby LSP)
    lspconfig.ruby_lsp.setup({
      capabilities = capabilities,
      init_options = {
        formatter = 'standard',
        linters = { 'standard' },
        enabledFeatures = {
          "documentHighlights",
          "documentSymbols",
          "foldingRanges",
          "selectionRanges",
          "semanticHighlighting",
          "formatting",
          "codeActions",
          "diagnostics",
          "documentLink",
          "hover",
          "inlayHint",
          "onTypeFormatting"
        },
        disabledFilePatterns = { "*.erb" },
      },
      filetypes = { "ruby" },
    })

    -- Elixir LSP configuration
    lspconfig.elixirls.setup({
      capabilities = capabilities,
      cmd = { vim.fn.expand("~/.config/elixir-ls-v0/language_server.sh") },
      filetypes = { "elixir", "eelixir", "heex", "surface" },
      root_dir = function(fname)
        local matches = vim.fs.find({ "mix.exs" }, { upward = true, limit = 2, path = fname })
        local child_or_root_path, maybe_umbrella_path = unpack(matches)
        return vim.fs.dirname(maybe_umbrella_path or child_or_root_path)
      end,
    })

    -- Lua server configuration for Neovim config files
    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
        },
      },
    })

    -- Global mappings for LSP
    vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
    vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

    -- Use LspAttach autocommand to set up mappings only when a server attaches
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        -- Buffer local mappings for LSP
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set("n", "<space>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
        vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<space>f", function() vim.lsp.buf.format({ async = true }) end, opts)
      end,
    })

    -- Special Ruby file detection
    vim.api.nvim_create_autocmd("BufRead", {
      pattern = {"Gemfile", "Rakefile", "Guardfile", "*.rake", "*.rb"},
      callback = function()
        vim.bo.filetype = "ruby"
      end,
    })
  end,

  dependencies = {
    "hrsh7th/cmp-nvim-lsp", -- Add dependency for capabilities
  },
}
