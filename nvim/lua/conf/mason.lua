require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "pyright", "bashls", "terraformls" },
  handlers = {
    function(server_name)
      require("lspconfig")[server_name].setup({
        capabilities = require('cmp_nvim_lsp').default_capabilities(),
      })
    end,
  },
})
