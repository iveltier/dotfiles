return {
    'goolord/alpha-nvim',
    dependencies = {
        'echasnovski/mini.icons',
        'nvim-lua/plenary.nvim'
    },
    config = function()
        local alpha = require("alpha")
        local custom = require("plugins.customthemes.custom")
        alpha.setup(custom.config)
    end
};
