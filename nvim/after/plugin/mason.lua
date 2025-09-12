-- Mason setup 
require("mason").setup()

-- Mason-LSPConfig (bridge Mason <-> lspconfig)
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "pyright", "clangd" }, 
    automatic_installation = true,
})
