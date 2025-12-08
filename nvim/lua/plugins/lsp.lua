return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "jose-elias-alvarez/null-ls.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      -- Mason Setup
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "tsserver",      -- für JS/TS
          "eslint",        -- optional
          "tailwindcss",   -- falls du Tailwind nutzt
        },
      })

      local lspconfig = require("lspconfig")

      -- LSP Server Setup
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })

      lspconfig.tsserver.setup({})
      lspconfig.eslint.setup({})
      lspconfig.tailwindcss.setup({})

      -- null-ls Setup für Formatierung
      local null_ls = require("null-ls")

      null_ls.setup({
        sources = {
          -- Prettier Daemon (installiert via :MasonInstall prettierd)
          null_ls.builtins.formatting.prettierd.with({
            extra_args = { "--semi", "true" }, -- erzwingt Semikolons
          }),

          -- Optional: ESLint für zusätzliche Checks
          null_ls.builtins.diagnostics.eslint_d,
          null_ls.builtins.code_actions.eslint_d,
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
              end,
            })
          end
        end,
      })
    end,
  },
}

