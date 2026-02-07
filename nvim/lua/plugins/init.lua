return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "stevearc/oil.nvim",
    opts = {},
    -- Optional: Dependencies for icons
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("oil").setup {
        default_file_explorer = true, -- Replaces netrw
        delete_to_trash = true, -- Moves files to trash instead of deleting permanently
        skip_confirm_for_simple_edits = true,
        view_options = {
          show_hidden = true, -- Show hidden files
        },
      }
    end,
    -- Lazy load on command
    cmd = "Oil",
  },

  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
