vim.opt.number = true
vim.opt.cursorline = true

-- options
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.clipboard = unnamedplus
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.js", "*.ts", "*.jsx", "*.tsx" },
	callback = function()
		vim.lsp.buf.format({ async = false })
	end,
})

-- diagnostics
vim.diagnostic.config({
	virtual_text = true
})
-- format on save
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(args)
		vim.lsp.buf.format({ bufnr = args.buf })
	end,
})
