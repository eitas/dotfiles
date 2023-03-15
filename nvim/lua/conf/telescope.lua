require('telescope').setup({
  defaults = {
    prompt_prefix = "> "    
  }
})
require('telescope').load_extension('fzf')

local builtin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input('Grep > ') })
end)
  
-- Need to study the next one before enabling.  Need to get LSPs setup
-- vim.api.nvim_set_keymap('n', '<leader>gr', "<cmd>lua require('telescope.builtin').lsp_references()<cr>", {noremap = true})


