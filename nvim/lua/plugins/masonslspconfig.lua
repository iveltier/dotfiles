return {
    {
        "williamboman/mason.nvim",
        opts = {},
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        opts = {
            automatic_installation = true,
        },
        -- config = function()
        --     require("mason-lspconfig").setup {
        --         ensure_installed = { "clangd", "html", "cssls", "vtsls" },
        --         automatic_installation = true,
        --     }
        -- end,
    },
}
