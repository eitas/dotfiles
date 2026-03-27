-- Shared keybindings (terminal + VSCode)
vim.api.nvim_set_keymap('i', 'jk', '<esc>', {noremap = true})
if not vim.g.vscode then
  vim.api.nvim_set_keymap('i', '<esc>', '<nop>', {noremap = true})
end

vim.api.nvim_set_keymap('n', 'n', 'nzz', {noremap = false})
vim.api.nvim_set_keymap('n', 'N', 'Nzz', {noremap = false})
vim.api.nvim_set_keymap('n', '*', '*zz', {noremap = false})

if not vim.g.vscode then
  -- Window navigation (terminal only — VSCode handles its own splits)
  vim.api.nvim_set_keymap('n', '<C-J>', '<C-W><C-J>', {noremap = true})
  vim.api.nvim_set_keymap('n', '<C-K>', '<C-W><C-K>', {noremap = true})
  vim.api.nvim_set_keymap('n', '<C-L>', '<C-W><C-L>', {noremap = true})
  vim.api.nvim_set_keymap('n', '<C-H>', '<C-W><C-H>', {noremap = true})

  vim.api.nvim_set_keymap('n', '<leader>ev', ':vsplit $MYVIMRC<cr>', {noremap = true})
  vim.api.nvim_set_keymap('n', '<leader>sv', ':source $MYVIMRC<cr>', {noremap = true})
end
