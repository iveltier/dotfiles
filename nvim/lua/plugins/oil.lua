return {
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
        natural_order = true,
        show_hidden = true, -- Show hidden files
      },
      win_options = {
        wrap = true,
      },
    }
  end,
  -- Lazy load on command
  cmd = "Oil",
}
