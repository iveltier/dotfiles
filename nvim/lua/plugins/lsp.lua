return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "stevearc/conform.nvim",   -- neuer Formatter
    },
    config = function()
      -- Mason Setup
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",        -- neuer Name statt tsserver
          "eslint",
          "tailwindcss",
        },
      })

      -- Neue API: vim.lsp.config statt lspconfig.setup
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      vim.lsp.config("ts_ls", {})
      vim.lsp.config("eslint", {})
      vim.lsp.config("tailwindcss", {})

      -- Conform Setup für Formatierung
      require("conform").setup({
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
        formatters_by_ft = {
          javascript = { "prettierd" },
          typescript = { "prettierd" },
          javascriptreact = { "prettierd" },
          typescriptreact = { "prettierd" },
          json = { "prettierd" },
          css = { "prettierd" },
          html = { "prettierd" },
        },
      })
    end,
  },
}

