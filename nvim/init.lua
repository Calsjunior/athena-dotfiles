-- ========================
-- Plugin Manager (vim-plug)
-- ========================
vim.cmd [[
  call plug#begin('~/.config/nvim/plugged')

  " THEMES
  Plug 'f4z3r/gruvbox-material.nvim'
  Plug 'neanias/everforest-nvim', { 'branch': 'main' }

  " FILE EXPLORER
  Plug 'nvim-tree/nvim-tree.lua'
  Plug 'nvim-tree/nvim-web-devicons'

  " FUZZY FINDER
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-lua/plenary.nvim'

  " TREESITTER
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

  " LSP / COMPLETION
  Plug 'neovim/nvim-lspconfig'
  Plug 'williamboman/mason.nvim'
  Plug 'williamboman/mason-lspconfig.nvim'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'

  " EDITING 
  Plug 'altermo/ultimate-autopair.nvim'
  Plug 'kylechui/nvim-surround'
  Plug 'abecodes/tabout.nvim'
  Plug 'numToStr/Comment.nvim'

  call plug#end()
]]

-- ========================
-- UI / Editing
-- ========================
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 5
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hlsearch = true
vim.opt.autoread = true
vim.opt.hidden = true
vim.opt.undofile = true
vim.opt.guicursor = "n-v-c:block-Cursor/lCursor-blinkwait1000-blinkon100-blinkoff100,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor"

-- ========================
-- Keybindings
-- ========================
vim.g.mapleader = ","
local map = vim.keymap.set

-- File operations
map("n", "<leader>w", ":w<CR>")
map("n", "<leader>q", ":q<CR>")

-- File explorer
map("n", "<leader>e", ":NvimTreeToggle<CR>")

-- Telescope
map("n", "<leader>ff", ":Telescope find_files<CR>")
map("n", "<leader>fg", ":Telescope live_grep<CR>")
map("n", "<leader>fb", ":Telescope buffers<CR>")
map("n", "<leader>fh", ":Telescope help_tags<CR>")

-- Search
map("n", "<Esc><Esc>", ":nohlsearch<CR>", { silent = true })

-- Terminal
map("n", "<leader>t", function()
  vim.cmd("rightbelow vsplit | terminal")
end, { desc = "Open terminal on the right" })
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
