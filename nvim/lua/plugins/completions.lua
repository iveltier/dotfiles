return {
	'saghen/blink.cmp',
	-- optional: provides snippets for the snippet source
	dependencies = { 'rafamadriz/friendly-snippets' },

	version = '1.*',
	opts = {
		["<CR>"] = {
			-- 1. Wenn Menü offen, Eintrag akzeptieren + Enter einfügen
			function(cmp)
				if cmp.visible() then
					-- Eintrag einfügen
					cmp.accept({ select = true })
					-- echten CR nachschicken
					local cr = vim.api.nvim_replace_termcodes("<CR>", true, false, true)
					vim.api.nvim_feedkeys(cr, "i", false)
					return true -- keine weiteren Mappings ausführen
				end
			end,
			-- 2. Ist Menü nicht sichtbar -> normaler Enter
			"fallback",
		},
		["<C><leader>"] = { "show" },
		appearance = {
			nerd_font_variant = 'mono'
		},

		completion = { documentation = { auto_show = true } },

		sources = {
			default = { 'lsp', 'path', 'snippets', 'buffer' },
		},

		fuzzy = { implementation = "prefer_rust_with_warning" }
	},
	opts_extend = { "sources.default" }
}
