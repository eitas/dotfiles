-- lazy.nvim plugin specs
-- Migrated from vim-plug. Run :Lazy to manage plugins.
return {

  -- LSP management via Mason (replaces global npm installs)
  { 'neovim/nvim-lspconfig' },
  { 'williamboman/mason.nvim' },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = {
      'williamboman/mason.nvim',
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
    },
    config = function() require('conf.mason') end,
  },

  -- Lua dev tooling (replaces deprecated neodev.nvim)
  { 'folke/lazydev.nvim', ft = 'lua', opts = {} },

  -- Completion
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-cmdline' },
  { 'L3MON4D3/LuaSnip' },
  { 'saadparwaiz1/cmp_luasnip' },
  {
    'hrsh7th/nvim-cmp',
    config = function() require('conf.nvim-cmp') end,
  },

  -- Treesitter
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function() require('conf.treesitter') end,
  },
  { 'JoosepAlviste/nvim-ts-context-commentstring' },

  -- Telescope
  { 'nvim-lua/plenary.nvim' },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function() require('conf.telescope') end,
  },

  -- File tree (replaces NerdTree + vim-devicons + vim-nerdtree-syntax-highlight)
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function() require('conf.nerdtree') end,
  },

  -- Git
  { 'tpope/vim-fugitive' },
  { 'tpope/vim-rhubarb' },
  { 'lewis6991/gitsigns.nvim', opts = {} },   -- replaces vim-gitgutter

  -- Editing utilities
  { 'tpope/vim-commentary' },
  { 'tpope/vim-surround' },
  { 'tpope/vim-repeat' },

  -- Status line (replaces vim-airline)
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = { options = { theme = 'gruvbox' } },
  },

  -- Python formatting
  { 'psf/black', branch = 'stable' },

  -- Terraform
  { 'hashivim/vim-terraform' },

}
