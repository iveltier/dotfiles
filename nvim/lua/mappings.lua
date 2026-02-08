require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

-- debug
map("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>", { desc = "DEBUGGER toggle debugger" })
map("n", "<leader>dr", "<cmd> DapContinue <CR>", { desc = "DEBUGGER start or continue debugger" })

-- oil
map("n", "<leader>cd", vim.cmd.Oil, { desc = "OIL enable oil tree" })

-- idk
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

-- run cpp code terminal
local term = require "nvchad.term"

vim.keymap.set({ "n", "t" }, "<A-r>", function()
  term.runner {
    pos = "float",
    id = "cpp_float_runner",
    clear_cmd = "", -- wichtig: kein boolean, sonst NVChad-Fehler

    cmd = function()
      local dir = vim.fn.expand "%:p:h"
      local file = vim.fn.expand "%:t"
      local name = vim.fn.expand "%:r"

      return string.format("cd '%s' && cpp '%s' && './%s'", dir, file, name)
    end,
  }
end)

map({ "n", "t" }, "<A-f>", function()
  term.toggle {
    pos = "float",
    id = "cd_term",
    cmd = function()
      local dir = vim.fn.expand "%:p:h"
      return "cd '" .. dir .. "'"
    end,
  }
end)
