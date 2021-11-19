require('telescope').setup({
  defaults = {
    prompt_prefix = "> "    
  }
})
require('telescope').load_extension('fzf')

vim.api.nvim_set_keymap('n', '<leader>ff', "<cmd>lua require('telescope.builtin').find_files()<cr>", {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fg', "<cmd>lua require('telescope.builtin').git_files()<cr>", {noremap = true})
vim.api.nvim_set_keymap('n', '<leader>fb', "<cmd>lua require('telescope.builtin').buffers()<cr>", {noremap = true})
-- Need to study the next one before enabling.  Need to get LSPs setup
-- vim.api.nvim_set_keymap('n', '<leader>gr', "<cmd>lua require('telescope.builtin').lsp_references()<cr>", {noremap = true})


