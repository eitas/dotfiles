local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')
-- My plugins!
Plug '~/Documents/02_Home/04_Vim_Plugins/vim-trello'

-- Language Server Protocol
Plug 'neovim/nvim-lspconfig'
-- nedev.nvim -- allows development of plugins
Plug 'folke/neodev.nvim'
-- nvim-cmp
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
-- luasnip
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'
-- Treesitter - getting more language support
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
-- Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
vim.cmd("Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }")
-- Adding snippet capability
-- Plug 'SirVer/ultisnips'
-- Linting
Plug 'dense-analysis/ale'
-- Nerdtree - File viewer / manager
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
-- Git support
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'airblade/vim-gitgutter'
-- Comments
Plug 'tpope/vim-commentary'
-- Surround
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
-- Status line
Plug 'vim-airline/vim-airline'
-- Code browsing
Plug 'vim-scripts/taglist.vim'
-- Python Black see https://black.readthedocs.io/en/stable/integrations/editors.html#vim
-- 2021-10-21 Getting an issue with no attribute 'find_pyproject_toml'
-- So still not working on the stable branch
Plug('psf/black', { ['branch'] = 'stable' })
-- Plug 'psf/black', { 'commit': 'ce14fa8b497bae2b50ec48b3bd7022573a59cdb1' }

-- Terraform, allows for terraform fmt to format terraform
Plug 'hashivim/vim-terraform'

-- Other plugins to consider
-- SimpylFold
-- coc.nvim - though I think Telescope will cover this
-- fzf - again I think telescope will cover this
-- typescript-vim but I wonder if there is a LSP for this now

vim.call('plug#end')
