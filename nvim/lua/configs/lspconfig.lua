require("nvchad.configs.lspconfig").defaults()

local servers = {
  "pyright", -- Python
  "clangd", -- C++
  "lua_ls"  -- LUA,
}
vim.lsp.enable(servers)

-- read : vim.lsp.config for changing options of lsp server
