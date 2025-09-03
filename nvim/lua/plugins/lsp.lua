return {
	{
		"williamboman/mason.nvim",
		dependencies = {
			"mason-org/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup(
				{ ensure_installed = { "lua_ls", "eslint" } }
			)

			-- format on save
			vim.api.nvim_create_autocmd("BufWritePre", {
				callback = function(args)
					vim.lsp.buf.format({ bufnr = args.buf })
				end,
			})

			-- diagnostics
			vim.diagnostic.config({
				-- virtual_lines = true

				-- Alternatively, customize specific options
				virtual_lines = {
					-- Only show virtual line diagnostics for the current cursor line
					current_line = true,
				}
			})

			vim.lsp.enable("lua_ls")
		end
	},
}
