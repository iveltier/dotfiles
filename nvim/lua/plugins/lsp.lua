return {
	{
		"williamboman/mason.nvim",
		dependencies = {
			"mason-org/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
			"stevearc/conform.nvim",
		},
		opts = {
			servers = {
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" },
							},
						},
					},
				},
			},
		},
		config = function(_, opts)
			require("mason").setup()
			require("mason-lspconfig").setup({ ensure_installed = { "lua_ls" } })

			for server, config in pairs(opts.servers) do
				vim.lsp.config(server, config)
				vim.lsp.enable(server)
			end

			require("conform").setup({
				formatters_by_ft = {
					javascript = { "prettierd" },
					typescript = { "prettierd" },
					javascriptreact = { "prettierd" },
					typescriptreact = { "prettierd" },
					html = { "prettierd" },
					css = { "prettierd" },
					lua = { "stylua" },
				},
			})

			-- Format on save
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.css", "*.html", "*.lua" },
				callback = function(args)
					require("conform").format({ bufnr = args.buf })
				end,
			})
		end,
	},
}
