-- UI settings
vim.opt.background = "dark"         -- Dark background
vim.opt.ruler = true                -- Ruler on (default in Neovim, but explicit is fine)
vim.opt.number = true               -- Line numbers on
vim.opt.relativenumber = true       -- Relative line numbers
vim.opt.wrap = false                -- Line wrapping off
vim.opt.timeoutlen = 250            -- Time to wait after ESC
vim.opt.showmatch = true            -- Show matching brackets
vim.opt.mat = 5                     -- Bracket blinking
vim.opt.confirm = true              -- Confirm changes for unsaved buffers

-- Tab and indentation settings
vim.opt.tabstop = 2                 -- Tabs are 2 spaces
vim.opt.shiftwidth = 2              -- Tabs under smart indent
vim.opt.expandtab = true            -- Use spaces instead of tabs
vim.opt.smarttab = true             -- Smart tab handling
vim.opt.cindent = true              -- C-style indentation
vim.opt.autoindent = true           -- Auto indentation
vim.opt.cinoptions = ":0,p0,t0"     -- Indentation options
vim.opt.cinwords = "if,else,while,do,for,switch,case"
vim.opt.formatoptions = "tcqr"

-- Search settings
vim.opt.incsearch = true            -- Incremental search (default in Neovim)

-- Whitespace visualization
vim.opt.list = true                 -- Makes whitespace characters visible
vim.opt.listchars = {tab = "  ", trail = "~", extends = ">", precedes = "<"}

-- Folding settings
vim.opt.foldmethod = "indent"
vim.opt.foldnestmax = 10
vim.opt.foldenable = true
vim.opt.foldlevelstart = 10
vim.opt.viewoptions:remove("curdir")

-- Buffer behavior
vim.opt.hidden = true               -- Allow switching buffers without saving
vim.opt.splitkeep = "screen"        -- Fix for split behavior

-- Status line
vim.opt.laststatus = 2              -- Always show status line (default in Neovim)

-- Disable bells
vim.opt.visualbell = false          -- No blinking
vim.opt.errorbells = false          -- No noise

-- Backup settings
vim.opt.backup = true               -- Enable creation of backup file
vim.opt.backupdir = vim.fn.expand("~/.config/nvim/backups")  -- Changed path
vim.opt.directory = vim.fn.expand("~/.config/nvim/tmp")      -- Changed path

-- Clipboard settings
vim.opt.clipboard = "unnamedplus"   -- Changed to unnamedplus for better system clipboard integration

-- Custom file type detection (only if you still need it)
vim.cmd("autocmd BufRead,BufNewFile *.es6 setfiletype javascript")

-- Sets file for ctags references
vim.opt.tags = "./tags;"

-- Save view (folds, cursor position)
vim.cmd([[
  autocmd BufWinLeave *.* mkview
  autocmd BufWinEnter *.* silent! loadview
]])

-- Netrw settings
vim.g.netrw_fastbrowse = 0          -- Close netrw after opening file

-- Key mappings
vim.api.nvim_set_keymap('v', '<C-r>', '"hy:%s/<C-r>h//gc<left><left><left>', {noremap = true})
vim.api.nvim_set_keymap('n', '<left>', ':bprevious<CR>', {noremap = true})
vim.api.nvim_set_keymap('n', '<right>', ':bnext<CR>', {noremap = true})
vim.api.nvim_set_keymap('c', 'w!!', 'w !sudo tee > /dev/null %', {noremap = true})

-- Create directories if they don't exist
local function ensure_dir(dir)
  local ok, err = vim.loop.fs_stat(dir)
  if not ok then
    vim.loop.fs_mkdir(dir, 493)  -- 0755 permissions
  end
end

ensure_dir(vim.fn.expand("~/.config/nvim/backups"))
ensure_dir(vim.fn.expand("~/.config/nvim/tmp"))

-- Plugin management
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")
