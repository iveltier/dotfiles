-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :(

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "bearded-arc",
  transparency = true,

  -- hl_override = {
  -- 	Comment = { italic = true },
  -- 	["@comment"] = { italic = true },
  -- },
}

M.nvdash = {
  load_on_startup = true,
}

M.ui = {
  tabufline = {
    lazyload = true,
  },
  statusline = {
    theme = "default",
    separator_style = "round",
    order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cwd", "icon", "cursor" },
    modules = {

      icon = function()
        local icons = { " ", "  ", " ", "󱢇 ", " ", " " }
        math.randomseed(os.time())
        return icons[math.random(#icons)]
      end,

      f = "%F",
    },
  },
}

return M
