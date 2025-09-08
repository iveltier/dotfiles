return {
	{
		"williamboman/mason.nvim",
		dependencies = {
			"mason-org/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			servers = {
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = {
								globals = { "vim" }
							},
						},
					},
				},
				ts_ls = {},
				eslint = {},
				tailwindcss = {},
			},
		},
		config = function(_, opts)
			require("mason").setup()
			require("mason-lspconfig").setup(
				{ ensure_installed = { "lua_ls" } }
			)

			for server, config in pairs(opts.servers) do
				vim.lsp.config(server, config)
				vim.lsp.enable(server)
			end
		end
	},
}
