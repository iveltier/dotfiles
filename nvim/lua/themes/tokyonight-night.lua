---@type Base46Table
local M = {}

-- UI (unverändert)
M.base_30 = {
  white = "#c0caf5",
  black = "#1a1b26",
  darker_black = "#16161e",
  black2 = "#24283b",
  one_bg = "#292e42",
  one_bg2 = "#3b4261",
  one_bg3 = "#414868",
  grey = "#565f89",
  grey_fg = "#737aa2",
  grey_fg2 = "#a9b1d6",
  light_grey = "#c0caf5",
  red = "#f7768e",
  baby_pink = "#ff007c",
  pink = "#bb9af7",
  line = "#292e42",
  green = "#9ece6a",
  vibrant_green = "#73daca",
  nord_blue = "#2ac3de",
  blue = "#7aa2f7",
  seablue = "#0db9d7",
  yellow = "#e0af68",
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

M.base_16 = {
  base00 = "#1a1b26",
  base01 = "#16161e",
  base02 = "#292e42",
  base03 = "#565f89",
  base04 = "#737aa2",
  base05 = "#a9b1d6",
  base06 = "#c0caf5",
  base07 = "#c0caf5",
  base08 = "#f7768e",
  base09 = "#ff9e64",
  base0A = "#e0af68",
  base0B = "#9ece6a",
  base0C = "#7dcfff",
  base0D = "#7aa2f7",
  base0E = "#bb9af7",
  base0F = "#db4b4b",
}

M.polish_hl = {
  defaults = {
    Comment = {
      fg = "#565f89",
      italic = true,
    },
  },

  treesitter = {
    -- Variablen
    ["@variable"] = { fg = "#c0caf5" },
    ["@variable.builtin"] = { fg = "#f7768e", italic = true },
    ["@variable.parameter"] = { fg = "#e0af68" }, -- Funktionsparameter
    ["@variable.member"] = { fg = "#73daca" }, -- Objekt-Properties

    -- Funktionen
    ["@function"] = { fg = "#7aa2f7" },
    ["@function.builtin"] = { fg = "#7aa2f7", italic = true },
    ["@function.call"] = { fg = "#7aa2f7" },
    ["@function.method"] = { fg = "#7aa2f7" },
    ["@function.method.call"] = { fg = "#7aa2f7" },

    -- Keywords
    ["@keyword"] = { fg = "#bb9af7" },
    ["@keyword.function"] = { fg = "#bb9af7" },
    ["@keyword.return"] = { fg = "#bb9af7" },
    ["@keyword.operator"] = { fg = "#bb9af7" },
    ["@keyword.import"] = { fg = "#bb9af7" }, -- import/export
    ["@keyword.export"] = { fg = "#bb9af7" },

    -- Konstrukte
    ["@constructor"] = { fg = "#7aa2f7" },
    ["@property"] = { fg = "#73daca" },
    ["@field"] = { fg = "#73daca" },
    ["@parameter"] = { fg = "#e0af68" },
    ["@namespace"] = { fg = "#c0caf5" },

    -- Typen
    ["@type"] = { fg = "#2ac3de" },
    ["@type.builtin"] = { fg = "#2ac3de" },
    ["@type.definition"] = { fg = "#e0af68" },
    ["@constant"] = { fg = "#ff9e64" },
    ["@constant.builtin"] = { fg = "#f7768e" },

    -- Strings & Literale
    ["@string"] = { fg = "#9ece6a" },
    ["@string.documentation"] = { fg = "#565f89" },
    ["@number"] = { fg = "#ff9e64" },
    ["@boolean"] = { fg = "#ff9e64" },

    -- Operatoren & Punctuation
    ["@operator"] = { fg = "#bb9af7" },
    ["@punctuation.bracket"] = { fg = "#a9b1d6" },
    ["@punctuation.delimiter"] = { fg = "#a9b1d6" },

    -- ========================================================================
    -- JSX/TSX SPEZIFISCHE HIGHLIGHTING
    -- ========================================================================

    -- JSX Tags: <Component /> oder <div />
    ["@tag"] = { fg = "#f7768e" }, -- HTML-Tag-Name
    ["@tag.builtin"] = { fg = "#f7768e" }, -- Eingebaute HTML-Tags
    ["@tag.delimiter"] = { fg = "#5f7e97" }, -- < > / Zeichen

    -- JSX Attribute: className, onClick, etc.
    ["@tag.attribute"] = { fg = "#e0af68" }, -- Attribut-Name
    ["@attribute"] = { fg = "#e0af68" }, -- Alternative Attribut-Gruppe

    -- JSX Expressions: {variable} oder {function()}
    ["@punctuation.special"] = { fg = "#bb9af7" }, -- { } in JSX

    -- React-spezifisch: Component-Namen (PascalCase)
    ["@type.tsx"] = { fg = "#e0af68" }, -- TypeScript-Typen in TSX
    ["@constructor.tsx"] = { fg = "#7aa2f7" }, -- React-Komponenten als Konstruktoren

    -- JavaScript/TypeScript spezifisch
    ["@keyword.import.tsx"] = { fg = "#bb9af7" },
    ["@keyword.export.tsx"] = { fg = "#bb9af7" },
    ["@variable.builtin.tsx"] = { fg = "#f7768e" }, -- this, arguments, etc.

    -- Import/Export Pfade
    ["@string.special.url"] = { fg = "#9ece6a", underline = true },
    ["@string.special.path"] = { fg = "#9ece6a" },
    -- JSX/TSX fehlende Gruppen
    ["@identifier"] = { fg = "#c0caf5" }, -- normale JSX Identifiers
    ["@identifier.jsx"] = { fg = "#e0af68" }, -- ComponentName
    ["@tag.tsx"] = { fg = "#f7768e" },
    ["@tag.attribute.tsx"] = { fg = "#e0af68" },
    ["@string.jsx"] = { fg = "#9ece6a" },
    ["@keyword.jsx"] = { fg = "#bb9af7" },

    -- LSP JSX modifiers
    ["@lsp.typemod.property.readonly"] = { fg = "#73daca" },
    ["@lsp.typemod.variable.defaultLibrary"] = { fg = "#f7768e" }, -- React, useState, etc.
    ["@lsp.typemod.member.declaration"] = { fg = "#73daca" },
    ["@lsp.typemod.function.defaultLibrary"] = { fg = "#7aa2f7" },

    -- react
    ["@constructor.jsx"] = { fg = "#e0af68" },
    ["@type.jsx"] = { fg = "#e0af68" },
    ["@tag.component"] = { fg = "#e0af68" },
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

    -- LSP Modifier für React/JSX
    ["@lsp.mod.readonly"] = { fg = "#ff9e64" },
    ["@lsp.mod.async"] = { fg = "#bb9af7", italic = true },
  },

  -- Zusätzliche Syntax-Gruppen für bessere JS/TS/JSX Unterstützung
  syntax = {
    -- JavaScript/TypeScript spezifisch
    javaScript = { fg = "#c0caf5" },
    javaScriptBraces = { fg = "#a9b1d6" },
    javaScriptNumber = { fg = "#ff9e64" },
    javaScriptNull = { fg = "#f7768e" },
    javaScriptIdentifier = { fg = "#c0caf5" },
    javaScriptFunction = { fg = "#bb9af7" },
    javaScriptStatement = { fg = "#bb9af7" },
    javaScriptReserved = { fg = "#bb9af7" },

    -- JSX spezifisch (fälback für ältere Parser)
    jsxTag = { fg = "#f7768e" },
    jsxTagName = { fg = "#f7768e" },
    jsxComponentName = { fg = "#e0af68" },
    jsxAttrib = { fg = "#e0af68" },
    jsxExpressionBlock = { fg = "#bb9af7" },
    jsxCloseString = { fg = "#5f7e97" },
  },

  git = {
    DiffAdd = { fg = "#449dab" },
    DiffChange = { fg = "#6183bb" },
    DiffDelete = { fg = "#914c54" },
  },

  telescope = {
    TelescopeBorder = { fg = "#292e42" },
    TelescopePromptBorder = { fg = "#292e42" },
    TelescopeResultsBorder = { fg = "#292e42" },
    TelescopePreviewBorder = { fg = "#292e42" },
  },
}

M.type = "dark"

M = require("base46").override_theme(M, "tokyonight-night")

return M
