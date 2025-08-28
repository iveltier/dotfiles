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
}
