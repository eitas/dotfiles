local ok, ts = pcall(require, "nvim-treesitter.configs")
if not ok then return end

ts.setup {
    ensure_installed = { "python", "bash", "terraform", "lua" },
    highlight = { enable = true },
    context_commentstring = { enable = true },
}

