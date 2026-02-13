-- require("nvchad.configs.lspconfig").defaults()
--
-- local servers = { "html", "cssls", "clangd", "eslint_d" }
--
-- vim.lsp.enable(servers)

--- Nutze mason-lspconfig's automatisches Setup
--read :h vim.lsp.config for changing options of lsp servers
require("nvchad.configs.lspconfig").defaults()

-- Automatisch alle Mason-LSPs aktivieren
for _, server in ipairs(require("mason-lspconfig").get_installed_servers()) do
  vim.lsp.enable(server)
end
