-- stoopid config written by jobcmax

vim.cmd([[

set shortmess+=I
set noshowmode
set number

runtime mswin.vim
nmap <c-q> :q!<CR>
imap <c-q> <Esc>:q!<CR>
nmap <c-up> :1<CR>
nmap <c-down> :$<CR>
imap <c-up> <Esc>:1<CR>:startinsert<CR>
imap <c-down> <Esc>:$<CR>:startinsert<CR>
imap <c-f> <Esc>/
nmap <c-f> <Esc>/
nmap <c-o> <Esc>:Lf<CR>
imap <c-o> <Esc>:Lf<CR>
nmap <c-_> <Esc>:Commentary<CR>
imap <c-_> <Esc>:Commentary<CR>:startinsert<CR>

:startinsert

    augroup change_cursor
        au!
        au ExitPre * :set guicursor=a:ver90
    augroup END

:set tabstop=4
:set shiftwidth=4
:set expandtab

source /home/max/.config/nvim/comment.vim
]])

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
vim.g.mapleader = " " 

require("lazy").setup({
  "decaycs/decay.nvim",
  "folke/tokyonight.nvim",
  "feline-nvim/feline.nvim",
  -- "ayu-theme/ayu-vim",
  "lukas-reineke/indent-blankline.nvim",
  "neovim/nvim-lspconfig",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/nvim-cmp",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "ptzz/lf.vim",
  "voldikss/vim-floaterm",
  "jiangmiao/auto-pairs",
  -- "nvim-treesitter/nvim-treesitter",
  "preservim/nerdtree",
  "nvim-lua/plenary.nvim",
  "startup-nvim/startup.nvim",
  "kyazdani42/nvim-web-devicons",
  "NvChad/nvim-colorizer.lua",
  "ms-jpq/coq_nvim",
  "echasnovski/mini.nvim", version = false,
  "MunifTanjim/nui.nvim",
  "startup-nvim/startup.nvim",
})

-- vim.cmd [[colorscheme tokyonight-night]]

require('decay').setup({
  style = 'dark',
  nvim_tree = {
    contrast = true,
  },
})

require('statusline')
require('start')
vim.opt.termguicolors = true
