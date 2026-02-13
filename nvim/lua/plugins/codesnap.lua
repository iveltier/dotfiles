return {
  "mistricky/codesnap.nvim",
  tag = "v1.6.3",
  build = "make",
  event = "VeryLazy",
  config = function()
    require("codesnap").setup {
      show_line_number = true,
      save_path = os.getenv "HOME" .. "/Pictures/codesnap/",
    }
  end,
}
