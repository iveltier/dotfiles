---@type Base46Table
local M = {}

-- UI
M.base_30 = {
  white = "#c0caf5",
  black = "#1a1b26", -- bg
  darker_black = "#16161e", -- 6% darker than black
  black2 = "#24283b", -- 6% lighter than black
  one_bg = "#292e42", -- 10% lighter than black
  one_bg2 = "#3b4261", -- 6% lighter than one_bg
  one_bg3 = "#414868", -- 6% lighter than one_bg2
  grey = "#565f89", -- 40% lighter than black
  grey_fg = "#737aa2", -- 10% lighter than grey
  grey_fg2 = "#a9b1d6", -- 5% lighter than grey
  light_grey = "#c0caf5",
  red = "#f7768e",
  baby_pink = "#ff007c",
  pink = "#bb9af7",
  line = "#292e42", -- 15% lighter than black
  green = "#9ece6a",
  vibrant_green = "#73daca",
  nord_blue = "#2ac3de",
  blue = "#7aa2f7",
  seablue = "#0db9d7",
  yellow = "#e0af68", -- 8% lighter than yellow
  sun = "#ff9e64",
  purple = "#9d7cd8",
  dark_purple = "#bb9af7",
  teal = "#1abc9c",
  orange = "#ff9e64",
  cyan = "#7dcfff",
  statusline_bg = "#16161e",
  lightbg = "#292e42",
  pmenu_bg = "#7aa2f7",
  folder_bg = "#7aa2f7",
}

-- check https://github.com/chriskempson/base16/blob/master/styling.md for more info
M.base_16 = {
  base00 = "#1a1b26", -- Default Background
  base01 = "#16161e", -- Lighter Background (Used for status bars, line number and folding marks)
  base02 = "#292e42", -- Selection Background
  base03 = "#565f89", -- Comments, Invisibles, Line Highlighting
  base04 = "#737aa2", -- Dark Foreground (Used for status bars)
  base05 = "#a9b1d6", -- Default Foreground, Caret, Delimiters, Operators
  base06 = "#c0caf5", -- Light Foreground (Not often used)
  base07 = "#c0caf5", -- Light Background (Not often used)
  base08 = "#f7768e", -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
  base09 = "#ff9e64", -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
  base0A = "#e0af68", -- Classes, Markup Bold, Search Text Background
  base0B = "#9ece6a", -- Strings, Inherited Class, Markup Code, Diff Inserted
  base0C = "#7dcfff", -- Support, Regular Expressions, Escape Characters, Markup Quotes
  base0D = "#7aa2f7", -- Functions, Methods, Attribute IDs, Headings
  base0E = "#bb9af7", -- Keywords, Storage, Selector, Markup Italic, Diff Changed
  base0F = "#db4b4b", -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
}

-- OPTIONAL
M.polish_hl = {
  defaults = {
    Comment = {
      fg = "#565f89",
      italic = true,
    },
  },

  treesitter = {
    ["@variable"] = { fg = "#c0caf5" },
    ["@variable.builtin"] = { fg = "#f7768e", italic = true },
    ["@function.builtin"] = { fg = "#7aa2f7", italic = true },
    ["@keyword.function"] = { fg = "#bb9af7" },
    ["@keyword.return"] = { fg = "#bb9af7" },
    ["@keyword.operator"] = { fg = "#bb9af7" },
    ["@constructor"] = { fg = "#7aa2f7" },
    ["@tag"] = { fg = "#f7768e" },
    ["@tag.attribute"] = { fg = "#e0af68" },
    ["@tag.delimiter"] = { fg = "#5f7e97" },
    ["@property"] = { fg = "#73daca" },
    ["@field"] = { fg = "#73daca" },
    ["@parameter"] = { fg = "#e0af68" },
    ["@namespace"] = { fg = "#c0caf5" },
    ["@type.builtin"] = { fg = "#2ac3de" },
    ["@constant.builtin"] = { fg = "#f7768e" },
  },

  semantic_tokens = {
    ["@lsp.type.class"] = { fg = "#e0af68" },
    ["@lsp.type.decorator"] = { fg = "#7aa2f7" },
    ["@lsp.type.enum"] = { fg = "#e0af68" },
    ["@lsp.type.enumMember"] = { fg = "#7dcfff" },
    ["@lsp.type.function"] = { fg = "#7aa2f7" },
    ["@lsp.type.interface"] = { fg = "#e0af68" },
    ["@lsp.type.macro"] = { fg = "#7aa2f7" },
    ["@lsp.type.method"] = { fg = "#7aa2f7" },
    ["@lsp.type.namespace"] = { fg = "#c0caf5" },
    ["@lsp.type.parameter"] = { fg = "#e0af68" },
    ["@lsp.type.property"] = { fg = "#73daca" },
    ["@lsp.type.struct"] = { fg = "#e0af68" },
    ["@lsp.type.type"] = { fg = "#2ac3de" },
    ["@lsp.type.typeParameter"] = { fg = "#2ac3de" },
    ["@lsp.type.variable"] = { fg = "#c0caf5" },
  },

  git = {
    DiffAdd = { fg = "#449dab" },
    DiffChange = { fg = "#6183bb" },
    DiffDelete = { fg = "#914c54" },
  },

  nvimtree = {
    NvimTreeFolderIcon = { fg = "#7aa2f7" },
    NvimTreeIndentMarker = { fg = "#3b4261" },
  },

  telescope = {
    TelescopeBorder = { fg = "#292e42" },
    TelescopePromptBorder = { fg = "#292e42" },
    TelescopeResultsBorder = { fg = "#292e42" },
    TelescopePreviewBorder = { fg = "#292e42" },
  },
}

M.type = "dark"

M = require("base46").override_theme(M, "tokyonight")

return M
