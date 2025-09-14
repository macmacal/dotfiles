require("nvchad.configs.lspconfig").defaults()

local servers = { "pyright", "clangd", "lua_ls" }
vim.lsp.enable(servers)

-- read : vim.lsp.config for changing options of lsp server
