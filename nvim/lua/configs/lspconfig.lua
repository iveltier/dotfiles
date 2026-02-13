require("nvchad.configs.lspconfig").defaults()

-- local servers = { "html", "cssls", "clangd", "eslint_d" }
--
-- vim.lsp.enable(servers)

--- Nutze mason-lspconfig's automatisches Setup
require("mason-lspconfig").setup_handlers {
  -- Default handler für alle installierten Server
  function(server_name)
    vim.lsp.enable(server_name)
  end,
} --read :h vim.lsp.config for changing options of lsp servers
