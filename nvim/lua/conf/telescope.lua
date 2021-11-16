require('telescope').setup({
  defaults = {
    prompt_prefix = "> "    
  }
})
require('telescope').load_extension('fzf')

-- nnoremap <leader>ff <cmd>lua require'telescope.builtin'.find_files{}<CR>
-- nnoremap <leader>fg <cmd>lua require'telescope.builtin'.git_files{}<CR>
-- nnoremap <leader>fb <cmd>lua require'telescope.builtin'.buffers{}<CR>
-- Need to study the next one before enabling.  Need to get LSPs setup
-- nnoremap <leader>gr <cmd>lua require'telescope.builtin'.lsp_references{}<CR>


