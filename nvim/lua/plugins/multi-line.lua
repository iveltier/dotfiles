return {
	'smoka7/multicursors.nvim',
	event = 'VeryLazy',
	dependencies = {
		'nvimtools/hydra.nvim', -- statt 'smoka7/hydra.nvim'
		'nvim-treesitter/nvim-treesitter',
	},
	opts = {},
	cmd = {
		'MCstart', 'MCvisual', 'MCclear',
		'MCpattern', 'MCvisualPattern', 'MCunderCursor'
	},
	keys = {
		{
			mode = { 'v', 'n' },
			'<Leader>m',
			'<cmd>MCstart<CR>',
			desc = 'Multi cursors',
		},
	},
}
