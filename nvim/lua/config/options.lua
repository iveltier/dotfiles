vim.opt.number = true
vim.opt.cursorline = true

-- lsp keybinds
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.clipboard = undamedplus
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.js", "*.ts", "*.jsx", "*.tsx" },
	callback = function()
		vim.lsp.buf.format({ async = false })
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
