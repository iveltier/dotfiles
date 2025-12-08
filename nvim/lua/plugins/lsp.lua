return {
    {
        "williamboman/mason.nvim",
        dependencies = {
            "mason-org/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
            "nvimtools/none-ls.nvim",       -- Fork von null-ls
            "jay-babu/mason-null-ls.nvim", -- Mason Integration
        },
        opts = {
            servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { "vim" }
                            },
                        },
                    },
                },
                tsserver = {},    -- JavaScript/TypeScript
                eslint = {},      -- ESLint
                tailwindcss = {}, -- TailwindCSS
            },
        },
        config = function(_, opts)
            local mason = require("mason")
            local mason_lspconfig = require("mason-lspconfig")
            local lspconfig = require("lspconfig")
            local null_ls = require("null-ls") -- Modulname bleibt "null-ls"
            local mason_null_ls = require("mason-null-ls")

            -- Mason Setup
            mason.setup()
            mason_lspconfig.setup({
                ensure_installed = { "lua_ls", "tsserver", "eslint", "tailwindcss" },
            })

            -- LSP Server Setup (direkt, ohne setup_handlers)
            for server, config in pairs(opts.servers) do
                lspconfig[server].setup(config)
            end

            -- Formatter & Linter via none-ls (require("null-ls"))
            mason_null_ls.setup({
                ensure_installed = { "prettier", "eslint_d" },
            })

            null_ls.setup({
                sources = {
                    -- Prettier mit Semikolon
                    null_ls.builtins.formatting.prettier.with({
                        extra_args = { "--semi", "true", "--single-quote", "true" },
                    }),
                    -- ESLint
                    null_ls.builtins.diagnostics.eslint_d,
                    null_ls.builtins.code_actions.eslint_d,
                },
            })

            -- Autoformat bei Save
            vim.api.nvim_create_autocmd("BufWritePre", {
                callback = function()
                    vim.lsp.buf.format({ async = false })
                end,
            })
        end,
    },
}

