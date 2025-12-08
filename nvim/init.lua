require("config.keybinds")
require("config.lazy")
require("config.options")
vim.cmd("colorscheme tokyonight")

local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		-- Prettier über Mason
		null_ls.builtins.formatting.prettierd.with({
			extra_args = { "--semi", "true" }, -- erzwingt Semikolons
		}),

		-- oder ESLint Autofix
		null_ls.builtins.diagnostics.eslint_d,
		null_ls.builtins.code_actions.eslint_d,
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_create_autocmd("BufWritePre", {
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ bufnr = bufnr })
				end,
			})
		end
	end,
})
