return {
	{ -- helps with ssh tunneling and copyin to clipboard
		"ojroques/vim-oscyank",
	},
	{ -- git plugin
		"tpope/vim-fugitive",
	},
	{ --css colors
		"brenoprata10/nvim-highlight-colors",
		config = function()
			require("nvim-highlight-colors").setup({})
		end
	},
	{ --lorem
		'derektata/lorem.nvim',
		config = function()
			require("lorem").opts {
				sentence_length = "mixed", -- using a default configuration
				comma_chance = 0.3, -- 30% chance to insert a comma
				max_commas = 2, -- maximum 2 commas per sentence
				debounce_ms = 200, -- default debounce time in milliseconds
			}
		end
	}

}
