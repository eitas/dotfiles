-- nvim-tree config (this file was formerly NerdTree config; same filename kept
-- so neovim_bootstrap.sh symlinks continue to work without changes)
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = { width = 30 },
  renderer = { group_empty = true },
  filters = { dotfiles = false },
})

vim.keymap.set('n', '<leader>n', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>N', ':NvimTreeFindFile<CR>', { noremap = true, silent = true })
