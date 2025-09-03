--activate lsp
vim.lsp.enable( "lua_ls" )

-- autocompletion
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end

		-- Keybindings für LSP-Funktionen
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	end,
})

-- Formatierung beim Speichern
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(args)
		vim.lsp.buf.format({ bufnr = args.buf })
	end,
})
-- Fehlerdiagnosen als virtuelle Textzeilen anzeigen
vim.diagnostic.config({
	virtual_text = true,
	virtual_lines = false,
})
