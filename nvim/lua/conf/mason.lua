require("mason").setup()
require("mason-lspconfig").setup {
  ensure_installed = { "lua_ls", "bashls", "dockerls", "docker_compose_language_service", "pyright", "terraformls" }
}

