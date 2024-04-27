-- stoopid config written by jobcmax
-- need https://github.com/tpope/vim-commentary
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

source ~/.config/nvim/comment.vim 
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
  "feline-nvim/feline.nvim",
  "lukas-reineke/indent-blankline.nvim",
  "ptzz/lf.vim",
  "jiangmiao/auto-pairs",
  -- "preservim/nerdtree",
  "nvim-treesitter/nvim-treesitter",
  "kyazdani42/nvim-web-devicons",
  "norcalli/nvim-colorizer.lua",
  "akinsho/bufferline.nvim",
  -- "rafamadriz/friendly-snippets",
  -- "hrsh7th/vim-vsnip",
  "neovim/nvim-lspconfig",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/nvim-cmp",
  "RRethy/nvim-base16",
  "karb94/neoscroll.nvim",
  "nvim-tree/nvim-tree.lua"
})

require('decay').setup({
  style = 'dark',
  nvim_tree = {
    contrast = true,
  },
})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
-- require('neoscroll').setup()
-- require("nvim-tree").setup()
require('statusline')
-- require('color')
require'colorizer'.setup()
-- require('completion')
