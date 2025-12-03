return {
	'barrett-ruth/live-server.nvim',
	build = 'pnpm add -g live-server',
	cmd = { 'LiveServerStart', 'LiveServerStop' },
	config = true,
	keys = {
		{
			"<leader>ls",
			"<cmd>LiveServerStart<cr>",
			desc = "Start Live Server",
		},
		{
			"<leader>lx",
			"<cmd>LiveServerStop<cr>",
			desc = "Start Live Server",
		},
	},
}
