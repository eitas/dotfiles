local lsps = {
  {"pyright-langserver"},
  {"bash-language-server"},
  {"terraform-ls"},
}

for _, lsp in pairs(lsps) do
  local name, config = lsp[1], lsp[2]
  vim.lsp.enable(name)
  if config then
    vim.lsp.config(name, config)
  end
end




--vim.lsp.config('
--
--
--local lspconfig_util = vim.lsp.config(util)
--
--local servers = {
--    pyright = { cmd = { "pyright-langserver", "--stdio" }, filetypes = { "python" } },
--    bashls = { cmd = { "bash-language-server", "start" }, filetypes = { "sh" } },
--    terraformls = { cmd = { "terraform-ls", "serve" }, filetypes = { "terraform", "tf" } },
--}
--
--for name, config in pairs(servers) do
--    vim.api.nvim_create_autocmd("FileType", {
--        pattern = config.filetypes,
--        callback = function()
--            vim.lsp.start({
--                name = name,
--                cmd = config.cmd,
--                root_dir = lspconfig_util.root_pattern(".git", "."),
--            })
--        end,
--    })
--end
--
